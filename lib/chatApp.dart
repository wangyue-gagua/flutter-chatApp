import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_flu_app/src/ApplicationState.dart';
import 'package:my_flu_app/src/authentication.dart';
import 'package:provider/provider.dart';

class FriendlyChatApp extends StatelessWidget {
  const FriendlyChatApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FriendlyChat',
      home: ChangeNotifierProvider(
        create: (context) => ApplicationState(),
        builder: (context, _) => Consumer<ApplicationState>(
          builder: (buildContext, appState, _) => ChatScreen(
            guestBookMessages: appState.guestBookMessages,
              addMessage: (message) =>
                  appState.addMessageToGuestBook(message)
          ),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final List<GuestBookMessage> guestBookMessages;
  final FutureOr<void> Function(String message) addMessage;
  const ChatScreen({
    Key? key, required this.guestBookMessages, required this.addMessage,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(
          duration: const Duration(milliseconds: 700), vsync: this),
    );
    setState(() {
      _messages.insert(0, message);
    });
    _focusNode.requestFocus();
    message.animationController.forward();

    // send to firebase
    widget.addMessage(text);
  }

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(children: [
        Flexible(
          child: TextField(
            onChanged: (String text) {
              setState(() {
                _isComposing = text.isNotEmpty;
              });
            },
            controller: _textController,
            onSubmitted: _isComposing ? _handleSubmitted : null,
            decoration: InputDecoration.collapsed(hintText: 'Send a message'),
            focusNode: _focusNode,
          ),
        ),
        IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: _isComposing
                  ? () => _handleSubmitted(_textController.text)
                  : null,
            ),
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FriendlyChat'),
      ),
      body: Column(
        children: [
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Authentication(
                loginState: appState.loginState,
                email: appState.email,
                startLoginFlow: appState.startLoginFlow,
                verifyEmail: appState.verifyEmail,
                signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
                cancelRegistration: appState.cancelRegistration,
                registerAccount: appState.registerAccount,
                signOut: appState.signOut),
          ),
          Flexible(
            child: ListView.builder(
              itemBuilder: (_, int index) {
                return HistoryMessage(text: widget.guestBookMessages[index].message,
                userName: widget.guestBookMessages[index].name,);
              },
              itemCount: widget.guestBookMessages.length,
              padding: EdgeInsets.all(8.0),
              reverse: true,
            ),
          ),
          Flexible(
            child: ListView.builder(
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
              padding: EdgeInsets.all(8.0),
              reverse: true,
            ),
          ),
          Divider(
            height: 1.0,
          ),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          )
        ],
      ),
    );
  }
}

String _name = "Wang yue";
class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {Key? key, required this.text, required this.animationController})
      : super(key: key);
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: animationController, curve: Curves.elasticOut),
      axisAlignment: 2.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                child: Text(_name[0]),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _name,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HistoryMessage extends StatelessWidget {
  const HistoryMessage(
      {Key? key, required this.text, required this.userName,})
      : super(key: key);
  final String text;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        textDirection: TextDirection.ltr,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  userName,
                  style: Theme.of(context).textTheme.headline4,
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text(text),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              child: Text(userName[0]),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Consumer<ApplicationState>(
          builder: (context, appState, _) => Authentication(
              loginState: appState.loginState,
              email: appState.email,
              startLoginFlow: appState.startLoginFlow,
              verifyEmail: appState.verifyEmail,
              signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
              cancelRegistration: appState.cancelRegistration,
              registerAccount: appState.registerAccount,
              signOut: appState.signOut),
        ),
      ],
    );
  }
}
