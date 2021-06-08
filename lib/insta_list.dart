import 'dart:convert';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:riafy/services/feeds.dart';
import 'package:riafy/services/service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:riafy/services/constants.dart';
import 'package:flutter/services.dart';

import 'comments.dart';
class InstaList extends StatefulWidget {
  @override
  _InstaListState createState() => _InstaListState();
}

class _InstaListState extends State<InstaList> {
  bool isPressed = false;
  bool isLoading = true;
  List<dynamic> Contentlist;
  List<dynamic> Comments;
  bool flag = true;
  DatabaseHelper db = new DatabaseHelper();
  void initState() {
    super.initState();
    print("hello");
    //_loadVideos();
    _loadVideos();
    _makePostRequest();
  }
  _makePostRequest() async {

    // set up POST request arguments
    String url = Constants.Comments;
    // make POST request
    Response response = await http.get(Uri.parse(url));
    // check the status code for the result
    int statusCode = response.statusCode;
    Comments = json.decode(response.body) as List;


    print(Comments);
    //print(body[0]["id"]);
  }
  _loadVideos() async {
    String loaded = await Services.getblogs(
    );

    Contentlist = json.decode(loaded) as List;
    setState(() {
      isLoading= false;
    });

  }
  _bookmark( product,context) async {
    int loaded = await db.insert(product);
    if(loaded>0){
      new Future<Null>.delayed(Duration.zero, () {
        Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text("Bookmark Saved.")),
        );
      });
    }


  }


  @override
  Widget build(BuildContext context) {

    return isLoading
        ? Container(
      child: new Stack(
        children: <Widget>[
          new Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10.0)
              ),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: new CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        "loading.. wait...",
                        style: new TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ):ListView.builder(
      itemCount: Contentlist.length,
      itemBuilder: (context, index){
        return _buildArticleItem(context,index);
      }
    );
  }
  Widget _buildArticleItem(context,int index) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  new Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(Contentlist[index]["low thumbnail"])),
                    ),
                  ),
                  new SizedBox(
                    width: 10.0,
                  ),
                  new Text(
                    Contentlist[index]["channelname"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              new IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: null,
              )
            ],
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: new Image.network(Contentlist[index]["high thumbnail"],
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new IconButton(
                    icon: new Icon(isPressed
                        ? Icons.favorite
                        : FontAwesomeIcons.heart),
                    color: isPressed ? Colors.red : Colors.black,
                    onPressed: () {
                      setState(() {
                        isPressed = !isPressed;
                      });
                    },
                  ),
                  new SizedBox(
                    width: 16.0,
                  ),
                  IconButton(
                    icon:  new Icon(
                    FontAwesomeIcons.comment,
                  ),
                    onPressed: (){
                      Navigator.of(context).push(_createRoute(Comments));
                    },
                ),

                  new SizedBox(
                    width: 16.0,
                  ),
                  new Icon(FontAwesomeIcons.paperPlane),
                ],
              ),
              IconButton(
                icon: new Icon(FontAwesomeIcons.bookmark),
                onPressed: () {
                  _bookmark(Contentlist[index],context);







                },
              ),

              //
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Liked by mohammed, talha and 528,331 others",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: new  RichText(
            textAlign: TextAlign.left,
            text: TextSpan(children: [
                  TextSpan(
                      text: "${Contentlist[index]['channelname']}\t",
                      style: TextStyle(
                          color: Colors.black,fontFamily: 'Montserrat',fontWeight: FontWeight.bold)),
                    TextSpan(
                    text: flag ?  (Contentlist[index]["title"].length<50?Contentlist[index]["title"]:Contentlist[index]["title"].substring(0, 50)) : Contentlist[index]["title"],
                    style: TextStyle(
                    color: Colors.black,fontFamily: 'Montserrat',
                    fontSize: 13)),
                     TextSpan(
                      text: Contentlist[index]["title"].length>50?(flag? "more" : " less"):"",
                      style: new TextStyle(color: Colors.blue),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            flag = !flag;
                            });

                        },
                    ),


                ]),



          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                height: 40.0,
                width: 40.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(Contentlist[index]["low thumbnail"])),
                ),
              ),
              new SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: new TextField(
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add a comment...",
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child:
          Text("1 Day Ago", style: TextStyle(color: Colors.grey)),
        )
      ],
    );
  }

}
Route _createRoute(List value) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Comments(value),
    transitionDuration: Duration(milliseconds: 700),
    reverseTransitionDuration: Duration(milliseconds: 700),

    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}