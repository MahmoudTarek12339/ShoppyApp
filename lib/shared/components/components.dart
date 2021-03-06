

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoppy/module/login/login_screen.dart';
import 'package:shoppy/shared/styles/colors.dart';

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
            color: Colors.white,
          ),
        ),
        clipBehavior: Clip.antiAlias, // Add This
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: backgroundColor!=null?backgroundColor:Theme.of(context).focusColor,
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

//default TFF style
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?)? validate,
  required String label,
  required BuildContext context,
  bool isPassword = false,
  int? maxLength,
  IconData? prefix,
  IconData? suffix,

  Color? borderColor,
  Color? focusBorderColor,
  Color hintColor=Colors.grey,
  Color? prefixColor,
  Color? suffixColor,
  Color? inputColor,

  VoidCallback? suffixPressed,
  VoidCallback? onTap,

  double containerRadius=10.0,

  InputBorder borderForm=InputBorder.none,
}) =>
    TextFormField(
      onTap: onTap,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      validator: validate,
      maxLength: maxLength,
      style: TextStyle(color: inputColor!=null?inputColor:Theme.of(context).iconTheme.color),
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
            color: borderColor!=null?borderColor:Theme.of(context).focusColor,
        )),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(containerRadius),borderSide: BorderSide(
            color: focusBorderColor!=null?focusBorderColor:Theme.of(context).focusColor,
        )),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(containerRadius),borderSide: BorderSide(
          color: focusBorderColor!=null?focusBorderColor:Theme.of(context).errorColor,
        )),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(containerRadius),borderSide: BorderSide(
          color: focusBorderColor!=null?focusBorderColor:Theme.of(context).errorColor,
        )),
      ),
    );


defaultSnackBar({
  required context,
  required String title,
  required Color color,
}){
  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
      height: 50,
      decoration: BoxDecoration(
        color:color,
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            spreadRadius: 2.0,
            blurRadius: 8.0,
            offset: Offset(2, 4),
          )
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Align(
          alignment:Alignment.centerLeft,
          child: Text(
              '  '+title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              )
          ),
        ),
      ),
    ),
    duration: Duration(seconds: 5),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);

}

Widget textUtils({required text,required fontSize,required fontWeight,required color})=>Text(
  text,
  style: GoogleFonts.lato(
      textStyle:TextStyle(
        fontWeight: fontWeight,
        color: color,
        fontSize: fontSize,
      )
  ),
);

Widget buildLogo(context, screenTitle, height) {
  return Container(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Positioned(
            child: Text(
              screenTitle,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            bottom: 10,
            right: 10,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/png1.png',
                  width: 90,
                  height: 90,
                ),
                Text(
                  'Shoppy App',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
    ),
    height: MediaQuery.of(context).size.height * height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
      gradient: LinearGradient(colors: [
        deepOrange,
        lightOrange,
        orange,
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    ),
  );
}


AlertDialog alertLogin(
{
  required context,
  required String title,
}) => AlertDialog(
  title: Text(
    "Login",
    style:Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).focusColor),
  ),
  content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
          title,
          style:Theme.of(context).textTheme.subtitle1
      ),
    ],
  ),
  backgroundColor: Theme.of(context).cardColor,
  actions: [
    TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(
          color: Theme.of(context).focusColor,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    TextButton(
      child: Text(
        "Login",
        style: TextStyle(
          color: Theme.of(context).focusColor,
        ),
      ),
      onPressed: () {
        navigateTo(context, LoginScreen());
      },
    ),
  ],
);
