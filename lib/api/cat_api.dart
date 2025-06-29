/*
 * Copyright (c) 2023 Kodeco LLC.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify,
 * merge, publish, distribute, sublicense, create a derivative work,
 * and/or sell copies of the Software in any work that is designed,
 * intended, or marketed for pedagogical or instructional purposes
 * related to programming, coding, application development, or
 * information technology. Permission for such use, copying,
 * modification, merger, publication, distribution, sublicensing,
 * creation of derivative works, or sale is expressly withheld.
 *
 * This project and source code may use libraries or frameworks
 * that are released under various Open-Source licenses. Use of
 * those libraries and frameworks are governed by their own
 * individual licenses.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 */

// import 'network.dart'; // No longer needed if using http.get directly in CatAPI

import 'package:http/http.dart' as http; // Import the http package

const String apiKey =
    '''live_CnZOJitopylWlHfqcEoeYcsUPkAJqtstrmNUZicjTazkTicuhzhKXbOOchklGzgVy'''; // Your API Key

// IMPORTANT: Ensure this matches the port your cors-anywhere server is running
const String proxyUrl = 'http://localhost:8080/';

// Base URLs for TheCatAPI endpoints
const String catAPIURL =
    'https://api.thecatapi.com/v1/breeds'; // For all breeds or breed search
const String catImageAPIURL =
    'https://api.thecatapi.com/v1/images/search'; // For image search

class CatAPI {
  // Method to get a list of all cat breeds
  Future<String> getCatBreeds() async {
    final response = await http.get(
      Uri.parse('$proxyUrl$catAPIURL'), // Proxy the request
      headers: {
        'x-api-key': apiKey, // API key should be in headers
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load cat breeds: ${response.statusCode}');
    }
  }

  // Method to get an image
  //(which might contain nested breed details) for a specific breed ID
  Future<String> getCatBreed(String breedId) async {
    // Renamed parameter from breedName to breedId for clarity
    final response = await http.get(
      Uri.parse('$proxyUrl$catImageAPIURL?breed_id=$breedId'),
      // Proxy and add breed_id as query param
      headers: {
        'x-api-key': apiKey, // API key should be in headers
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
          'Failed to load cat image details for $breedId: ${response.statusCode}');
    }
  }

  // >>> ADDED NEW METHOD <<<
  // Method to get detailed information for a specific breed ID directly from the /breeds endpoint
  Future<String> getBreedDetailsById(String breedId) async {
    final response = await http.get(
      // The /breeds endpoint can be searched by 'q' parameter which accepts breed ID or name
      Uri.parse('$proxyUrl$catAPIURL/search?q=$breedId'), // Proxy the request
      headers: {
        'x-api-key': apiKey, // API key should be in headers
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load specific breed details' +
          'for $breedId: ${response.statusCode}');
    }
  }
}
