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
      body: RefreshIndicator(

        onRefresh: () async{
          setState(() {
            _members.clear();
          });

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
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(),//斷開SliverPersistentHeader和 AppBar
              SliverPersistentHeader(
                delegate: _MyDelegate("Team SII", Color(0xff91cdeb)),
                pinned: true,
              ),
              _buildTeamList("SII"),
              SliverPersistentHeader(
                delegate: _MyDelegate("Team NII", Color(0xffae86bb)),
                pinned: true,
              ),
              _buildTeamList("NII"),
              SliverPersistentHeader(
                delegate: _MyDelegate("Team HII", Color(0xfff39800)),
                pinned: true,
              ),
              _buildTeamList("HII"),
              SliverPersistentHeader(
                delegate: _MyDelegate("Team X",Color(0xffa9cc29) ),
                pinned: true,
              ),
              _buildTeamList("X"),
            ],
          ),
        ),
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

   _buildTeamList(String teamName) {
    final teamMembers = _members.where((m) => m.team == teamName).toList();

    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final m = teamMembers[index];
          return Column(
            children: [
              ClipOval(
                child: CircleAvatar(
                  // child: Text("L"),
                  child: Image.network(m.avatarUrl),
                  backgroundColor: Colors.white,
                  radius: 32,
                ),
              ),
              Text(m.name),
            ],
          );
        },
        childCount: teamMembers.length,
      ), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
    ),
    );
  }
}

class _MyDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final Color color;

  _MyDelegate(this.title, this.color);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 32,
      color: color,
      child: FittedBox(child: Text(title)),
    );
  }

  @override
  double get maxExtent => 32;

  @override
  double get minExtent => 32;

  @override
  bool shouldRebuild(covariant _MyDelegate oldDelegate) {
    //上次的oldDelegate.title是否等於現在的title, 不等於就重新繪製
    // return oldDelegate.title != title;
    return true;
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
