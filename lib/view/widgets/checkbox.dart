import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final Function onChange;
  final bool? isChecked;
  final double? size;
  final double? iconSize;
  final Color? selectedColor;
  final Color? selectedIconColor;
  final Color? borderColor;
  final Icon? checkIcon;

  CustomCheckbox({this.isChecked, required this.onChange, this.size, this.iconSize, this.selectedColor, this.selectedIconColor, this.borderColor, this.checkIcon});

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _isSelected = false;

  @override
  void initState() {
    _isSelected = widget.isChecked ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          widget.onChange(_isSelected);
        });
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.all(4),
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
            color: _isSelected ? widget.selectedColor ?? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(3.0),
            border: Border.all(
              color: widget.borderColor ?? Colors.black,
              width: 1.5,
            )),
        width: widget.size ?? 18,
        height: widget.size ?? 18,
        child: _isSelected
            ? Icon(
                Icons.check,
                color: widget.selectedIconColor ?? Colors.white,
                size: widget.iconSize ?? 14,
              )
            : null,
      ),
    );
  }
}
