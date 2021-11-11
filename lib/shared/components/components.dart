import 'package:flutter/material.dart';

//default button style
Widget defaultButton({
  required VoidCallback onPressFunction,
  required String text,
  double width = double.infinity,
  double height = 40.0,
  double radius = 3.0,
  bool isUpperCase = true,
  Color backgroundColor = Colors.blue,
  Color textColor= Colors.white,
}) =>
    Container(
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: onPressFunction,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: textColor,
          ),
        ),
        clipBehavior: Clip.antiAlias, // Add This
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: backgroundColor,
      ),
    );

//navigate with availability to back
void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => widget),
);

//navigate without availability to back
void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => widget),
      (route) => false,
);

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?)? validate,
  required String label,

  bool isPassword = false,

  IconData? prefix,
  IconData? suffix,

  Color borderColor=Colors.white,
  Color textColor=Colors.white,
  Color hintColor=Colors.grey,
  Color prefixColor=Colors.white,
  Color suffixColor=Colors.white,

  VoidCallback? suffixPressed,

  double containerRadius=25.0,

  InputBorder borderForm=InputBorder.none,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(containerRadius),
        border: Border.all(color: borderColor)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: TextFormField(
          controller: controller,
          keyboardType: type,
          obscureText: isPassword,
          validator: validate,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(color: hintColor),
            prefixIcon: prefix != null
                ? Icon(prefix,color: prefixColor,)
                :null,
            suffixIcon: suffix != null
                ? IconButton(
              onPressed: suffixPressed,
              icon: Icon(
                suffix,
                color: suffixColor,
              ),
            )
                : null,
            border: borderForm,
          ),
        ),
      ),
    );

