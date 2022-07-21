import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({Key? key, required this.server}) : super(key: key);

  @override
  _ChatPage createState() => _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static const clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = List<_Message>.empty(growable: true);
  late String mymessage;

  String _messageBuffer = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      print("0000000");
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        print("xxxxxxxxxxxxxxxxxxxx");
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  int acc = 0;
  int credits = 5;
  Color accident = Colors.black;

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Row> list = messages.map((message) {
      return Row(
        mainAxisAlignment: message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color:
                    message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(message.text.trim()),
                style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    }).toList();
    // int acc = 0;
    final serverName = widget.server.name ?? "Unknown";
    return Scaffold(
      appBar: AppBar(
          title: (isConnecting
              ? Text('Connecting chat to $serverName...')
              : isConnected
                  ? Text('Live chat with $serverName')
                  : Text('Chat log with $serverName'))),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Text("accident $acc", style: TextStyle(fontSize: 60)),
            Text(
              "Credit Left $credits",
              style: const TextStyle(fontSize: 60),
            ),
            Flexible(
              child: ListView(
                  padding: const EdgeInsets.all(12.0),
                  controller: listScrollController,
                  children: list),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: TextField(
                      style: const TextStyle(fontSize: 15.0),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: isConnecting
                            ? 'Wait until connected...'
                            : isConnected
                                ? 'Type your message...'
                                : 'Chat got disconnected',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      enabled: isConnected,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: isConnected
                          ? () => _sendMessage(textEditingController.text)
                          : null),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    print("2222222222222222before2222222222222 $data");
    // print(data.runtimeType);
    String x;

    // if (65 >= data && data <= 69) {
    //   setState(() {
    //     credits = 66 - data;
    //   });
    // }
    for (var i in data) {
      x = String.fromCharCode(i);

      if (x == "1") {
        print("1");
        setState(() {
          acc = 1;
        });
      }
      if (x == "0") {
        print("0");
        setState(() {
          acc = 0;
        });
      }
    }

    setState(() {
      if (data == 49) {
        print("1");
        acc = 1;
      } else if (data == 48) {
        acc = 0;
        print("0");
      }
    });
    // bool dotFound = false;
    // double prefix = 0, suffix = 0, val;
    // for (var i in data) {
    // print(String.fromCharCode(i));
    // if (i == 32) {
    //   String st = prefix.toString() + "." + suffix.toString();
    //   val = double.parse(st);
    //   print(val);
    //   dotFound = false;
    //   prefix = 0;
    //   suffix = 0;
    //   continue;
    // } else if (i == 46) {
    //   dotFound = true;
    //   continue;
    // }
    // if (dotFound) {
    //   String st = String.fromCharCode(i);
    //   print('============================================================');
    //   print(st);
    //   suffix = suffix * 10 + int.parse(st);
    // } else {
    //   String st = String.fromCharCode(i);
    //   print('============================================================');
    //   print(st);
    //   prefix = prefix * 10 + int.parse(st);
    // }
    // if (i == 10) {
    //   mytxt.add(" ");
    // } else {
    //   mytxt.add(String.fromCharCode(i));
    // }
  }
  // print("000000 ${mytxt}");
  // print(Utf8Decoder().convert(mytxt));
  // print(mytxt.join(""));
  // print(res);
  // Allocate buffer for parsed data
  // int backspacesCounter = 0;
  // data.forEach((byte) {
  //   if (byte == 8 || byte == 127) {
  //     backspacesCounter++;
  //   }
  // });
  // Uint8List buffer = Uint8List(data.length - backspacesCounter);
  // int bufferIndex = buffer.length;
  // // Apply backspace control character
  // backspacesCounter = 0;
  // for (int i = data.length - 1; i >= 0; i--) {
  //   if (data[i] == 8 || data[i] == 127) {
  //     backspacesCounter++;
  //   } else {
  //     if (backspacesCounter > 0) {
  //       backspacesCounter--;
  //     } else {
  //       buffer[--bufferIndex] = data[i];
  //     }
  //   }
  // }
  // print("111111111111111 buffer $buffer");
  // // setState(() {
  // //   mymessage = "$mymessage$buffer";
  // // });
  // // print(mymessage);
  // // Create message if there is   line character
  // String dataString = String.fromCharCodes(buffer);
  // print("dataString $dataString");
  // int index = buffer.indexOf(13);
  // if (~index != 0) {
  //   setState(() {
  //     print("0000000000000000000000 $dataString");
  //     messages.add(
  //       _Message(
  //         1,
  //         backspacesCounter > 0
  //             ? _messageBuffer.substring(
  //                 0, _messageBuffer.length - backspacesCounter)
  //             : _messageBuffer + dataString.substring(0, index),
  //       ),
  //     );
  //     _messageBuffer = dataString.substring(index);
  //     print("0000000000000000 $_messageBuffer");
  //   });
  // } else {
  //   _messageBuffer = (backspacesCounter > 0
  //       ? _messageBuffer.substring(
  //           0, _messageBuffer.length - backspacesCounter)
  //       : _messageBuffer + dataString);
  // }
  // }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.isNotEmpty) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode("$text\r\n")));
        await connection!.output.allSent;

        setState(() {
          print("textttttttttttttttttttttttttt $text");
          messages.add(_Message(clientID, text));
        });

        Future.delayed(const Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
