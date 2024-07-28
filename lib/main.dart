import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/mail_provider.dart';
import 'providers/meet_provider.dart';
import 'maildrawer.dart';
import 'emaildetailscreen.dart';
import 'statemanage.dart';
import 'Services/mailservice.dart';
import 'Services/meetservice.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ViewStateManage()),
        ChangeNotifierProvider(create: (context) => MailProvider()),
        ChangeNotifierProvider(create: (context) => MeetProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewState = Provider.of<ViewStateManage>(context);

    return Scaffold(
      appBar: MyAppBar(
        title: viewState.getAppTitle(),
        subtitle: getSubtitle(viewState.view, context),
      ),
      drawer: MyDrawer(
        onFilterSelect: (filter) =>
            Provider.of<MailProvider>(context, listen: false)
                .updateMailFilter(filter),
        onMeetFilterselect: (filter) =>
            Provider.of<MeetProvider>(context, listen: false)
                .updateMeetFilter(filter),
        view: viewState.view,
      ),
      body: HomePage(
        pageController: viewState.pageController,
      ),
      bottomNavigationBar: BottomNavBar(
        onViewChange: viewState.updateView,
        currentView: viewState.view,
      ),
      floatingActionButton: const MyFloatingActionButton(),
    );
  }

  String getSubtitle(MyView view, BuildContext context) {
    if (view == MyView.mail) {
      return Provider.of<MailProvider>(context).selectedMail;
    } else {
      return Provider.of<MeetProvider>(context).selectedMeet;
    }
  }
}

class HomePage extends StatelessWidget {
  final PageController pageController;

  const HomePage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    final mailProvider = Provider.of<MailProvider>(context);
    final meetProvider = Provider.of<MeetProvider>(context);

    return PageView(
      controller: pageController,
      children: <Widget>[
        MailView(mails: mailProvider.currentMails),
        MeetView(meets: meetProvider.currentMeets),
      ],
    );
  }
}

class MyFloatingActionButton extends StatelessWidget {
  const MyFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.edit),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final ValueSetter<MyView> onViewChange;
  final MyView currentView;

  const BottomNavBar({
    super.key,
    required this.onViewChange,
    required this.currentView,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: getCurrentViewIndex(),
      onTap: (int index) {
        if (index == 0) {
          onViewChange(MyView.mail);
        } else if (index == 1) {
          onViewChange(MyView.meet);
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Mail',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_call),
          label: 'Meet',
        ),
      ],
    );
  }

  int getCurrentViewIndex() {
    if (currentView == MyView.mail) {
      return 0;
    } else if (currentView == MyView.meet) {
      return 1;
    } else {
      return 0;
    }
  }
}

class MailView extends StatelessWidget {
  final List<Mail> mails;

  const MailView({Key? key, required this.mails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mails.length,
      itemBuilder: (context, index) {
        final mail = mails[index];

        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Emaildetailscreen(
                  sender: mail.sender,
                  content: mail.content[0],
                ),
              ),
            );
          },
          title: Text(
            mail.sender,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            mail.content[0],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 221, 247, 255),
            radius: 20,
            child: Text(
              mail.sender[0],
              style: TextStyle(fontSize: 26, color: Colors.white),
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '11:50 pm',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.star_border),
            ],
          ),
        );
      },
    );
  }
}

class MeetView extends StatelessWidget {
  final List<Meet> meets;

  const MeetView({super.key, required this.meets});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: meets.length,
      itemBuilder: (context, index) {
        final meet = meets[index];

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 177, 223, 239),
            radius: 20,
            child: Text(
              meet.dialer[0],
              style: TextStyle(fontSize: 26, color: Colors.white),
            ),
          ),
          title: Text(
            meet.dialer,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (meet.rejected)
                Icon(
                  Icons.call_end,
                  color: Colors.red,
                ),
              if (meet.missed)
                Icon(
                  Icons.call_missed,
                  color: Colors.orange,
                ),
              if (!meet.missed && !meet.rejected)
                Icon(
                  Icons.call,
                  color: Colors.green,
                ),
            ],
          ),
        );
      },
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;

  const MyAppBar({
    Key? key,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
        ],
      ),
      backgroundColor: Colors.blue,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
