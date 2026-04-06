import 'package:flutter/material.dart';

class CustomStatefulAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final IconData? userIcon;

  const CustomStatefulAppBar({super.key, required this.title, this.userIcon});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _CustomStatefulAppBarState createState() => _CustomStatefulAppBarState();
}

class _CustomStatefulAppBarState extends State<CustomStatefulAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: widget.userIcon != null
          ? Icon(widget.userIcon)
          : Icon(Icons.person),
      title: Text(widget.title),
      titleSpacing: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Color(0xffcbafa2),
          height: 2.0,
        ),
      ),
      actions: [Padding(
        padding: const EdgeInsets.only(right: 6.0),
        child: Row(
          children: [
            Image(color: null, image: AssetImage('assets/phatos.webp'), fit: BoxFit.scaleDown, height: 35,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('000', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            )
          ],
        ),
      )],
    );
  }
}
