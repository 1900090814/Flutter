import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';


class HomePage2 extends StatefulWidget {

  final String title;



  HomePage2({Key key, this.title}) : super(key: key);



  @override

  State<StatefulWidget> createState() {

    return _HomePage2State();

  }

}



class _HomePage2State extends State<HomePage2> {

  List subjects = [];

  String title = '';



  @override

  void initState() {

    loadData();

  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      body: new NestedScrollView(
          headerSliverBuilder: (context , isScrolled){
            return <Widget>[
              new SliverAppBar(
                expandedHeight: 150.0,
                floating:false,
                centerTitle: true,
                pinned:true,
                flexibleSpace: new FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(title),
                  background: new Image.asset("images/2.png",fit: BoxFit.cover,),
                ),
              )
            ];
          },
          body: Center(

            child: getBody(),

          )),

    );

  }



  loadData() async {

    var httpClient = new HttpClient();
    http://api.douban.com/v2/movie/in_theaters?apikey=0df993c66c0c636e29ecbb5344252a4a&start=0&count=10
    Map<String, String> map = {"apikey":"0df993c66c0c636e29ecbb5344252a4a",
      "start":"0",
      "count":"10",
    };
    var uri = new Uri.https(
        'api.douban.com', '/v2/movie/in_theaters', map);
    print("接口地址______"+uri.toString());
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(Utf8Decoder()).join();




    var result = json.decode(responseBody);

    if(result != null){
      setState(() {

        title = result['title'];

        print('title: $title');

        subjects = result['subjects'];

      });
    }

  }





  getItem(var subject) {

//    演员列表

    var avatars = List.generate(subject['casts'].length, (int index) =>

        Container(

          margin: EdgeInsets.only(left: index.toDouble() == 0.0 ? 0.0 : 16.0),



          child: CircleAvatar(

              backgroundColor: Colors.white10,

              backgroundImage: new NetworkImage(subject['casts'][index]['avatars'] == null?"" :subject['casts'][index]['avatars']['small']),

          ),

        ),

    );

    var row = Container(

      margin: EdgeInsets.all(4.0),

      child: Row(

        children: <Widget>[

          ClipRRect(

            borderRadius: BorderRadius.circular(4.0),

            child: Image.network(

              subject['images']['large'],

              width: 100.0, height: 150.0,

              fit: BoxFit.fill,

            ),

          ),

          Expanded(

              child: Container(

                margin: EdgeInsets.only(left: 8.0),

                height: 150.0,

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[

//                    电影名称

                    Text(

                      subject['title'],

                      style: TextStyle(

                        fontWeight: FontWeight.bold,

                        fontSize: 20.0,

                      ),

                      maxLines: 1,

                    ),

//                    豆瓣评分

                    Text(

                      '豆瓣评分：${subject['rating']['average']}',

                      style: TextStyle(

                          fontSize: 16.0

                      ),

                    ),

//                    类型

                    Text(

                        "类型：${subject['genres'].join("、")}"

                    ),

//                    导演

                    Text(

                        '导演：${subject['directors'][0]['name']}'

                    ),

//                    演员

                    Container(

                      margin: EdgeInsets.only(top: 8.0),

                      child: Row(

                        children: <Widget>[

                          Text('主演：'),

                          Row(

                            children: avatars,

                          )

                        ],

                      ),

                    )

                  ],

                ),

              )

          )

        ],

      ),

    );

    return Card(

      child: row,

    );

  }



  getBody() {

    if (subjects != null && subjects.length != 0) {

      return ListView.builder(

          itemCount: subjects.length,

          itemBuilder: (BuildContext context, int position) {

            return getItem(subjects[position]);

          });

    } else {

      // 加载菊花

      return CupertinoActivityIndicator();

    }

  }

}