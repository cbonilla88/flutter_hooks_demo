import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Album.dart';

class ApiService {
  final String apiUrl = "https://jsonplaceholder.typicode.com/albums/";

  Future<Album> fetchAlbum(int id) async {
    final response = await http.get(Uri.parse(apiUrl + id.toString()));

    if (response.statusCode == 200) {
       return Album.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Album>> fetchAlbumList() async {
    final response =
    await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new Album.fromJson(data)).toList();
    } else {
       throw Exception('Failed to load album');
    }
  }
/*
  Future<List<Cases>> getCases() async {
    Response res = await get(apiUrl);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Cases> cases = body.map((dynamic item) => Cases.fromJson(item)).toList();
      return cases;
    } else {
      throw "Failed to load cases list";
    }
  }

  Future<Cases> getCaseById(String id) async {
    final response = await get('$apiUrl/$id');

    if (response.statusCode == 200) {
      return Cases.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load a case');
    }
  }

  Future<Cases> createCase(Cases cases) async {
    Map data = {
      'name': cases.name,
      'gender': cases.gender,
      'age': cases.age,
      'address': cases.address,
      'city': cases.city,
      'country': cases.country,
      'status': cases.status
    };

    final Response response = await post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return Cases.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post cases');
    }
  }

  Future<Cases> updateCases(String id, Cases cases) async {
    Map data = {
      'name': cases.name,
      'gender': cases.gender,
      'age': cases.age,
      'address': cases.address,
      'city': cases.city,
      'country': cases.country,
      'status': cases.status
    };

    final Response response = await put(
      '$apiUrl/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return Cases.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update a case');
    }
  }

  Future<void> deleteCase(String id) async {
    Response res = await delete('$apiUrl/$id');

    if (res.statusCode == 200) {
      print("Case deleted");
    } else {
      throw "Failed to delete a case.";
    }
  }
*/
}