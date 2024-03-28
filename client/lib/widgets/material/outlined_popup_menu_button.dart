
import 'package:flutter/material.dart';


class OutlinedPopupMenuButton<T> extends PopupMenuButton<T> {

  final Widget Function(VoidCallback showMenu) builder;
  const OutlinedPopupMenuButton({super.key, required this.builder,  super.initialValue, super.onSelected, required super.itemBuilder});

  @override
  PopupMenuButtonState<T> createState() => OutlinedPopupMenuButtonState<T>();

}

class OutlinedPopupMenuButtonState<T> extends PopupMenuButtonState<T> {

  @override
  Widget build(BuildContext context) {
    return (widget as OutlinedPopupMenuButton).builder(showButtonMenu);
  }

}
