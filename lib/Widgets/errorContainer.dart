import 'package:flutter/material.dart';

class ErrorContainer extends StatefulWidget {
  final double errorContainerHeight;
  final String errorText;
  ErrorContainer({this.errorContainerHeight, this.errorText});

  @override
  _ErrorContainerState createState() => _ErrorContainerState();
}

class _ErrorContainerState extends State<ErrorContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.errorContainerHeight,
      padding: EdgeInsets.only(left: 10),
      width: 500,
      child: Text(
        widget.errorText,
        style: TextStyle(
          color: Colors.red[700],
          fontSize: 12,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
