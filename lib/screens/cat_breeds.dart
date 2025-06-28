import 'package:flutter/material.dart';
import '../api/cat_api.dart';
import 'cat_info.dart';
import '../models/cats.dart';
import 'dart:convert';

class CatBreedsPage extends StatefulWidget {
  // 1
  const CatBreedsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CatBreedsPage> createState() => _CatBreedsPageState();
}

class _CatBreedsPageState extends State<CatBreedsPage> {
   BreedList breedList = BreedList(breeds: List.empty());
  @override
  void initState() {
    super.initState();
    getCatData();
  }

  void getCatData() async {
    final catJson = await CatAPI().getCatBreeds();
    print(catJson);
    // 1
final dynamic catMap = json.decode(catJson);
// 2
setState(() {
  // 3
  breedList = BreedList.fromJson(catMap);
});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 2
        title: Text(widget.title),
      ),
      // 3
      body: ListView.builder(
          // 4
          itemCount: breedList.breeds.length,
          itemBuilder: (context, index) {
            // 5
            return GestureDetector(
              onTap: () {
                     Navigator.push<void>(context,
                      MaterialPageRoute(builder: (context) {
                        return CatInfo(
                            catId: breedList.breeds[index].id, 
                            catBreed: breedList.breeds[index].name,
                        );
                  }));
              },
              // 6
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  // 7
                  child: ListTile(
                    title: Text(breedList.breeds[index].name),
                    subtitle: Text(breedList.breeds[index].description),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
