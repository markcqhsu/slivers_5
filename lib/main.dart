import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Member> _members = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final m = _members[index];
                return ListTile(
                  leading: ClipOval(
                    child: CircleAvatar(
                      // child: Text("L"),
                      child: Image.network(m.avatarUrl),
                      backgroundColor: Colors.white,
                      radius: 32,
                    ),
                  ),
                  title: Text(m.name),
                  subtitle: Text(m.id),
                  trailing: Text(m.team),
                );
              },
              childCount: _members.length,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final url = "https://h5.48.cn/resource/jsonp/allmembers.php?gid=10";
          final res =
              await http.get(Uri.parse(url)); //因為有get, 所以要用await & async
          if (res.statusCode != 200) {
            throw ("error");
          }
          print(res.body);
          final json = convert.jsonDecode(res.body);
          final members = json["rows"].map<Member>((row) {
            //把josn裡面的rows, map成一個自己的類
            return Member(
              id: row["sid"],
              name: row["sname"],
              team: row["tname"],
            );
          });
          // members.forEach((m)=>print(m));

          setState(() {
            _members = members.toList();
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class Member {
  final String id;
  final String name;
  final String team;

  Member({required this.id, required this.name, required this.team});

  String get avatarUrl => "https://www.snh48.com/images/member/zp_$id.jpg";

  @override
  String toString() => "$id: $name";
}
