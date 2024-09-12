import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 115,
      title: DefaultTextStyle(
        style: Theme.of(context).textTheme.displayLarge!,
        overflow: TextOverflow.fade,
        textAlign: TextAlign.start,
        softWrap: false,
        child: title,
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(115);
}
