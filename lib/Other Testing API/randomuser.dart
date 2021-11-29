import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as fromWeb;
Map<String,dynamic> dataList = { "name": "",
  "gender": "",
  "email": "",
  "image": "",
  "age": 0,};

class RandomUserInfo extends StatefulWidget {
  const RandomUserInfo({Key? key}) : super(key: key);

  @override
  _RandomUserInfoState createState() => _RandomUserInfoState();
}

class _RandomUserInfoState extends State<RandomUserInfo> {
  late Future<Map<String,dynamic>> dataMap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataMap = fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test User"),

        actions: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.add_reaction_sharp)),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
          future: dataMap,
          builder: (context, droprox) {
            if (droprox.hasData) {
              return Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
/*
                      CircleAvatar(
                        backgroundImage: NetworkImage((dataList["image"]),),

                      ),
*/
                      Text((dataList["name"])),
                      Text(dataList["gender"]),
                    ],
                  ),
                ),
              );
            } else if (droprox.hasError) {
              return const Text("The loading didn't worked as hoped!!");
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      )
    );
  }
}



Future<Map<String,dynamic>> fetchData() async{
  var webData = await fromWeb.get(Uri.parse("https://randomuser.me/api/"));

  if(webData.statusCode == 200){
    Map<String, dynamic> decodedJson = json.decode(webData.body);
   // print(decodedJson.toString());

    BaseBlock check = BaseBlock.dividePortion(decodedJson);
    print(check.personalInfo.toString());
    dataList = check.personalInfo;

    print(dataList.toString());

    return dataList;
  } else {
    throw ("Didn't received any data!");
  }
}


class BaseBlock{
   Map<String,dynamic> personalInfo = {};

  BaseBlock({required personalInfo});

  factory BaseBlock.dividePortion(Map<String,dynamic> decodedMap) {
    Map<String,dynamic> personalData = {
      "name": "",
      "gender": "",
      "email": "",
      "image": "",
      "age": 0,
    };

    List<dynamic> result = decodedMap["results"];
    Map<String,dynamic> info = decodedMap["info"];
   // print(result.toString());
    Map<String,dynamic> personalInfo = result[0];
   // print(personalInfo.toString());
    String gender = personalInfo["gender"];
    personalData.update("gender", (value) => value + gender);
    Map<String,dynamic> nameMap = personalInfo["name"];
    String name = nameMap["title"]+" "+nameMap["first"]+" "+nameMap["last"];
    personalData.update("name", (value) => value + name);
    Map<String,dynamic> picture = {};
    picture = personalInfo["picture"];
    String image = picture["large"];
    personalData.update("image", (value) => image);

    print(personalData.toString());
    return BaseBlock(personalInfo: personalData);
  }

}

