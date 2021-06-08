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
             ListView.builder(
               scrollDirection: Axis.vertical,
               shrinkWrap: true,
               itemCount: value.length,
                 itemBuilder:  (context, i) {
                 print(value[i]['username']);
                   return new Container(
                     padding: const EdgeInsets.all(1.0),
                     child:  new Card(
                         child: new ListTile(
                           leading: Image.network('https://i.picsum.photos/id/945/536/354.jpg?hmac=VuYuUPHKNubjREdR4hkLOLHkhYnoZINbXG3ssAFtpno',height: 110,),
                           title: new  RichText(
                             textAlign: TextAlign.left,
                             text: TextSpan(
                                 text:  value[i]['username'].toString(),

                                 style: TextStyle(color: Colors.grey[850], fontSize: 17, fontWeight: FontWeight.bold,),
                                 children: [
                                   TextSpan(
                                       text: "\n \n" + value[i]['comments'].toString(),
                                       style: TextStyle(
                                           color: Colors.red[600],fontFamily: 'Montserrat',
                                           fontSize: 13)),

                                 ]),

                           ),

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