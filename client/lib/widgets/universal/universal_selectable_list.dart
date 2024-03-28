import 'dart:async';

import 'package:client/classes/selectable_list.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/classes/utilizable.dart';
import 'package:client/classes/utilizable_state.dart';
import 'package:client/enum/svg.dart';
import 'package:client/utils/call_utils.dart';
import 'package:client/utils/scroll_utils.dart';
import 'package:client/utils/svg_utils.dart';
import 'package:client/utils/widget_utils.dart';
import 'package:client/widgets/font_icon.dart';
import 'package:client/widgets/universal/universal_field.dart';
import 'package:client/widgets/universal/universal_field_context.dart';
import 'package:client/widgets/universal/universal_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../material/loading_indicator.dart';

export 'package:client/widgets/universal/universal_field_cancel.dart';
export 'package:client/widgets/universal/universal_query.dart';

typedef UniversalTileMapper<I extends UniversalItem> = UniversalSelectableTile Function(I item, VoidCallback onTap);

class UniversalSelectableList<I extends UniversalItem> extends StatefulWidget {

  final int itemsToShow;
  final UniversalTileMapper<I> toTile;
  final UniversalSelectableListController<I> controller;

  const UniversalSelectableList({ required this.toTile, required this.controller, this.itemsToShow = WidgetUtils.itemsToShow, super.key});

  @override
  State<StatefulWidget> createState() => UniversalSelectableListState<I>();


  static FontIcon toRadio(bool selected) {
    return selected ? FontIcon.circleDot : FontIcon.circleEmpty;
  }


}
class UniversalSelectableListController<I extends UniversalItem> with Utilizable, Utilizables {

  late final Rx<bool> isLoading; // first time
  late final Rx<bool> isUploading; // more results
  late final Rx<SelectableList<I>> list;

  late final _scrollToSelected = u(0.obs);

  scrollToSelected() {
    _scrollToSelected.value++;
  }

  StreamSubscription<int> listenToScroll(Function() fn) {
    return _scrollToSelected.listen((_) => fn.call());
  }

  UniversalSelectableListController({ bool isLoading = false, bool isUploading = false, List<I>? values, I? selected}) {

    final index = !isLoading && selected != null && values != null ? values.indexOf(selected) : null;
    final selectable = values != null ? SelectableList<I>(values, index: index) : SelectableList<I>(<I>[]);
    list = u(selectable.obs);
    this.isLoading = u(isLoading.obs);
    this.isUploading = u(isUploading.obs);
  }

  void setList(List<I> content, {int? index}) {
    bool saveScrollPosition = index == null;
    list.value = SelectableList(content, index: saveScrollPosition ? list.value.index : index);
    if (!saveScrollPosition) scrollToSelected();
  }


}

class UniversalSelectableListState<I extends UniversalItem> extends UtilizableState<UniversalSelectableList<I>> {

  final ScrollController _scrollController = ScrollController();

  int get _effectiveItemsToShow => WidgetUtils.maxItemToShowInModal(widget.itemsToShow);
  UniversalSelectableListController<I> get controller => widget.controller;

  scrollToSelected() {
    ScrollUtils.animateTo(_scrollController, controller.list.value.scrollIndex(_effectiveItemsToShow) * sizes.selectableTileHeight);
  }

  @override
  void initState() {
    super.initState();

    u(controller.listenToScroll(() => CallUtils.defer(scrollToSelected)));

    listenUniversal((event, payload) {
      switch (event) {
        case UniversalEvent.arrowDown:
          controller.list.value = controller.list.value.nextIndex();
          CallUtils.defer(scrollToSelected);
          break;
        case UniversalEvent.arrowUp:
          controller.list.value = controller.list.value.previousIndex();
          CallUtils.defer(scrollToSelected);
          break;
        case UniversalEvent.submit:
          final selected = controller.list.value.selected;
          if (selected != null) {
            UniversalFieldContext.closeWith(context, selected);
          }
          break;
        default:
          break;
      }
    });

    if (!controller.isLoading.value) {
      CallUtils.defer(scrollToSelected);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Obx(() {

      final height = WidgetUtils.minModalContentSize(widget.itemsToShow);

      if (controller.isLoading.value) {
        return fixHeight(height, const Center(child: LoadingIndicator.circular(size: SizeVariant.xl)));
      }

      final selectableList = controller.list.value;
      var uploadingIndex = -1;
      var itemCount = selectableList.length;
      if (controller.isUploading.value) {
        uploadingIndex = selectableList.length;
        itemCount++;
      }

      if (itemCount == 0) {
        return fixHeight(height, context.toSvgLD(Illustration.emptyResult, height: height * 0.5));
      }

      final value = UniversalFieldContext.selectedItem(context);

      final list = CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverFixedExtentList(
            itemExtent: sizes.selectableTileHeight,
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {

                    if (index >= controller.list.value.length - _effectiveItemsToShow && !controller.isUploading.value && !controller.isLoading.value) {
                      CallUtils.defer(() {
                        UniversalFieldContext.trigger(context, UniversalEvent.uploadMore);
                      });
                    }

                    if (index == uploadingIndex) {
                      return SizedBox(height: sizes.selectableTileHeight, child: const Center(child: LoadingIndicator.circular(size: SizeVariant.md)));
                    }

                    I item = selectableList.at(index);

                    item.focused = index == controller.list.value.index;
                    item.selected = item == value;

                    final tile = widget.toTile(item, () {
                      controller.list.value = controller.list.value.copyWith(index: index);
                      UniversalFieldContext.submit(context);
                    });

                    return tile;
              },
              childCount: itemCount,
            ),
          ),
        ],
      );

      return fixHeight(height, Material(child: list));
    });
  }


  static Widget fixHeight(double height, Widget child) {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: height, maxHeight: height),
        child: child
    );
  }

}