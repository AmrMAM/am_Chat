import 'package:am_chat/screens/global_chat/controller.dart';
import 'package:am_chat/screens/global_chat/model.dart';
import 'package:am_state/am_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScreenUIGlobalChat extends AmViewWidget<ScreenControllerGlobalChat> {
  const ScreenUIGlobalChat({super.key});

  @override
  Widget build(BuildContext context, am) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Global Chatting"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Flex(
                direction: Axis.vertical,
                children: [
                  const SizedBox(height: 30),
                  const Text('User Name'),
                  TextField(
                    onChanged: (value) => am.state.userName = value,
                    decoration: InputDecoration(
                      hintText: "User Name",
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text('Write message'),
                  TextField(
                    maxLines: 10,
                    onChanged: (value) => am.state.message = value,
                    decoration: InputDecoration(
                      hintText: "User Name",
                    ),
                  ),
                  TextButton(onPressed: am.sendBtn, child: const Text('Send'))
                ],
              ),
            ),
            TextButton(onPressed: am.connectBtn, child: const Text("Connect")),
            Expanded(
              child: ListView.builder(
                itemCount: am.state.msgList.length,
                itemBuilder: (ctx, i) {
                  var msg = am.state.msgList[i];
                  return Text("${msg.userName}: ${msg.body}");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  get config => ScreenControllerGlobalChat(ScreenModelGlobalChat());
}
