// lib/cat_info.dart

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import '../api/cat_api.dart';
import '../models/cats.dart';

// IMPORTANT: Ensure this matches the port your cors-anywhere server is running
const String proxyUrl = 'http://localhost:8080/';

class CatInfo extends StatefulWidget {
  final String catBreed; // This is the name passed from the list
  final String catId; // This is the ID passed from the list

  CatInfo({required this.catBreed, required this.catId});

  @override
  State<CatInfo> createState() => _CatInfoState();
}

class _CatInfoState extends State<CatInfo> {
  // This will hold the image data (from /images/search)
  CatBreed? _catImageDetails;

  // This will hold the full breed details (from nested in image or from secondary /breeds call)
  Breed? _fullBreedDetails;

  bool _isLoading = true; // Added loading state

  @override
  void initState() {
    super.initState();
    _fetchCatData();
  }

  Future<void> _fetchCatData() async {
    print('CatInfo: Initiating API calls for breed ID: ${widget.catId}');
    _isLoading = true; // Set loading to true at the start
    if (mounted) setState(() {}); // Update UI to show loading indicator

    try {
      // 1. Attempt to get image and nested breed details from /images/search
      final imageJson = await CatAPI().getCatBreed(widget.catId);
      print('CatInfo: Raw JSON received from images/search: $imageJson');

      if (!mounted) return;

      if (imageJson.isNotEmpty && imageJson != '[]') {
        final List<dynamic> parsedImageJson = json.decode(imageJson);
        if (parsedImageJson.isNotEmpty) {
          _catImageDetails = CatBreed.fromJson(parsedImageJson[0]);

          // If nested breed details are present in the image response, use them
          if (_catImageDetails!.breeds != null &&
              _catImageDetails!.breeds!.isNotEmpty) {
            _fullBreedDetails = _catImageDetails!.breeds![0];
            print(
                'CatInfo: Full breed details found nested in image response.');
          }
        }
      }

      // 2. If full breed details are still missing, make a secondary call to /breeds/search
      if (_fullBreedDetails == null) {
        print(
            'CatInfo: Full breed details not found in image response. Attempting secondary /breeds call.');
        final detailsJson = await CatAPI().getBreedDetailsById(widget.catId);
        print('CatInfo: Raw JSON received from breeds/search: $detailsJson');

        if (!mounted) return;

        if (detailsJson.isNotEmpty && detailsJson != '[]') {
          final List<dynamic> parsedDetailsJson = json.decode(detailsJson);
          if (parsedDetailsJson.isNotEmpty) {
            _fullBreedDetails = Breed.fromJson(parsedDetailsJson[0]);
            print(
                'CatInfo: Full breed details successfully fetched from /breeds/search.');
          } else {
            print(
                'CatInfo: Secondary /breeds/search call returned empty for ${widget.catId}.');
          }
        }
      }

      // If after both attempts, _catImageDetails is still null, it means no image .
      if (_catImageDetails == null) {
        print('CatInfo: No image found for ${widget.catId}.');
      }

      // Print full details to terminal if available
      if (_fullBreedDetails != null) {
        print(
            '\n--- Displaying Detailed Breed Info for ${_fullBreedDetails!.name} ---');
        print('ID: ${_fullBreedDetails!.id}');
        print('Description: ${_fullBreedDetails!.description}');
        print('Temperament: ${_fullBreedDetails!.temperament}');
        print('Origin: ${_fullBreedDetails!.origin}');
        print('Life Span: ${_fullBreedDetails!.lifeSpan} years');
        print('Affection Level: ${_fullBreedDetails!.affectionLevel}');
        print('Energy Level: ${_fullBreedDetails!.energyLevel}');
        if (_fullBreedDetails!.wikipediaUrl != null &&
            _fullBreedDetails!.wikipediaUrl!.isNotEmpty) {
          print('Wikipedia URL: ${_fullBreedDetails!.wikipediaUrl}');
        }
        print('---------------------------------------------------\n');
      } else {
        print(
            'CatInfo: No full breed details available after all attempts for ${widget.catId}.');
      }
    } catch (e) {
      print('CatInfo: Error fetching or parsing data for ${widget.catId}: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load details: $e')),
        );
      }
    } finally {
      _isLoading =
          false; // Set loading to false once data fetching is complete or
      if (mounted) setState(() {}); // Update UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.catBreed), // Still use the initial breed name for the title
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // If no image details are found at all, show a specific message
    if (_catImageDetails == null) {
      return Center(
        child: Text(
          'No image found for ${widget.catBreed}.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
        ),
      );
    }

    // Now, we always have _catImageDetails, but _fullBreedDetails might be null
    final mediaSize = MediaQuery.of(context).size;
    final String imageUrl = '${proxyUrl}${_catImageDetails!.url}';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cat Image (Always display if _catImageDetails is not null)
          Center(
            child: Container(
              width: mediaSize.width * 0.8,
              height: mediaSize.height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Display breed details if _fullBreedDetails is available
          if (_fullBreedDetails != null) ...[
            Text(
              _fullBreedDetails!.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              _fullBreedDetails!.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Temperament:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              _fullBreedDetails!.temperament,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Origin:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              _fullBreedDetails!.origin,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Life Span:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${_fullBreedDetails!.lifeSpan} years',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            if (_fullBreedDetails!.wikipediaUrl != null &&
                _fullBreedDetails!.wikipediaUrl!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'More Info:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () async {
                      final url = _fullBreedDetails!.wikipediaUrl!;
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Could not open Wikipedia link: $url')),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Wikipedia Page',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            const SizedBox(height: 10),
            const Text(
              'Affection Level:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${_fullBreedDetails!.affectionLevel}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Energy Level:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${_fullBreedDetails!.energyLevel}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
          ] else ...[
            // This block is executed if _fullBreedDetails is null
            Center(
              child: Text(
                'Detailed information not found for ${widget.catBreed}.',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
