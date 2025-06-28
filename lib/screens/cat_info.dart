import 'package:flutter/material.dart';
import 'dart:convert';
import '../api/cat_api.dart';
import '../models/cats.dart';

const String proxyUrl = 'http://localhost:8080/';

class CatInfo extends StatefulWidget {
  final String catBreed;
  final String catId;

  CatInfo({required this.catBreed, required this.catId});

  @override
  State<CatInfo> createState() => _CatInfoState();
}

class _CatInfoState extends State<CatInfo> {
  CatList catList = CatList(breeds: List.empty());

  void getCatData() async {
    final catJson = await CatAPI().getCatBreed(widget.catId);

    // ADD THIS CHECK HERE:
    if (!mounted) {
      // If the widget is no longer mounted, do nothing and return.
      return;
    }

    final dynamic catMap = json.decode(catJson);

    setState(() {
      catList = CatList.fromJson(catMap);
    });
  }

  @override
  void initState() {
    super.initState();
    getCatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.catBreed),
        ),
        body: getCat());
  }

  Widget getCat() {
    final mediaSize = MediaQuery.of(context).size;
    if (catList.breeds.isEmpty) {
      return Container();
    } else {
      return Center(
        child: Container(
          width: mediaSize.width,
          height: mediaSize.height,
          // 1
          decoration: BoxDecoration(
              image: DecorationImage(
            // 2
            image: NetworkImage('${proxyUrl}${catList.breeds[0].url}'),
            fit: BoxFit.contain,
          )),
        ),
      );
    }
  }
}
