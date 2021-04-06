import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/activity_presenter.dart';
import 'package:flutter_application_1/backend/auth.dart';
import 'package:flutter_application_1/models/ChatMessage.dart';
import 'package:flutter_application_1/models/Conversation.dart';
import 'package:image_picker/image_picker.dart';



class PrivateChatScreen extends StatefulWidget {
  final String conversation_id;
  // ignore: sort_constructors_first
  PrivateChatScreen({this.conversation_id}); // constructor
  @override
  _PrivateChatScreenState createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {

  // initialize activity presenter
  final ActivityPresenter _activityPresenter = ActivityPresenter();

  final TextEditingController _textController  = TextEditingController();

  Conversation convo;
  List<ChatMessage> messagesList;
  bool dataLoading = false;
  String current_user;
  Map<String, String> usernameMap;
  Map<String, String> avatarMap;

  // listener for new messages
  DatabaseReference _messageDatabaseReference;


  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  void loadData() async{
    setState(() {
      // Data is still loading
      dataLoading = true;
    });

    // get current user's uid
    current_user = await currentUser(); // from auth.dart

    // get usernames and avatars
    usernameMap = await _activityPresenter.getUsernameMap(widget.conversation_id);
    avatarMap = await _activityPresenter.getAvatarMap(widget.conversation_id);

    // get conversation instance
    convo = await _activityPresenter.readConversation(widget.conversation_id);
    await print('convo retrieved: ${convo.conversation_id}');

    // get list of messages
    messagesList = await _activityPresenter.readChatMessage(convo.messages);

    // add listener
    if (_messageDatabaseReference==null){
      _messageDatabaseReference = FirebaseDatabase.instance.reference().child('Conversation').child(convo.conversation_id);
      _messageDatabaseReference.onChildChanged.listen(_onMessageAdded);
      print('listener added');
    }

    setState(() {
      // Data is done loading
      dataLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: dataLoading == false ?
      Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                  padding: EdgeInsets.all(8.0),

                  reverse: true,
                  itemCount: messagesList.length,
                  itemBuilder: (_, int index) {
                    var msg = messagesList[index];
                    var sender = msg.sender_uid;
                    return chatBubble(context, avatarMap[sender], usernameMap[sender], msg.text, msg.imageUrl);
                  }
              ),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              // child: _buildTextComposer(context),
              child: Container(
                color: Colors.red,
              ),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(context),
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey[200]),
            ))
            : null,
      )
      : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildTextComposer(BuildContext context) {
    return IconTheme(
        data: IconThemeData(color: Theme.of(context).accentColor),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  decoration:
                  InputDecoration.collapsed(hintText: 'Send a message'),
                ),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: _sendImageFromCamera,
                      ),
                      IconButton(
                        icon: Icon(Icons.image),
                        onPressed: _sendImageFromGallery,
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async{
                          _handleSubmitted(_textController.text);
                        }
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }

  // text submitted
  void _handleSubmitted(String text) async {
    if (text.isEmpty){
      return;
    }

    _textController.clear();

    // create ChatMessage instance
    // add into ChatMessage db and get its ID
    var newkey = await _activityPresenter.addChatMessage(text, null, current_user);
    await print('newkey: $newkey');
    var mylist =  List<String>.from(convo.messages);
    mylist.add(newkey);
    convo.messages = mylist;


    print('after adding newkey: $mylist');

    // add ChatMessageID into Conversation in db
    await _activityPresenter.updateConversation(convo);

    print('submitting');
  }

  void _sendImageFromCamera() async {
    //_sendImage(ImageSource.camera);
    var newkey = await  _activityPresenter.sendImage(ImageSource.camera, current_user);

    var mylist =  List<String>.from(convo.messages);
    mylist.add(newkey);
    convo.messages = mylist;
    await _activityPresenter.updateConversation(convo);
    print('sending from cam');
  }

  void _sendImageFromGallery() async {
    //_sendImage(ImageSource.camera);
    var newkey = await  _activityPresenter.sendImage(ImageSource.gallery, current_user);

    var mylist =  List<String>.from(convo.messages);
    mylist.add(newkey);
    convo.messages = mylist;
    await _activityPresenter.updateConversation(convo);
    print('sending from gallery');
  }

  // callback method for listener
  _onMessageAdded(Event event) async{
    await print('Lister trigger!');
    var new_cm_id = event.snapshot.value;
    new_cm_id = new_cm_id[new_cm_id.length-1];

    if (new_cm_id == 'defaultmessage') return;
    var new_cm = await _activityPresenter.readOneChatMessage(new_cm_id);

    if (!mounted) return;
    setState(() {
      messagesList.insert(0, new_cm);
    });
  }

}

Widget chatBubble(context, avatar, username, text, String imageUrl){
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            child: Text(username.substring(0,1)),
            //backgroundImage: NetworkImage(avatar),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(username,
                  style: Theme.of(context).textTheme.subtitle1),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: imageUrl == null
                    ? Text(text)
                    :Image.network(imageUrl),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

