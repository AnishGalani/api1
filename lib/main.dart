import 'package:api1/second.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    home: Dashboard(),
    debugShowCheckedModeBanner: false,
  ));
}

class Dashboard extends StatefulWidget {
  static Database? database;

  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  int index = 0;

  bool err_email = false, err_pass = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_db();
  }

  get_db() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    await deleteDatabase(path);

    Dashboard.database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT)');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 40,
              child: Text(
                "Login accont",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.all(10),
              child: TextField(
                controller: t1,
                decoration: InputDecoration(
                    errorText: (err_email) ? "Enter Your Email" : null,
                    hintText: "Enter Email",
                    border: OutlineInputBorder()),
              ),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.all(10),
              child: TextField(
                obscureText: true,
                controller: t2,
                decoration: InputDecoration(
                    errorText: (err_pass) ? "Enter Your Password" : null,
                    hintText: "Enter Password",
                    labelText: "password",
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  String email, password;
                  email = t1.text;
                  password = t2.text;
                  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                  RegExp regExp = new RegExp(patttern);

                  if (email == "") {
                    err_email = true;
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Enter Your Email")));
                    setState(() {});
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(email)) {
                    err_email = true;
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Enter Your Vaild Email")));
                    setState(() {});
                  } else if (password == "") {
                    err_pass = true;
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Enter Your Password")));
                    setState(() {});
                  } else if (!RegExp(
                          r'^(?=.?[A-Z])(?=.?[a-z])(?=.?[0-9])(?=.?[!@#\$&*~]).{8,}$')
                      .hasMatch(password)) {
                    err_pass = true;
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Enter Your valid Password")));
                    setState(() {});
                  }
                  String qry =
                      "insert into user(email,password)VALUES('$email','$password')";
                  Dashboard.database!.rawInsert(qry).then((value) {
                    print("ID : $value");
                    print(qry);
                  });
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Second();
                    },
                  ));
                },
                child: Text("login")),
          ],
        ),
      ),
    );
  }
}
