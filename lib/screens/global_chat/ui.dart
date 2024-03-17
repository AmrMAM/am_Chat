import 'package:am_chat/models/message.dart';
import 'package:am_chat/screens/global_chat/controller.dart';
import 'package:am_chat/screens/global_chat/model.dart';
import 'package:am_state/am_state.dart';
import 'package:flutter/material.dart';
import '../../services/am_functions.dart';
import 'package:signalr_netcore/signalr_client.dart';

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
                  if (am.showConnect)
                    ConnectBox(
                      connectFn: am.connectBtn,
                      onUsrChanged: (userName) => am.state.userName = userName,
                      onIDChanged: (roomID) => am.state.roomID = roomID,
                      isCreate: am.state.createOrJoin,
                      toggleCreateJoin: am.toggleCreateJoin,
                    ),
                  Expanded(
                    child: ListView.builder(
                      controller: am.state.msgScrollerController,
                      itemCount: am.state.msgList.length + 1,
                      itemBuilder: (ctx, i) {
                        if (i >= am.state.msgList.length) {
                          return Container(
                            height: 20,
                          );
                        }
                        var msg = am.state.msgList[i];
                        var showIdentity = true;
                        if (i > 0) {
                          showIdentity =
                              msg.userName != am.state.msgList[i - 1].userName;
                        }
                        return MsgItem(
                          msg: msg,
                          showIdentity: showIdentity,
                          myUsername: am.state.userName,
                        );
                      },
                    ),
                  ),
                  if (am.globalChat.connectionState ==
                      HubConnectionState.Connected)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 10,
                      ),
                      child: SendBox(
                        sendFn: am.sendBtn,
                        toggleLTR: am.toggleLTR,
                        ltr: am.state.ltr,
                        msgBodyTextController: am.state.msgBodyTextController,
                      ),
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

class MsgItem extends StatelessWidget {
  const MsgItem({
    super.key,
    required this.msg,
    required this.showIdentity,
    required this.myUsername,
  });

  final ChatMessage msg;
  final bool showIdentity;
  final String myUsername;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          myUsername != msg.userName ? TextDirection.ltr : TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Flex(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showIdentity)
              CircleAvatar(
                radius: 25,
                child: Text(
                  AmFunctions.getShortName(msg.userName),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
            if (!showIdentity) const SizedBox(width: 50),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showIdentity)
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        Text(msg.userName),
                      ],
                    ),
                  const SizedBox(height: 3),
                  Container(
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
                          blurRadius: 5,
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    clipBehavior: Clip.hardEdge,
                    constraints: const BoxConstraints(
                      minWidth: 50,
                    ),
                    child: Text(
                      msg.body,
                      textDirection:
                          msg.ltr ? TextDirection.ltr : TextDirection.rtl,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }
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
      // height: 300,
      width: 400,
      clipBehavior: Clip.hardEdge,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Container(
            color: Theme.of(context).dialogBackgroundColor,
            padding: const EdgeInsets.only(bottom: 1),
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class SendBox extends StatelessWidget {
  const SendBox({
    super.key,
    required this.sendFn,
    required this.toggleLTR,
    required this.ltr,
    required this.msgBodyTextController,
  });
  final void Function() sendFn;
  final void Function() toggleLTR;
  final TextEditingController msgBodyTextController;
  final bool ltr;

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
      height: 50,
      clipBehavior: Clip.hardEdge,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          IconButton.filledTonal(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)))),
            padding: const EdgeInsets.all(10),
            onPressed: toggleLTR,
            icon: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rtt_outlined, size: 30),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: TextField(
                      controller: msgBodyTextController,
                      minLines: 1,
                      maxLines: 3,
                      textDirection:
                          ltr ? TextDirection.ltr : TextDirection.rtl,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          IconButton.filledTonal(
            onPressed: sendFn,
            icon: const Icon(Icons.send, size: 30),
          ),
          const SizedBox(width: 3),
        ],
      ),
    );
  }
}
