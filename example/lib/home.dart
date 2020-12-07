import 'package:json_object/json_object.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var jsonStr = '''[{
    "url": "https://baidu.com",
    "name": "Baidu",
    "time": 1234567890
  },{
    "url": "https://google.com.hk",
    "name": "Google",
    "time": 1234567890
  }]''';
  var jsonObject;

  Widget buildDivider() {
    return Divider(
      thickness: 1,
      color: Theme.of(context).primaryColor,
    );
  }

  @override
  void initState() {
    super.initState();
    jsonObject = JsonObject().fromString(jsonStr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("json测试"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          /// get list
          Text(
            "转换成对象后的jsonObject: ",
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(jsonObject.getValue().runtimeType.toString()),
          Text(jsonObject.encodePretty(indent: 4)),

          /// get map
          buildDivider(),
          Text(
            "访问jsonObject[0]: ",
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(jsonObject[0].getValue().runtimeType.toString()),
          Text(jsonObject[0].encodePretty(indent: 4)),

          /// get url
          buildDivider(),
          Text(
            "访问jsonObject[0].url: ",
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(jsonObject[0].url.getValue().runtimeType.toString()),
          Text(jsonObject[0].url.encodePretty(indent: 4)),
          ElevatedButton(
            onPressed: () => setState(
              () => jsonObject[0].url = jsonObject[1].url.getValue(),
            ),
            child: Text("把百度的url改成谷歌的url"),
          ),

          /// get name
          buildDivider(),
          Text(
            "访问jsonObject[0].name: ",
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(jsonObject[0].name.getValue().runtimeType.toString()),
          Text(jsonObject[0].name.encodePretty(indent: 4)),

          /// get time
          buildDivider(),
          Text(
            "访问jsonObject[0].time: ",
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(jsonObject[0].time.getValue().runtimeType.toString()),
          Text(jsonObject[0].time.encodePretty(indent: 4)),
          ElevatedButton(
            onPressed: () => setState(
              () => jsonObject[0].time = 111111111,
            ),
            child: Text("修改jsonObject[0].time为111111111"),
          ),

          /// add key value pairs using dot operator
          buildDivider(),
          Text(
            "访问jsonObject[1].stars: ",
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(jsonObject[1].stars.getValue().runtimeType.toString()),
          Text(jsonObject[1].stars.encodePretty(indent: 4)),
          ElevatedButton(
            onPressed: () => setState(
              () => jsonObject[1].stars = 5,
            ),
            child: Text('jsonObject[1].stars = 5'),
          ),

          /// add key value pairs using add()
          buildDivider(),
          Text(
            "访问jsonObject[0].stars: ",
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(jsonObject[0].stars.getValue().runtimeType.toString()),
          Text(jsonObject[0].stars.encodePretty(indent: 4)),
          ElevatedButton(
            onPressed: () => setState(
              () => jsonObject[0].add("stars", 5),
            ),
            child: Text('jsonObject[0].add("stars", 5)'),
          ),
        ],
      ),
    );
  }
}
