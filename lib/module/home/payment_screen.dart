import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shoppy/shared/components/components.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  PaymentScreen(this.total);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<String> titles=[
    '  PayPal',
    'Credit Card',
    '  Apple Pay',
    ' Google Pay',
  ];
  int radioPaymentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<FaIcon> icons=[
      FaIcon(FontAwesomeIcons.paypal,size: 25.0,color: Colors.blue,),
      FaIcon(FontAwesomeIcons.solidCreditCard,size: 25.0,color: Colors.orangeAccent),
      FaIcon(FontAwesomeIcons.apple,size: 25.0,color: Theme.of(context).textTheme.bodyText1!.color,),
      FaIcon(FontAwesomeIcons.google,size: 25.0,color: Colors.red),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Payment'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).focusColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textUtils(
              text: 'Select your Payment Method',
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 220,
              child: ListView.separated(
                itemBuilder:(context,index)=>buildRadioPayment(
                    icon: icons[index],
                    name: titles[index],
                    index: index
                ),
                separatorBuilder:(context,index)=> SizedBox(height: 5,),
                itemCount: 4
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Spacer(),
            Center(
              child: textUtils(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                text: 'Total: ${widget.total.toStringAsFixed(2)}\$',
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                   /* Get.defaultDialog(
                      title: "Payment",
                      titleStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      middleText: 'Are you sure you want Pay in this way?',
                      middleTextStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: Colors.grey,
                      radius: 10,
                      textCancel: 'No',
                      cancelTextColor: Colors.white,
                      textConfirm: 'Yes',
                      confirmTextColor: Colors.white,
                      onCancel: (){},
                      onConfirm: (){
                        Get.toNamed(Routes.mainScreen);
                        Get.snackbar(
                            'Success',
                            'Your order \'ll be ready within 2 days',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white
                        );
                      },
                      buttonColor:Get.isDarkMode?pinkClr:mainColor,
                    );*/
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    primary: Theme.of(context).focusColor,
                  ),
                  child: Text(
                    'Pay Now',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRadioPayment({
    required FaIcon icon,
    required String name,
    required int index,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 2),
      height: 50,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: icon,
              ),
              const SizedBox(
                width: 10,
              ),
              textUtils(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                text: name,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ],
          ),
          Radio(
            value: index,
            groupValue: radioPaymentIndex,
            fillColor: MaterialStateColor.resolveWith((states) => Theme.of(context).focusColor),
            onChanged: (int? value) {
              setState(() {
                radioPaymentIndex = value!;
              });
            },
          ),
        ],
      ),
    );
  }
}
