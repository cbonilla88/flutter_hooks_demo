import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'Album.dart';
import 'ApiClient.dart';

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
  final ApiService api = ApiService();

  MyHomePageHook(this.title);

  @override
  Widget build(BuildContext context) {
    final counter = useState(1);
    final albumData = useState(Album());
    final albumList = useState(<Album>[]);

    useEffect(() {
      Future.microtask(() async {
        albumData.value = await api.fetchAlbum(1);
        albumList.value = await api.fetchAlbumList();
      });
      return () {
        print('good bye');
      };
    }, []);

    void updateAlbumTitle(int id) {
      Future.microtask(() async {
        albumData.value = await api.fetchAlbum(id);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(5),
            height: 30,
            child: Text(
              'Show album with id: ' + albumData.value.id.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            height: 30,
            child: Text(
              albumData.value.title.toString(),
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Container(
                  child: DataTable(
                    sortAscending: true,
                    sortColumnIndex: 0,
                    columns: [
                      DataColumn(
                          label: Text("Id"), numeric: true, tooltip: "Id"),
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
                    rows: albumList.value
                        .take(50)
                        .map(
                          (album) => DataRow(
                              selected: albumData.value.id == album.id,
                              cells: [
                                DataCell(
                                  Text(album.id.toString()),
                                ),
                                DataCell(Text(album.title), onTap: () {
                                  updateAlbumTitle(album.id);
                                }),
                                DataCell(
                                  Text(album.userId.toString()),
                                ),
                              ]),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
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
