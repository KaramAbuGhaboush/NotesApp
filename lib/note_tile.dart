import 'package:flutter/material.dart';

class NoteTile extends StatelessWidget {
  const NoteTile(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.leading,
      required this.trailing})
      : super(key: key);

  final String title;
  final String subtitle;
  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: leading,
      trailing: trailing,
    );
  }
}
