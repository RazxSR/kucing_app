import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'cats.g.dart'; // Make sure this path is correct

/*
Breeds API result structure (for reference, this is what Breed class should map)
{
    "adaptability": 5,
    "affection_level": 5,
    "alt_names": "",
    "cfa_url": "http://cfa.org/Breeds/BreedsAB/Abyssinian.aspx",
    "child_friendly": 3,
    "country_code": "EG",
    "country_codes": "EG",
    "description": "...",
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
    "life_span": "14 - 15", // snake_case
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
    "temperament": "...",
    "vcahospitals_url": "...",
    "vetstreet_url": "...",
    "vocalisation": 1,
    "weight": {
      "imperial": "7 - 10",
      "metric": "3 - 5"
    },
    "wikipedia_url": "https://en.wikipedia.org/wiki/Abyssinian_(cat)" // snake_case
}

Image Search API result structure (what CatBreed should map)
[
  {
    "id": "JFPROfGtQ",
    "url": "https://cdn2.thecatapi.com/images/JFPROfGtQ.jpg",
    "width": 1000,
    "height": 667,
    "breeds": [ // THIS IS THE NESTED BREED ARRAY
      {
        "id": "asho",
        "name": "American Shorthair",
        "description": "...",
        "temperament": "...",
        "wikipedia_url": "...",
        "life_span": "...",
        // ... all other breed fields ...
      }
    ]
  }
]
*/

// Class Breed: This should contain all the detailed information about a cat .
@JsonSerializable()
class Breed {
  String id;
  String name;
  String description;
  String temperament;
  String origin;
  @JsonKey(name: 'life_span') // Map snake_case JSON to camelCase Dart
  String lifeSpan;
  @JsonKey(name: 'wikipedia_url') // Map snake_case JSON to camelCase Dart
  String? wikipediaUrl; // Use String? because it might be null
  @JsonKey(name: 'affection_level')
  int affectionLevel;
  @JsonKey(name: 'energy_level')
  int energyLevel;
  // Add other fields you want to display from the API response
  // e.g., @JsonKey(name: 'health_issues') int healthIssues;
  // @JsonKey(name: 'grooming') int grooming;
  // etc.

  Breed({
    required this.id,
    required this.name,
    required this.description,
    required this.temperament,
    required this.origin,
    required this.lifeSpan,
    this.wikipediaUrl, // Make optional in constructor
    required this.affectionLevel,
    required this.energyLevel,
    // Add other fields to constructor
  });

  factory Breed.fromJson(Map<String, dynamic> json) => _$BreedFromJson(json);
  Map<String, dynamic> toJson() => _$BreedToJson(this);
}

// Class BreedList: Used for the initial list of ALL breeds (from /breeds endpoint)
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

// Class CatBreed: This is for the response from the /images/search endpoint.
// It contains the image details AND a list of associated breeds.
@JsonSerializable()
class CatBreed {
  String id;
  String url;
  int width;
  int height;
  List<Breed>? breeds; // THIS IS THE NEW CRITICAL FIELD!

  CatBreed({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
    this.breeds, // Make optional in constructor
  });

  factory CatBreed.fromJson(Map<String, dynamic> json) {
    return CatBreed(
      id: tryCast<String>(json['id']) ?? '',
      url: tryCast<String>(json['url']) ?? '',
      width: tryCast<int>(json['width']) ?? 0,
      height: tryCast<int>(json['height']) ?? 0,
      // Manually map the nested 'breeds' array
      breeds: (json['breeds'] as List<dynamic>?)
          ?.map((e) => Breed.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => _$CatBreedToJson(this);
}

// Class CatList: Used for the list of CatBreed objects (from /images/search endpoint)
@JsonSerializable()
class CatList {
  List<CatBreed> breeds;
  // This now holds CatBreed objects, which contain the image and nested Breed .

  CatList({required this.breeds});

  factory CatList.fromJson(dynamic json) {
    return CatList(
        breeds: (json as List<dynamic>)
            .map((dynamic e) => CatBreed.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}

// Helper function (keep this)
T? tryCast<T>(dynamic object) => object is T ? object : null;
