import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'statemanage.dart';

class MyDrawer extends StatelessWidget {
  final ValueSetter<String> onFilterSelect;
  final ValueSetter<String> onMeetFilterselect;

  const MyDrawer({
    Key? key,
    required this.onFilterSelect,
    required this.onMeetFilterselect, required MyView view,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewState = Provider.of<ViewStateManage>(context);
    final MyView currentView = viewState.view;

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
            onFilterSelect('All Mail');
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Spam'),
          onTap: () {
            onFilterSelect('Spam');
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Unread Mail'),
          onTap: () {
            onFilterSelect('Unread Mail');
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Deleted Mail'),
          onTap: () {
            onFilterSelect('Deleted Mail');
            Navigator.pop(context);
          },
        ),
      ]);
    } else if (currentView == MyView.meet) {
      drawerItems.addAll([
        ListTile(
          title: Text('All Calls'),
          onTap: () {
            onMeetFilterselect('All Calls');
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Rejected Calls'),
          onTap: () {
            onMeetFilterselect('Rejected Calls');
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Missed Calls'),
          onTap: () {
            onMeetFilterselect('Missed Calls');
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
