import 'package:flutter/material.dart';
import 'package:shoppy/module/search_screen.dart';
import 'package:shoppy/shared/components/components.dart';

class ShoppyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 15.0,
                left: 15.0,
                top: 5.0,
                bottom: 10.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[800]),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          navigateTo(context,SearchScreen());
                        },
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: "Search for Brand",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        child: CircleAvatar(
                          radius: 20.0,
                          backgroundImage: NetworkImage(
                              'https://avatars.githubusercontent.com/u/34492145?v=4'),
                        ),
                        onTap: (){
                          print('image tapped');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
