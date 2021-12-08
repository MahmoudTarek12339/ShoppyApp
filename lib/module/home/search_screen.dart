import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextFormField(
          cursorColor: Colors.grey,
          style: TextStyle(color: Colors.white),
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search for Brand",
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        titleSpacing: 0,
      ),
    );
  }
}
