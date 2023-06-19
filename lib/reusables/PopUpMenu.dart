import 'package:flutter/material.dart';


class PopUpMenu extends StatelessWidget {
  final List<PopupMenuEntry> menuList;

  const PopUpMenu({super.key, required this.menuList});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: ((context) =>menuList),
    );
  }


}
