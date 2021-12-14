import 'package:flutter/material.dart';

class ChoiceChipData {
  final String label;
  final bool isSelected;
  final AssetImage img;
  Color textColor;
  Color selectedColor;

  ChoiceChipData({
    required this.label,
    required this.isSelected,
    required this.textColor,
    required this.selectedColor,
    required this.img
  });

  ChoiceChipData copy({
    String? label,
    bool? isSelected,
    AssetImage? img,
    Color? textColor,
    Color? selectedColor,
  }) =>
      ChoiceChipData(
        label: label ?? this.label,
        isSelected: isSelected ?? this.isSelected,
        img:img??this.img,
        textColor: textColor ?? this.textColor,
        selectedColor: selectedColor ?? this.selectedColor,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ChoiceChipData &&
              runtimeType == other.runtimeType &&
              label == other.label &&
              isSelected == other.isSelected &&
              textColor == other.textColor &&
              selectedColor == other.selectedColor&&
              img==other.img;
  @override
  int get hashCode =>
      label.hashCode ^
      isSelected.hashCode ^
      textColor.hashCode ^
      selectedColor.hashCode^
      img.hashCode;
}