import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'Album.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePageHook("Flutter Hooks!"),
    );
  }
}

class MyHomePageHook extends HookWidget {
  final String title;

  MyHomePageHook(this.title);

  @override
  Widget build(BuildContext context) {
    final counter = useState(1);
    final albumData = useState(Album());
    final albumList = useState(<Album>[]);

    useEffect(() {
      Future.microtask(() async {
        albumData.value = await fetchAlbum(1);
        albumList.value = await fetchAlbumList();
      });
      return () {
        print('good bye');
      };
    }, []);

    void updateAlbumTitle(int id) {
      Future.microtask(() async {
        albumData.value = await fetchAlbum(id);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Show album with id:'+counter.value.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              albumData.value.title.toString(),
              style: Theme.of(context).textTheme.headline5,
            ),
            DataTable(
              sortAscending: true,
              sortColumnIndex: 0,
              columns: [
                DataColumn(label: Text("Id"), numeric: true, tooltip: "Id"),
                DataColumn(
                  label: Text("Title"),
                  numeric: false,
                  tooltip: "Title",
                ),
                DataColumn(
                  label: Text("UserId"),
                  numeric: true,
                  tooltip: "UserId",
                ),
              ],
              rows: albumList.value.take(10)
                  .map(
                    (album) => DataRow(
                        cells: [
                          DataCell(
                            Text(album.id.toString()),
                          ),
                          DataCell(
                            Text(album.title),
                          ),
                          DataCell(
                            Text(album.userId.toString()),
                          ),
                        ]),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.value++;
          updateAlbumTitle(counter.value);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future<Album> fetchAlbum(int id) async {
  final response = await http.get(Uri.parse(
      'https://jsonplaceholder.typicode.com/albums/' + id.toString()));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<List<Album>> fetchAlbumList() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new Album.fromJson(data)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
