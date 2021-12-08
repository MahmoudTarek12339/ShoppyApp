import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Contact us.....',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.blue,
            ),
            child: Align(
              alignment: Alignment.center,
              child:FaIcon(FontAwesomeIcons.facebookF,)
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.redAccent,
            ),
            child: Align(
                alignment: Alignment.center,
                child:FaIcon(FontAwesomeIcons.google,)
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.green,
            ),
            child: Align(
                alignment: Alignment.center,
                child:FaIcon(FontAwesomeIcons.whatsapp,)
            ),
          ),
        ],
      ),
    );
  }
}
