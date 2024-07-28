import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'statemanage.dart';
import 'providers/mail_provider.dart'; 
import 'meet_provider.dart'; 

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
    required this.onFilterSelect,
    required this.onMeetFilterselect, required MyView view,
  }) : super(key: key);

  final ValueSetter<String> onFilterSelect;
  final ValueSetter<String> onMeetFilterselect;

  @override
  Widget build(BuildContext context) {
    final viewState = Provider.of<ViewStateManage>(context);
    final mailProvider = Provider.of<MailProvider>(context);
    final meetProvider = Provider.of<MeetProvider>(context);
     MyView currentView = viewState.view;

    List<Widget> drawerItems = [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text(
          getTitle(currentView),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    ];

    if (currentView == MyView.mail) {
      drawerItems.addAll([
        ListTile(
          title: Text('All Mail'),
          onTap: () {
            mailProvider.updateMailFilter('All Mail');
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Spam'),
          onTap: () {
            mailProvider.updateMailFilter('Spam');
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Unread Mail'),
          onTap: () {
            mailProvider.updateMailFilter('Unread Mail');
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Deleted Mail'),
          onTap: () {
            mailProvider.updateMailFilter('Deleted Mail');
            Navigator.pop(context);
          },
        ),
      ]);
    } else if (currentView == MyView.meet) {
      drawerItems.addAll([
        ListTile(
          title: Text('All Calls'),
          onTap: () {
            meetProvider.updateMeetFilter('All Calls');
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Rejected Calls'),
          onTap: () {
            meetProvider.updateMeetFilter('Rejected Calls');
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Missed Calls'),
          onTap: () {
            meetProvider.updateMeetFilter('Missed Calls');
            Navigator.pop(context);
          },
        ),
      ]);
    }

    return Drawer(
      child: ListView(
        children: drawerItems,
      ),
    );
  }

  String getTitle(MyView view) {
    switch (view) {
      case MyView.mail:
        return 'Mail';
      case MyView.meet:
        return 'Meet';
      default:
        return 'Unknown';
    }
  }
}
