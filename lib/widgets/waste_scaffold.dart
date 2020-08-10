import 'package:flutter/material.dart';

class WasteScaffold extends StatefulWidget {

  final Widget child;
  final String title;
  final Widget fab;
  final Widget backButton;

  WasteScaffold({
    Key key, @required this.child, this.title, this.fab, this.backButton
    }) : super(key: key);

  @override
  _WasteScaffoldState createState() => _WasteScaffoldState();
}

class _WasteScaffoldState extends State<WasteScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.backButton,
        title: Text(widget.title),
      ),
      body: widget.child,
      floatingActionButton: widget.fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: false,
    );
  }
}