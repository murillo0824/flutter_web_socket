import 'package:flutter/material.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> messages = <String>[];
  late WebSocketChannel channel;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8000'),
        protocols: {'ws-sample'});
    channel.stream.listen((message) {
      print(message);
      setState(() {
        messages.add(message);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    void _sendMessage() {
      if (_controller.text.isNotEmpty) {
        channel.sink.add(_controller.text);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            ...messages.map((element) => ListTile(title: Text(element)))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 100.0,
          child: Form(
            child: TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.message),
                labelText: 'Send message',
              ),
              textInputAction: TextInputAction.next,
              controller: _controller,
              validator: (String? value) {
                return '';
              },
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    channel.sink.close(status.goingAway);
    super.dispose();
  }
}
