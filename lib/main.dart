import 'package:flutter/material.dart';
import 'package:my_app/login.dart';
import 'package:my_app/service.dart';
import 'package:provider/provider.dart';
import 'timeline_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ChangeNotifierProvider<TimelineModel>(
            create: (_) => TimelineModel(),
            child: HomePage(title: 'Timeline')));
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _id = -1;
  bool _favorite = false;

  void _onPressedStart(id) {
    setState(() {
      if (_id == id) {
        _id = -1;
      } else {
        _id = id;
      }
    });
  }

  void _tapFavorite(id) {
    setState(() {
      _id = id;
      _favorite = !_favorite;
    });
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      final Map<String, String> token =
          await twitterService.getAuthorizationAccount();

      if (token.containsKey("oauth_token")) {
        print("already account: ${token['oauth_token']}");
        twitterService.setAccount(
            token["oauth_token"]!, token["oauth_token_secret"]!);
        final model = Provider.of<TimelineModel>(context, listen: false);
        model.reflesh();
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginWidget(),
            ));
      }
    });
  }

  Widget tweeticon(BuildContext context, tweet) {
    return Padding(
        padding: EdgeInsets.all(3.0),
        child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(tweet.image),
                ))));
  }

  Widget tweetHeader(BuildContext context, tweet) {
    return Container(
      color: Color.fromRGBO(50, 50, 50, 50),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              tweet.name,
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              tweet.time,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget tweetbody(BuildContext context, index, tweet) {
    return Container(
      alignment: Alignment.topLeft,
      color: Color.fromRGBO(120, 120, 120, 80),
      child: GestureDetector(
        onTap: () {
          _onPressedStart(index);
        },
        child: Text(
          tweet.text,
          softWrap: true,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget tweetAction(BuildContext context, index) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Row(children: [
        Icon(Icons.reply),
        Spacer(),
        GestureDetector(
          onTap: () {
            _tapFavorite(index);
          },
          child: Icon((_favorite) ? Icons.favorite_border : Icons.favorite),
        ),
        Spacer(),
        Icon(Icons.share),
        Spacer(),
        Icon(Icons.more_horiz),
      ]),
    );
  }

  Widget buildTweet(BuildContext context, index, tweet) {
    return Container(
        padding: EdgeInsets.only(left: 0.0, top: 0),
        child: Column(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            tweeticon(context, tweet),
            Flexible(
              child: Column(
                children: [
                  tweetHeader(context, tweet),
                  tweetbody(context, index, tweet),
                  if (_id == index) tweetAction(context, index)
                ],
              ),
            ),
          ]),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.dehaze),
          actions: [Icon(Icons.create)],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: NetworkImage(
                    'https://pics.prcm.jp/4f519f398831a/82957762/jpeg/82957762.jpeg'),
                height: 28,
                width: 28,
              ),
              Padding(
                padding: EdgeInsets.all(3.0),
                child: Text(widget.title),
              )
            ],
          ),
        ),
        body: Consumer<TimelineModel>(builder: (context, model, child) {
          return Column(children: [
            GestureDetector(
              onTap: () {
                print("model list length ${model.list.length}");
                model.reflesh();
                model.list.forEach((item) {
                  print("account :${item.account}");
                });
                print("model list length ${model.list.length}");
              },
              child: Icon(Icons.dehaze),
            ),
            Flexible(
                child: ListView.separated(
              itemCount: model.list.length,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(color: Colors.black),
              itemBuilder: (BuildContext context, int index) {
                return buildTweet(context, index, model.list[index]);
              },
            ))
          ]);
        }) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
