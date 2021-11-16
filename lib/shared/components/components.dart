import 'package:flutter/material.dart';

//default button style
Widget defaultButton({
  required VoidCallback onPressFunction,
  required String text,
  required BuildContext context,
  double width = double.infinity,
  double height = 40.0,
  double radius = 15.0,
  bool isUpperCase = true,
  Color? backgroundColor ,
}) =>
    Container(
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: onPressFunction,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        clipBehavior: Clip.antiAlias, // Add This
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: backgroundColor!=null?backgroundColor:Theme.of(context).buttonColor,
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
  required BuildContext context,
  bool isPassword = false,

  IconData? prefix,
  IconData? suffix,

  Color? borderColor,
  Color? focusBorderColor,
  Color hintColor=Colors.grey,
  Color? prefixColor,
  Color? suffixColor,

  VoidCallback? suffixPressed,

  double containerRadius=10.0,

  InputBorder borderForm=InputBorder.none,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      validator: validate,
      style: TextStyle(color: Theme.of(context).iconTheme.color),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: hintColor),
        prefixIcon: prefix != null
            ? Icon(prefix,
          color: prefixColor!=null?prefixColor
          :Theme.of(context).iconTheme.color,)
            :null,
        suffixIcon: suffix != null
            ? IconButton(
          onPressed: suffixPressed,
          icon: Icon(
            suffix,
            color: suffixColor!=null?suffixColor
                :Theme.of(context).iconTheme.color,
          ),
        )
            : null,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(containerRadius),borderSide: BorderSide(
            color: borderColor!=null?borderColor:Theme.of(context).backgroundColor,
        )),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(containerRadius),borderSide: BorderSide(
            color: focusBorderColor!=null?focusBorderColor:Theme.of(context).focusColor,
        )),
      ),
    );

