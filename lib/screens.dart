import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Inicio',
                      style: TextStyle(
                          color: Color.fromRGBO(75, 75, 75, 1),
                          decoration: TextDecoration.none,
                          fontSize: 30),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.search,
                              color: Colors.black54, size: 45),
                        ),
                        Icon(
                          Icons.settings,
                          color: Colors.black54,
                          size: 45,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Hoje, 11 de Julho',
                  style: TextStyle(
                      color: Color.fromRGBO(129, 129, 129, 1),
                      decoration: TextDecoration.none,
                      fontSize: 15),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 15),
                    height: 1,
                    color: Color.fromRGBO(129, 129, 129, 1),
                    child: Icon(null),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 18, bottom: 18),
              decoration: BoxDecoration(
                color: Color.fromRGBO(241, 143, 143, 1),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                ],
              ),
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 18, left: 18),
                          child: Text('Nome da Reuniao',
                              style: TextStyle(fontSize: 20))),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 10, left: 18),
                          child: Text('09:00 - 10:30',
                              style: TextStyle(fontSize: 17, color: Color.fromRGBO(108, 108, 108, 1)))),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 10, left: 18),
                          child: CircleAvatar(
                            backgroundColor: Colors.brown.shade800,
                            child: Text('AH'),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final Function openSettings;

  const SettingsScreen({Key key, this.openSettings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("Push other Settings"),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewPage(),
            ),
          );
        },
      ),
    );
  }
}

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Screen',
        ),
      ),
      body: Container(
        child: FlatButton(
          child: Text("Push new Screen"),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
