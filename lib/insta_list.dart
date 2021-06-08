import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:riafy/services/feeds.dart';
import 'package:riafy/services/service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:riafy/services/constants.dart';
class InstaList extends StatefulWidget {
  @override
  _InstaListState createState() => _InstaListState();
}

class _InstaListState extends State<InstaList> {
  bool isPressed = false;
  bool isLoading = true;
  List<dynamic> Contentlist;
  bool flag = true;
  void initState() {
    super.initState();
    print("hello");
    //_loadVideos();
    _loadVideos();
    _bookmarkget();
  }
  _makePostRequest() async {

    // set up POST request arguments
    String url = Constants.FEED_URL;
    // make POST request
    Response response = await http.get(Uri.parse(url));
    // check the status code for the result
    int statusCode = response.statusCode;
    Contentlist = json.decode(response.body) as List;


    print(Contentlist);
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
  _bookmark( product) async {

    print(product);
    //prefs.setString('bookmark', );
    String loaded = await SQLiteDbProvider.db.insert(product);
    print(loaded);

  }
  _bookmarkget() async {


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
                  new Icon(
                    FontAwesomeIcons.comment,
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
                  _bookmark(Contentlist[index]);
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
          child: Row(
            children: [ Text("${Contentlist[index]['channelname']}\t",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

          Expanded(
            child:

            Container(
                        padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        child: Contentlist[index]["title"].length<50?new Text( Contentlist[index]["title"],)
                            : new Column(
                        children: <Widget>[
                        new Text(flag ? ( Contentlist[index]["title"].substring(0, 50)) : (Contentlist[index]["title"])),
                        new InkWell(
                        child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                        new Text(flag? "show more" : "show less",
                        style: new TextStyle(color: Colors.blue),
                        ),
                        ],
                        ),
                        onTap: () {
                        setState(() {
                        flag = !flag;
                        });
                        },
                        ),
                        ],
                        ),
            ),
          ),
            ],
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
