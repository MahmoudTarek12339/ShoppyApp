import 'package:flutter/material.dart';
import 'package:shoppy/module/home/bottom_nav/web_view_screen.dart';
import 'package:shoppy/shared/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
            onPressed: (){
              navigateTo(context,WebViewScreen(index: 0,));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.faceBook}',
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
            onPressed: (){
              navigateTo(context,WebViewScreen(index: 1,));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.twitter}',
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
            onPressed: (){
              navigateTo(context,WebViewScreen(index: 2,));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.instagram}',
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
