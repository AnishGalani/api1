import 'package:api1/main.dart';
import 'package:flutter/material.dart';

class Second extends StatefulWidget {
  const Second({super.key});

  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> {
  List l = [];
  bool temp = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_data();
  }

  get_data() async {
    String sql = "select * from user";
    l = await Dashboard.database!.rawQuery(sql);
    print(l);
    temp = true;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data"),
        backgroundColor: Colors.grey.shade600,
      ),
      body: ListView.builder(itemCount: l.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("${l[index]['email']}"),
            subtitle: Text("${l[index]['password']}"),
          );
        },
      ),
    );
  }
}
