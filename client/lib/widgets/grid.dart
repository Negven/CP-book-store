


import 'package:client/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

abstract class InGrid {
  TrackSize get inGridSize;
}

class GridSpace extends StatelessWidget implements InGrid {

  const GridSpace({super.key});

  @override
  Widget build(BuildContext context) => Empty.instance;

  @override
  TrackSize get inGridSize => const FlexibleTrackSize(1.0);

}

abstract class Grid {

  static LayoutGrid row({double? gap, GridFit? gridFit, required List<Widget> children}) => _build(true, gap: gap, gridFit: gridFit, children: children);
  static LayoutGrid column({double? gap, GridFit? gridFit, required List<Widget> children}) => _build(false, gap: gap, gridFit: gridFit, children: children);

  static LayoutGrid _build(bool inRow, { double? gap, GridFit? gridFit, required List<Widget> children}) {

    final sizes = children.map((w) => w is InGrid ? (w as InGrid).inGridSize : auto).toList();
    final rowSizes = inRow ? [auto] : sizes;
    final columnSizes = inRow ? sizes : [auto];

    return LayoutGrid(
      gridFit: gridFit ?? GridFit.expand,
      rowGap: inRow ? null : gap,
      columnGap: inRow ? gap : null,
      columnSizes: columnSizes,
      rowSizes: rowSizes,
      children: children,
    );
  }
}