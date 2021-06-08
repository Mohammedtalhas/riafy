import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:riafy/insta_body.dart';

import 'bookBody.dart';
class InstaHome extends StatefulWidget {
  @override
  _InstaHomeState createState() => _InstaHomeState();
}




class _InstaHomeState extends State<InstaHome> {
  final topBar = new AppBar(
    backgroundColor: new Color(0xfff8faf8),
    centerTitle: true,
    elevation: 1.0,
    leading: new Icon(Icons.camera_alt),
    title: SizedBox(
        height: 35.0, child: Image.asset("assets/insta_logo.png")),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Icon(FontAwesomeIcons.telegramPlane),
      )
    ],
  );

  final List<Widget> _children = [
    InstaBody(),bookBody(),

  ];
  int currentIndex = 0;

  changePage(int index) {


    setState(() {


      currentIndex = index;


    });


  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: topBar,
        body: _children[currentIndex],
        bottomNavigationBar: new Container(
          color: Colors.white,
          height: 50.0,
          alignment: Alignment.center,
          child: new BottomAppBar(


            child: new Row(
              // alignment: MainAxisAlignment.spaceAround,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new IconButton(
                  icon: Icon(
                    Icons.home,
                  ),
                  color: currentIndex==0?Colors.black:Colors.grey,
                  onPressed: () {
                    changePage(0);
                  },
                ),
                new IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: null,
                ),
                new IconButton(
                  icon: Icon(
                    Icons.add_box,
                  ),
                  onPressed: null,
                ),
                new IconButton(
                  icon: Icon(
                    Icons.favorite,
                  ),
                  onPressed: null,
                ),
                new IconButton(
                  icon: Icon(
                    FontAwesomeIcons.bookmark,
                  ),
                  color: currentIndex==1?Colors.black:Colors.grey,
                  onPressed: (){
                    changePage(1);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}