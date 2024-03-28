

import 'package:client/@app/controllers/json_asset.dart';
import 'package:client/classes/utilizable_state.dart';
import 'package:client/enum/country_code.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/utils/convert_utils.dart';
import 'package:client/utils/validate_utils.dart';
import 'package:client/widgets/modal.dart';
import 'package:client/widgets/universal/universal_field.dart';
import 'package:client/widgets/universal/universal_item.dart';
import 'package:flutter/material.dart';


class UniversalCountryCode extends UniversalItem<CountryCode> {

  UniversalCountryCode(super.value);

  static UniversalCountryCode? fromCode(CountryCode? countryCode) {
    if (countryCode == null) return null;
    return UniversalCountryCode(countryCode);
  }

}


class CountryField extends StatefulWidget {

  final UniversalController<UniversalCountryCode> controller;
  const CountryField(this.controller, {super.key});

  @override
  State<StatefulWidget> createState() => _CountryFieldState();


}


class _CountryFieldState extends UtilizableState<CountryField> {

  static List<UniversalCountryCode> _cache = [];

  static bool get isLoaded => _cache.isNotEmpty;

  UniversalController<UniversalCountryCode> get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {

    controller.loading = !isLoaded;

    if (!isLoaded) {
      final countryJson = JsonAsset(name: "country", mapper: (Json countries) => UniversalItem.toLocalized(countries, (_) => CountryCode.values, UniversalCountryCode.new));
      final loaded = await countryJson.load();
      _cache = UniversalItem.sortByTitle(loaded);
    }

    final current = _cache.selectBasedOn(controller.value);
    controller.loaded(current);
  }

  @override
  Widget build(BuildContext context) {
    return UniversalField<UniversalCountryCode>(
        title: 'countryField_title'.T,
        placeholder: 'countryField_placeholder'.T,
        controller: controller,
        toModal: toModal,
        validator: ValidateUtils.requiredUniversal
    );
  }

  Modal toModal(UniversalField<UniversalCountryCode> field) {

    if (!isLoaded) throw "Country codes wasn't loaded, check why it's happen";

    final controller = UniversalSelectableListController(values:_cache, selected: field.selected);

    final list = UniversalSelectableList<UniversalCountryCode>(controller: controller, toTile: (item, onTap) {
      return UniversalSelectableTile(leading: UniversalSelectableList.toRadio(item.selected), title: item.title, subtitle: item.subtitle, selected: item.focused, onTap: onTap);
    });

    final query = UniversalQuery(query: field.selected?.title, onChange: (q) {
      controller.setList(UniversalItem.search(_cache, q), index: 0);
    });

    return Modal(title: field.title, body: ModalBody(children: [query, list]), footer: const UniversalFieldModalFooter());
  }

}