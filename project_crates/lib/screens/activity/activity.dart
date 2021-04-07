import 'package:flutter/material.dart';
import 'package:flutter_application_1/backend/activity_presenter.dart';
import 'package:flutter_application_1/backend/auth.dart';
import 'package:flutter_application_1/models/Conversation.dart';
import 'package:flutter_application_1/models/ConversationCard.dart';
import 'package:flutter_application_1/models/Notifications.dart';
import 'package:flutter_application_1/screens/activity/privatechat.dart';
import 'package:flutter_application_1/screens/common/theme.dart';
import '../activity/notificationpage.dart';


class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Notifications'),
    Tab(text: 'Chats'),
  ];

  bool dataLoading = false;
  bool sort = false;
  List<Notifications> notiList = <Notifications>[];
  List<Conversation> conversationList = <Conversation>[];
  List<ConversationCard> conversationCardList = <ConversationCard>[];
  String current_user;

  final ActivityPresenter _activityPresenter = ActivityPresenter();

  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    setState(() {
      // Data is still loading
      dataLoading = true;
    });

    current_user = await currentUser();

    // load notifications
    notiList = await _activityPresenter.readNotificationList(current_user);

    // load conversations
    conversationList =
        await _activityPresenter.readConversationList(current_user);
    await print('Retrieved ${conversationList.length} in conversationList');

    // load notifications cards
    conversationCardList = await _activityPresenter.readConversationCardList(
        conversationList, current_user);
    await print(
        'Retrieved ${conversationCardList.length} in conversationCardLists');

    // set state
    setState(() {
      notiList = notiList;

      // Data is done loading
      dataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text('Activity',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.0))),
      ),
      body: dataLoading == false
          ? Container(
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).canvasColor,
                    shape: Border(
                      top: BorderSide(color: Theme.of(context).canvasColor),
                    ),
                    bottom: TabBar(
                      tabs: myTabs,
                      isScrollable: false,
                      indicatorWeight: 3.0,
                      //TODO OnTap Function
                    ),
                    automaticallyImplyLeading: false,
                    toolbarHeight: 60,
                  ),
                  body: TabBarView(
                    children: [
                      notiList.length ==0?
                      Padding(
                          padding: EdgeInsets.all(25),
                          child: Text(
                            'You have no notification available...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 15,

                            ),)
                      ):
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                                child:Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: TextButton.icon(
                                          icon: Icon(Icons.sort),
                                          label: Text('Sort'),
                                          onPressed: () {
                                            if (sort == false) {
                                              notiList.sort((a, b) {
                                                sort = true;
                                                return a.notiDate
                                                    .toString()
                                                    .toLowerCase()
                                                    .compareTo(b.notiDate
                                                    .toString()
                                                    .toLowerCase());
                                              });
                                            } else {
                                              notiList.sort((b, a) {
                                                sort = false;
                                                return a.notiDate
                                                    .toString()
                                                    .toLowerCase()
                                                    .compareTo(b.notiDate
                                                    .toString()
                                                    .toLowerCase());
                                              });
                                            }
                                            setState(() {});
                                          },
                                        )))
                            ),
                            Container(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: notiList.length,
                                itemBuilder: (context, index) {
                                  return notiCard(context, notiList[index]);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      // Chat part
                      conversationCardList.length ==0?
                      Padding(
                          padding: EdgeInsets.all(25),
                          child: Text(
                            'You have no chat available...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 15,

                            ),)
                      ):
                      SingleChildScrollView(
                        child: Column(children: [
                          SizedBox(height:20),
                          Container(
                              child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            // TODO: update here for populating a list of conversations
                            itemCount: conversationCardList.length,
                            itemBuilder: (context, index) {
                              return chatCard(
                                  context,
                                  conversationCardList[
                                      index]); // pass in dummy Conversation instance
                            },
                          ))
                        ]),
                      ),
                      // ChatPage(),
                    ],
                  ),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

Widget notiCard(BuildContext context, Notifications noti) {
  return Container(
    child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        child: Card(
            margin: EdgeInsets.fromLTRB(5, 2, 2, 5),
            child: GestureDetector(
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  title: Text('Update of report'),
                  subtitle: Text(noti.notificationText.trim()),
                  isThreeLine: false,
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                onTap: () async {
                  // Load other listing details
                  var notification = await ActivityPresenter()
                      .readNotification(noti.notificationID);

                  // Call listing to display
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NotificationPage(noti: notification)));
                }))),
  );
}

Widget chatCard(BuildContext context, ConversationCard cc) {
  return Container(
    child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        child: Card(
            margin: EdgeInsets.fromLTRB(5, 2, 2, 5),
            child: GestureDetector(
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(cc.listing_img),
                  ),
                  title: Text(cc.listing_title),
                  subtitle: Text('@${cc.partner_username}'),
                  isThreeLine: false,
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                onTap: () async {
                  //TODO: update on tapped action for chat row, dk if async is needed here
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivateChatScreen(
                            conversation_id: cc.conversation_id,
                          )));
                  print('Chat tapped, conversation ID: ${cc.conversation_id}');
                }))),
  );
}
