import 'package:flutter/material.dart';
import 'package:shoppy/module/signup/code_verification.dart';
import 'package:shoppy/shared/components/components.dart';

class MobileVerificationScreen extends StatefulWidget {
  @override
  _MobileVerificationScreenState createState() => _MobileVerificationScreenState();
}

class _MobileVerificationScreenState extends State<MobileVerificationScreen> {
  final TextEditingController numberController=TextEditingController();
  List<String> dropDownList=['+1','+2','+3','+4','+20'];
  String dropdownValue='+20';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mobile Number',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 30.0,color: Colors.white),
            ),
            SizedBox(height: 50.0,),
            Text(
              'Please enter your Mobile phone Number',
              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey)
            ),
            SizedBox(height: 15.0,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                      onChanged: (String? data){
                          setState(() {
                            dropdownValue = data.toString();
                          });
                      },
                      items: dropDownList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(width: 10.0,),
                    Expanded(
                      child: TextFormField(
                        controller: numberController,
                        validator: (value){

                        },
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText:'0123456789',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 45.0,),
            defaultButton(
              onPressFunction: (){
                navigateTo(context,CodeVerificationScreen());
              },
              text: 'Send Code',
              backgroundColor: Colors.pink,
              radius: 10.0
            ),
          ],
        ),
      ),

    );
  }
}
