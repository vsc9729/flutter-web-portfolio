import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:portfolio/serializers/series_info.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:portfolio/services/local_storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeriesRepo {
  final String _baseUrl =
      'https://moviesdatabase.p.rapidapi.com/titles?list=most_pop_series&info=base_info';
  Random rnd = Random();
  int max = 50;
  List<int> pagesVisited = [];
  int getRandomNumber() {
    int pageNumber = rnd.nextInt(max);
    if (pagesVisited.contains(pageNumber)) {
      return getRandomNumber();
    } else {
      pagesVisited.add(pageNumber);
      return rnd.nextInt(max);
    }
  }

  int getHighScore() {
    return localStorage.getHighScore();
  }

  Future<void> setHighScore(int highScore) async {
    await localStorage.setHighScore(highScore);
  }

  Map<String, String> headers = {
    'x-rapidapi-key': dotenv.env['RAPID_API_KEY'].toString(),
    'x-rapidapi-host': "moviesdatabase.p.rapidapi.com",
  };

  Future<List<ShowData>?> getSeries() async {
    try {
      int page1 = getRandomNumber();
      int page2 = getRandomNumber();
      List<http.Response> responses = await Future.wait([
        http.get(
            Uri.parse(
              '$_baseUrl&page=$page1',
            ),
            headers: headers),
        http.get(
            Uri.parse(
              '$_baseUrl&page=$page2',
            ),
            headers: headers),
      ]);
      List<ShowData> showsData = [];
      SeriesInfo seriesInfo1 =
          SeriesInfo.fromJson(jsonDecode(responses[0].body));
      SeriesInfo seriesInfo2 =
          SeriesInfo.fromJson(jsonDecode(responses[1].body));
      showsData.addAll(seriesInfo1.shows ?? []);
      showsData.addAll(seriesInfo2.shows ?? []);
      showsData.shuffle();
      return showsData;
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }
}
