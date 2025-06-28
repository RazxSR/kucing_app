import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'cats.g.dart';

/*
Breeds API result
{
    "adaptability": 5,
    "affection_level": 5,
    "alt_names": "",
    "cfa_url": "http://cfa.org/Breeds/BreedsAB/Abyssinian.aspx",
    "child_friendly": 3,
    "country_code": "EG",
    "country_codes": "EG",
    "dog_friendly": 4,
    "energy_level": 5,
    "experimental": 0,
    "grooming": 1,
    "hairless": 0,
    "health_issues": 2,
    "hypoallergenic": 0,
    "id": "abys",
    "indoor": 0,
    "intelligence": 5,
    "lap": 1,
    "life_span": "14 - 15",
    "name": "Abyssinian",
    "natural": 1,
    "origin": "Egypt",
    "rare": 0,
    "rex": 0,
    "shedding_level": 2,
    "short_legs": 0,
    "social_needs": 5,
    "stranger_friendly": 5,
    "suppressed_tail": 0,
    "temperament": "Active, Energetic, Independent, Intelligent, Gentle",
    "vcahospitals_url": "https://vcahospitals.com/know-your-pet/cat-breeds/abyssinian",
    "vetstreet_url": "http://www.vetstreet.com/cats/abyssinian",
    "vocalisation": 1,
    "weight": {
      "imperial": "7  -  10",
      "metric": "3 - 5"
    },
    "wikipedia_url": "https://en.wikipedia.org/wiki/Abyssinian_(cat)"
  },
 */
//class breed
@JsonSerializable()
class Breed {
  String id;
  String name;
  String description;
  String temperament;

  Breed(
      {required this.id,
      required this.name,
      required this.description,
      required this.temperament});
  factory Breed.fromJson(Map<String, dynamic> json) => _$BreedFromJson(json);

  Map<String, dynamic> toJson() => _$BreedToJson(this);

//Class Cat breed
}

@JsonSerializable()
class BreedList {
  List<Breed> breeds;

  BreedList({required this.breeds});
  factory BreedList.fromJson(final dynamic json) {
    return BreedList(
        breeds: (json as List<dynamic>)
            .map((dynamic e) => Breed.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}

//Class cat
@JsonSerializable()
class Cat {
  String name;
  String description;
  String life_span;

  Cat({required this.name, required this.description, required this.life_span});
  factory Cat.fromJson(Map<String, dynamic> json) => _$CatFromJson(json);

  Map<String, dynamic> toJson() => _$CatToJson(this);
}

@JsonSerializable()
class CatBreed {
  String id;
  String url;
  int width;
  int height;

  CatBreed(
      {required this.id,
      required this.url,
      required this.width,
      required this.height});
  factory CatBreed.fromJson(Map<String, dynamic> json) {
    return CatBreed(
      id: tryCast<String>(json['id']) ?? '',
      url: tryCast<String>(json['url']) ?? '',
      width: tryCast<int>(json['width']) ?? 0,
      height: tryCast<int>(json['height']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => _$CatBreedToJson(this);
}

@JsonSerializable()
class CatList {
  List<CatBreed> breeds;

  CatList({required this.breeds});
  factory CatList.fromJson(dynamic json) {
    return CatList(
        breeds: (json as List<dynamic>)
            .map((dynamic e) => CatBreed.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}

T? tryCast<T>(dynamic object) => object is T ? object : null;
