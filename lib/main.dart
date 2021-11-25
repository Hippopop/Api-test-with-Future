import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as FromWeb;

List<SectionBlock> showingList = [];

class SectionBlock {
  int userId;
  int id;
  String title;
  String body;

  SectionBlock(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body});

  factory SectionBlock.dataPart(Map<String, dynamic> listCreator) {
    int userid = listCreator["userId"];
    int idNumber = listCreator["id"];
    String title = listCreator["title"];
    String body = listCreator["body"];
    return SectionBlock(userId: userid, id: idNumber, title: title, body: body);
  }
}

Future<List<SectionBlock>> dataCatcher() async {
  var webData = await FromWeb.get(
      Uri.parse("https://jsonplaceholder.typicode.com/posts"));

  if (webData.statusCode == 200) {
    List<dynamic> listFromJson = json.decode(webData.body);
    //print(listFromJson.toString());

    listFromJson.forEach((element) {
      SectionBlock dataPart = SectionBlock.dataPart(element);
      showingList.add(dataPart);
    });

    return showingList;
  } else {
    throw "This Didn't Worked";
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<SectionBlock>> createdList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createdList = dataCatcher();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Random Latin Post"),
        ),
        body: Center(
          child: FutureBuilder(
            future: createdList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: SafeArea(
                    child: ListView.builder(
                      itemCount: showingList.length,
                      itemBuilder: (BuildContext context, index) => Container(
                        height: 250,
                        padding: const EdgeInsets.all(5),
                        child: Card(
                          color: Colors.lime,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                                child: Column(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Center(child: Text((showingList[index].id).toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),))),
                            Expanded(
                              flex: 3,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                   Expanded(
                                     flex: 8,
                                     child: Column(
                                      children: [
                                        Text(showingList[index].title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
                                      ],
                                  ),
                                   ),
                                ]
                              ),
                            ),
                            Expanded(flex: 5,child: Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(showingList[index].body)),
                            )),
                          ],
                        ))),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Text("The loading didn't worked as hoped!!");
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
