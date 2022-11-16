import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatefulWidget {
  HomePage() : super();

  final String title = 'Socket Group Chat';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _textEditingController;
  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _connectSocketChannel();
  }

  _connectSocketChannel() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://echo.websocket.events'),
    );
  }

  void sendMessage() {
    _channel.sink.add(_textEditingController.text);
  }

  @override
  void dispose() {
    super.dispose();
    _channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      hintText: 'Enter your message'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_textEditingController.text.isEmpty) {
                      return;
                    }
                    sendMessage();
                  },
                  child: Text('Send Message'),
                ),
                StreamBuilder(
                  stream: _channel.stream,
                  builder: ((context, snapshot) {
                    return Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
