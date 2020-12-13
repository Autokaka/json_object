import 'package:json_object/json_object.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var jsonObject = JsonObject.from('''[{
    "url": "https://baidu.com",
    "name": "Baidu",
    "time": 1234567890
  },{
    "url": "https://google.com.hk",
    "name": "Google",
    "time": 1234567890
  }]''');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("json测试"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          /// encode
          Text(
            "转换成对象后的jsonObject: ",
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(jsonObject.valueRuntimeType.toString()),
          Text(JsonObject.encodePretty(jsonObject, indent: 4)),

          /// get value
          Text(
            "Get方法测试",
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(jsonObject[0].getValue().toString()),
          Text(jsonObject[0].url.getValue().toString()),
          Text(jsonObject[0].name.getValue().toString()),

          /// set value
          Text(
            "Set方法测试",
            style: Theme.of(context).textTheme.headline5,
          ),
          MaterialButton(
            onPressed: () {
              setState(() {
                jsonObject[0].url = jsonObject[1].url;
              });
            },
            child: Text("设置百度链接为谷歌链接"),
          ),

          /// excecute test
          Text(
            "方法执行能力",
            style: Theme.of(context).textTheme.headline5,
          ),
          Column(
            children: (jsonObject.getValue() as List).map((item) {
              final itemObject = JsonObject.from(item);
              return Text(itemObject.name.getValue());
            }).toList(),
          ),
          MaterialButton(
            onPressed: () {
              setState(() {
                (jsonObject as JsonObject).apply<List>((list) {
                  final listCopy = List.from(list);
                  list.addAll(listCopy);
                  return list;
                });
              });
            },
            child: Text("列表长度升为4"),
          ),
        ],
      ),
    );
  }
}
