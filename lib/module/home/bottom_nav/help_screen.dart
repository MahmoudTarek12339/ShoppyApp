import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MaterialButton(
            height: 40,
            color: Theme.of(context).scaffoldBackgroundColor,
            elevation: 1.0,
            onPressed: (){},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FaceBook',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios_outlined,color: Theme.of(context).iconTheme.color,),
              ],
            ),
          ),
          MaterialButton(
            height: 40,
            color: Theme.of(context).scaffoldBackgroundColor,
            elevation: 1.0,
            onPressed: (){},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Whats App',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios_outlined,color: Theme.of(context).iconTheme.color,),
              ],
            ),
          ),
          MaterialButton(
            height: 40,
            color: Theme.of(context).scaffoldBackgroundColor,
            elevation: 1.0,
            onPressed: (){},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instagram',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios_outlined,color: Theme.of(context).iconTheme.color,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
