import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const DummyCarreteCard(),
      ),
    );
  }
}

class DummyCarreteCard extends StatelessWidget {
  const DummyCarreteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        // clipBehavior is necessary because, without it, the InkWell's animation
        // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
        // This comes with a small performance cost, and you should not set [clipBehavior]
        // unless you need it.
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            debugPrint('Card tapped.');
          },
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Text("Carrete 2/9"),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  height: 150.0,
                  child: ListView(
                    // This next line does the trick.
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        width: 150.0,
                        color: Colors.red,
                      ),
                      Container(
                        width: 150.0,
                        color: Colors.blue,
                      ),
                      Container(
                        width: 150.0,
                        color: Colors.green,
                      ),
                      Container(
                        width: 150.0,
                        color: Colors.yellow,
                      ),
                      Container(
                        width: 150.0,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
