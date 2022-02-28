import 'package:flutter/material.dart';
import 'package:flying_emoji/flying_emoji.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'Flying Emoji'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final _key = GlobalKey();
  final FlyingEmojiWidgetController _controller = FlyingEmojiWidgetController();

  @override
  Widget build(BuildContext context) {
    return _scaffold();
  }

  Widget _scaffold() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 300,
                width: 300,
                color: Colors.blueGrey,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('gg')));
                  },
                  child: const Text(
                    'gg',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.75, 0.75),
                child: GestureDetector(
                  onTapDown: (_) => _controller.onTapDown(),
                  onTapCancel: () => _controller.onTapCancel(),
                  child: TextButton(
                    key: _key,
                    onPressed: () => _controller.onStart(),
                    child: const Text('fire!'),
                  ),
                ),
              ),
            ],
          ),
          FlyingEmojiWidget(
            controller: _controller,
            keyForButton: _key,
          ),
        ],
      ),
    );
  }
}
