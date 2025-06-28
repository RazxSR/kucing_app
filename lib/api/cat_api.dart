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

import 'network.dart';

const String apiKey =
    '''live_CnZOJitopylWlHfqcEoeYcsUPkAJqtstrmNUZicjTazkTicuhzhKXbOchklGzgVy''';

// Define the proxyUrl constant here
const String proxyUrl =
    'http://localhost:8080/'; // MAKE SURE THIS MATCHES THE PORT YOUR CORS-ANYWHERE SERVER IS RUNNING ON

// 1
const String catAPIURL = '${proxyUrl}https://api.thecatapi.com/v1/breeds?';
// 2
const String catImageAPIURL =
    '${proxyUrl}https://api.thecatapi.com/v1/images/search?';
// 3
const String breedString = 'breed_id=';
// 4
const String apiKeyString = 'x-api-key=$apiKey';

class CatAPI {
  // 5
  Future<String> getCatBreeds() async {
    // 6
    final network = Network('$catAPIURL$apiKeyString');
    // 7
    final catData = await network.getData();
    return catData;
  }

  // 8
  Future<String> getCatBreed(String breedName) async {
    final network =
        Network('$catImageAPIURL$breedString$breedName&$apiKeyString');
    final catData = await network.getData();
    return catData;
  }
}
