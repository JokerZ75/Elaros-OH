// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:occupational_health/components/my_submit_button.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Page'),
        backgroundColor: Color.fromARGB(249, 238, 152, 2),
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: 300,
          // width: 350,
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Forum Posts',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(249, 220, 141, 4),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade500,
                            offset: Offset(4.0, 4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(-4.0, -4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0,
                          )
                        ],
                      ),
                      width: 350,
                      height: 200,
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'This is the forum post text'),
                          ),
                        ],
                      ),
                    ),
                    // decoration: BoxDecoration(
                    //   color: Color.fromARGB(249, 220, 141, 4),
                    //   borderRadius: BorderRadius.circular(20),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.grey.shade500,
                    //       offset: Offset(4.0, 4.0),
                    //       blurRadius: 15.0,
                    //       spreadRadius: 1.0,
                    //     ),
                    //     BoxShadow(
                    //       color: Colors.white,
                    //       offset: Offset(-4.0, -4.0),
                    //       blurRadius: 15.0,
                    //       spreadRadius: 1.0,
                    //     )
                    //   ],
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      // padding: EdgeInsets.only(top: 6),
                      child: MySubmitButton(
                        onPressed: () {},
                        text: "Click here to view more posts",
                        textSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Community Map",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              Container(
                height: 200,
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  image: DecorationImage(
                      image: AssetImage("map.png"), fit: BoxFit.cover),
                ),
                child: const Text("Map", style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
