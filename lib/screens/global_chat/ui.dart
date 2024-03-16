import 'package:am_chat/screens/global_chat/controller.dart';
import 'package:am_chat/screens/global_chat/model.dart';
import 'package:am_state/am_state.dart';
import 'package:flutter/material.dart';

class ScreenUIGlobalChat extends AmViewWidget<ScreenControllerGlobalChat> {
  const ScreenUIGlobalChat({super.key});

  @override
  Widget build(BuildContext context, am) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Global Chatting 00"),
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
                  if (!am.state.connectionState)
                    ConnectBox(
                      connectFn: am.connectBtn,
                      onUsrChanged: (userName) => am.state.userName = userName,
                      onIDChanged: (roomID) => am.state.roomID = roomID,
                      isCreate: am.state.createOrJoin,
                      toggleCreateJoin: am.toggleCreateJoin,
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: am.state.msgList.length,
                      itemBuilder: (ctx, i) {
                        var msg = am.state.msgList[i];
                        return Text("${msg.userName}: ${msg.body}");
                      },
                    ),
                  ),
                  SendBox(
                    onChanged: (msg) => am.state.message = msg,
                    sendFn: am.sendBtn,
                  ),
                ],
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

class ConnectBox extends StatelessWidget {
  const ConnectBox({
    super.key,
    required this.connectFn,
    required this.onUsrChanged,
    required this.onIDChanged,
    required this.isCreate,
    required this.toggleCreateJoin,
  });

  final void Function() connectFn;
  final void Function(String userName) onUsrChanged;
  final void Function(String roomID) onIDChanged;
  final void Function() toggleCreateJoin;
  final bool isCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blueGrey, Colors.deepPurple],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 2,
            blurStyle: BlurStyle.outer,
            blurRadius: 10,
          )
        ],
      ),
      // padding: const EdgeInsets.all(4),
      height: 300,
      width: 400,
      clipBehavior: Clip.hardEdge,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Container(
            color: Theme.of(context).dialogBackgroundColor,
            padding: const EdgeInsets.only(bottom: 1.5),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: IconButton.filledTonal(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)))),
                    padding: const EdgeInsets.all(10),
                    onPressed: !isCreate ? toggleCreateJoin : null,
                    isSelected: !isCreate,
                    icon: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Create'),
                        SizedBox(width: 5),
                        Icon(Icons.create_rounded),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 1.5),
                Expanded(
                  child: IconButton.filledTonal(
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)))),
                    padding: const EdgeInsets.all(10),
                    onPressed: isCreate ? toggleCreateJoin : null,
                    isSelected: isCreate,
                    icon: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Join'),
                        SizedBox(width: 5),
                        Icon(Icons.join_full_rounded),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (isCreate)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextField(
                onChanged: onIDChanged,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Room ID",
                  labelText: "Room ID",
                ),
              ),
            ),
          if (!isCreate)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextField(
                key: UniqueKey(),
                textAlign: TextAlign.center,
                readOnly: true,
                controller: TextEditingController(text: "124523"),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Room ID",
                  labelText: "Room ID",
                  contentPadding: const EdgeInsets.all(13),
                ),
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              onChanged: onUsrChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Username",
                labelText: "Username",
              ),
            ),
          ),
          const SizedBox(height: 20),
          IconButton.filledTonal(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1.5, color: Theme.of(context).hintColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: connectFn,
            icon: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Connect'),
                SizedBox(width: 5),
                Icon(Icons.connect_without_contact_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SendBox extends StatelessWidget {
  const SendBox({super.key, required this.sendFn, required this.onChanged});
  final void Function() sendFn;
  final void Function(String msg) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blueGrey, Colors.deepPurple],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 2,
            blurStyle: BlurStyle.outer,
            blurRadius: 4,
          )
        ],
      ),
      padding: const EdgeInsets.all(4),
      height: 50,
      clipBehavior: Clip.hardEdge,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: TextField(
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 5),
          IconButton.filledTonal(
            onPressed: sendFn,
            icon: const Icon(Icons.send, size: 25),
          ),
        ],
      ),
    );
  }
}
