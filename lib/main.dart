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
        onRefresh: () async {
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
              pinyin: row["pinyin"],
              abbr: row["abbr"],
              tid: row["tid"],
              tname: row["tname"],
              pid: row["pid"],
              pname: row["pname"],
              nickname: row["nickname"],
              company: row["company"],
              join_day: row["join_day"],
              height: row["height"],
              birth_day: row["birth_day"],
              star_sign_12: row["star_sign_12"],
              star_sign_48: row["star_sign_48"],
              birth_place: row["birth_place"],
              speciality: row["speciality"],
              hobby: row["hobby"],
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
              const SliverToBoxAdapter(), //斷開SliverPersistentHeader和 AppBar
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
                delegate: _MyDelegate("Team X", Color(0xffa9cc29)),
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
              pinyin: row["pinyin"],
              abbr: row["abbr"],
              tid: row["tid"],
              tname: row["tname"],
              pid: row["pid"],
              pname: row["pname"],
              nickname: row["nickname"],
              company: row["company"],
              join_day: row["join_day"],
              height: row["height"],
              birth_day: row["birth_day"],
              star_sign_12: row["star_sign_12"],
              star_sign_48: row["star_sign_48"],
              birth_place: row["birth_place"],
              speciality: row["speciality"],
              hobby: row["hobby"],
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
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DetailPage(member: m),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: m.avatarUrl,
                  child: ClipOval(
                    child: CircleAvatar(
                      // child: Text("L"),
                      child: Image.network(m.avatarUrl),
                      backgroundColor: Colors.white,
                      radius: 32,
                    ),
                  ),
                ),
                Text(m.name),
              ],
            ),
          );
        },
        childCount: teamMembers.length,
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120,
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

  final String pinyin;
  final String abbr;
  final String tid;
  final String tname;
  final String pid;
  final String pname;
  final String nickname;
  final String company;
  final String join_day;
  final String height;
  final String birth_day;
  final String star_sign_12;
  final String star_sign_48;
  final String birth_place;
  final String speciality;
  final String hobby;

  Member({
    required this.id,
    required this.name,
    required this.team,
    required this.pinyin,
    required this.abbr,
    required this.tid,
    required this.tname,
    required this.pid,
    required this.pname,
    required this.nickname,
    required this.company,
    required this.join_day,
    required this.height,
    required this.birth_day,
    required this.star_sign_12,
    required this.star_sign_48,
    required this.birth_place,
    required this.speciality,
    required this.hobby,
  });

  String get avatarUrl => "https://www.snh48.com/images/member/zp_$id.jpg";

  @override
  String toString() => "$id: $name";
}

class DetailPage extends StatelessWidget {
  final Member member;

  const DetailPage({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: BackButton(color: Colors.black,),
            pinned: true,
            backgroundColor: Colors.pink[50],
            expandedHeight: 300,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "SNH48-${member.name}",
                style: TextStyle(color: Colors.grey[800]),
              ),
              background: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Image.network(
                            "https://img.freepik.com/free-vector/vibrant-pink-watercolor-painting-background_53876-58931.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(height: 2, color: Colors.pink[100],),
                      Expanded(child: SizedBox()),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(100.0),
                      child: AspectRatio(
                          aspectRatio: 1,
                          child: Hero(
                            tag: member.avatarUrl,
                            child: Material(
                              shape: CircleBorder(),
                              elevation: 8.0,
                              child: ClipOval(
                                  child: Image.network(
                                member.avatarUrl,
                                fit: BoxFit.cover,
                              )),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              collapseMode: CollapseMode.pin,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildInfo("拼音", member.pinyin),
                _buildInfo("加入所屬", member.pname),
                _buildInfo("暱稱", member.nickname),
                _buildInfo("加入日期", member.join_day),
                _buildInfo("身高", "${member.height} cm"),
                _buildInfo("生日", member.birth_day),
                _buildInfo("星座", member.star_sign_12),
                _buildInfo("出生地", member.birth_place),
                _buildInfo("特長", member.speciality),
                _buildInfo("興趣愛好", member.hobby),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildInfo(String label, String content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label),
            Text(
              content,
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}
