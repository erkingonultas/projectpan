import 'package:dio/dio.dart';
import 'package:projectpan/backend/api_keys.dart';
import 'package:projectpan/backend/models/chart_toptags.dart';
import 'package:projectpan/backend/models/tag_topartists_model.dart';

class LastFmHandler {
  static const String _lastfmBaseUrl = 'http://ws.audioscrobbler.com/2.0';

  Future<List<String>> getChartTopTags() async {
    Dio _dio = Dio();
    List<String> _tagList = [];

    final Response response = await _dio.get(
        '$_lastfmBaseUrl/?method=chart.gettoptags&api_key=$lastfmApiKey&format=json&limit=10');
    ChartTopTags chartTopTags = ChartTopTags.fromJson(response.data);
    for (Tag tag in chartTopTags.tags!.tag!) {
      _tagList.add(tag.name!);
    }
    return _tagList;
  }

  Future<List<Artist>> getTagTopArtists(String tagName) async {
    Dio _dio = Dio();
    List<Artist> _artistList = [];
    final Response response = await _dio.get(
        '$_lastfmBaseUrl/?method=tag.gettopartists&tag=$tagName&api_key=$lastfmApiKey&format=json&limit=10');

    TagTopArtists tagTopArtists = TagTopArtists.fromJson(response.data);
    for (Artist artist in tagTopArtists.topartists!.artist!) {
      _artistList.add(artist);
      // if (kDebugMode) {
      //   print('@@@\n${artist.name}\n@@@');
      // }
    }

    return _artistList;
  }
}
