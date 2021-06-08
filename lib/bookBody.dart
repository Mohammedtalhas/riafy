import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:riafy/services/feeds.dart';
import 'package:riafy/services/service.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:riafy/services/constants.dart';
class bookBody extends StatefulWidget {
  @override
  _bookBodyState createState() => _bookBodyState();
}

class _bookBodyState extends State<bookBody> {
  bool isPressed = false;
  bool isLoading = true;
  List<Product> Contentlist;
  bool flag = true;
  DatabaseHelper db = new DatabaseHelper();
  void initState() {
    super.initState();
    //_loadVideos();
    _loadVideos();
  }
  _loadVideos() async {
   Contentlist = await db.getAllProducts();

    setState(() {
      isLoading= false;
    });

  }
  _bookmark( product,context) async {
    int loaded = await db.delete(product.id);
    if(loaded>0){
      new Future<Null>.delayed(Duration.zero, () {
        Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text("Bookmark Deleted.")),
        );
      });
      _loadVideos();
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
    print(Contentlist[index].lowthumbnail);
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
                          image: new NetworkImage(Contentlist[index].lowthumbnail==null?"https://i.picsum.photos/id/218/200/300.jpg?blur=5&hmac=X1RODYjrRYRzlBkVQ34yhust0bupBXD6yes186cTKY0":Contentlist[index].lowthumbnail)),
                    ),
                  ),
                  new SizedBox(
                    width: 10.0,
                  ),
                  new Text(
                    Contentlist[index].channelinfo,
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
          child: new Image.network(Contentlist[index].highthumbnail==null?"https://i.picsum.photos/id/218/200/300.jpg?blur=5&hmac=X1RODYjrRYRzlBkVQ34yhust0bupBXD6yes186cTKY0":Contentlist[index].highthumbnail,
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
                icon: new Icon(Icons.delete),
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
          child: Row(
            children: [ Text("${Contentlist[index].channelinfo}\t",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

              Expanded(
                child:

                Container(
                  padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Contentlist[index].title.length<50?new Text( Contentlist[index].title,)
                      : new Column(
                    children: <Widget>[
                      new Text(flag ? ( Contentlist[index].title.substring(0, 50)) : (Contentlist[index].title)),
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
                      image: new NetworkImage(Contentlist[index].lowthumbnail==null?"https://i.picsum.photos/id/218/200/300.jpg?blur=5&hmac=X1RODYjrRYRzlBkVQ34yhust0bupBXD6yes186cTKY0":Contentlist[index].lowthumbnail)),
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
