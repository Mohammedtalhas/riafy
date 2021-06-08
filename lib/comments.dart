import 'package:flutter/material.dart';
class Comments extends StatelessWidget {
  Comments(this.value);

  List value;

  Widget build(BuildContext context) {
    print(value);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text("Comments", style: TextStyle(color: Colors.black),),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:<Widget>[
              value.length==0||value==null?Container(
                padding: const EdgeInsets.all(20.0),child: Center(
                child: Text(
                  "No Comments",
                  textAlign: TextAlign.center,
                ),
              ),):ListView.builder(
               scrollDirection: Axis.vertical,
               shrinkWrap: true,
               itemCount: value.length,
                 itemBuilder:  (context, i) {
                 print(value[i]['username']);
                   return new Container(
                     padding: const EdgeInsets.all(1.0),
                     child:   new ListTile(
                           leading: new Container(
                             height: 40.0,
                             width: 40.0,
                             decoration: new BoxDecoration(
                               shape: BoxShape.circle,
                               image: new DecorationImage(
                                   fit: BoxFit.fill,
                                   image: new NetworkImage('https://i.picsum.photos/id/945/536/354.jpg?hmac=VuYuUPHKNubjREdR4hkLOLHkhYnoZINbXG3ssAFtpno')),
                             ),
                           ),
                           title: new  RichText(
                             textAlign: TextAlign.left,
                             text: TextSpan(

                                 children: [
                                   TextSpan(text:  value[i]['username'].toString(),

                                     style: TextStyle(color: Colors.grey[850], fontSize: 17, fontWeight: FontWeight.bold,),
                                   ),
                                   TextSpan(
                                       text: "\t" + value[i]['comments'].toString(),
                                       style: TextStyle(
                                           color: Colors.black54,fontFamily: 'Montserrat',
                                           fontSize: 13)),

                                 ]),

                           ),

                       ),
                   );
                 },
             )
            ],
          ),
        )
    );
  }
}