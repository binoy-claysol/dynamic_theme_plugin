import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultRow extends StatefulWidget {
  String name;
  String label;
  double fontSize;
  double fontSize2;
  DefaultRow({super.key,
    required this.name,
    required this.label,
    required this.fontSize,
    required this.fontSize2
  });

  @override
  State<DefaultRow> createState() => _DefaultRowState();
}

class _DefaultRowState extends State<DefaultRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label,
            style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w500,
                color: Colors.grey[900]),),
          Container(
            width: 100,
            // color: Colors.red,
            child: Text(widget.name,
              style: TextStyle(
                  fontSize: widget.fontSize2,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[900]),),
          ),
        ]
    );
  }
}
