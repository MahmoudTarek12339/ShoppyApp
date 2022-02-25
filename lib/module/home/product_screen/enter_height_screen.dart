
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../shared/components/components.dart';
class EnterHeightScreen extends StatefulWidget {
  final String category;

  EnterHeightScreen({required this.category});

  @override
  State<EnterHeightScreen> createState() => _EnterHeightScreenState();
}

class _EnterHeightScreenState extends State<EnterHeightScreen> {
  final TextEditingController heightController=TextEditingController();
  final GlobalKey<FormState> formKey=GlobalKey<FormState>();
  bool isSwitched=false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Size Guide'),
          centerTitle: true,
          backgroundColor: Theme.of(context).focusColor,
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20),
            child: Column(
              children: [
                Container(
                  height: 250,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Image.asset(
                    'assets/images/bodyMesurments.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 25,),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: heightController,
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please enter your Height';
                          }
                          else if(int.parse(value)>250){
                            return 'Invalid Length';
                          }
                          return null;
                        },
                        maxLength: 3,
                        decoration: InputDecoration(
                          labelText: 'your Height',
                          labelStyle: Theme.of(context).textTheme.caption,
                          enabledBorder:UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1!.color??Colors.white),
                          ),
                          focusedBorder:UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).textTheme.bodyText1!.color??Colors.white),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                        children: [
                          textUtils(
                            text: 'Cm',
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).textTheme.bodyText1!.color
                          ),
                          Switch(
                            onChanged: (bool value) {
                              setState(() {
                                isSwitched=value;
                              });
                            },
                            value: isSwitched,
                            activeTrackColor: Theme.of(context).focusColor,
                            activeColor: Colors.white,
                            inactiveTrackColor: Theme.of(context).focusColor,
                          ),
                          textUtils(
                              text: 'Inch',
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).textTheme.bodyText1!.color
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15,),
                InkWell(
                  onTap: (){

                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      textUtils(
                          text: 'Go Next ',
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).focusColor
                      ),
                      FaIcon(
                        FontAwesomeIcons.arrowCircleRight,
                        //color: Theme.of(context).cardColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
