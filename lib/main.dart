import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mailservice.dart';
import 'maildrawer.dart';
import 'meetservice.dart';
import 'emaildetailscreen.dart';
import 'statemanage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ViewStateManage(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final MailService _mailService = MailService();
  final MeetService _meetService = MeetService();
  String _selectedMail = "All Mail";
  String _selectedMeet = "All Calls";
  List<Mail> _currentMails = [];
  List<Meet> _currentMeets = [];

  @override
  void initState() {
    super.initState();
    _currentMails = _mailService.getAllMail();
    _currentMeets = _meetService.getAllcalls();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewState = Provider.of<ViewStateManage>(context);

    return Scaffold(
      appBar: MyAppBar(
        title: viewState.getAppTitle(),
        subtitle: getSubtitle(viewState.view),
      ),
      drawer: MyDrawer(
        onFilterSelect: filtered,
        onMeetFilterselect: meetFiltered,
        view: viewState.view,
      ),
      body: HomePage(
        pageController: viewState.pageController,
        mails: _currentMails,
        meets: _currentMeets,
      ),
      bottomNavigationBar: BottomNavBar(
        onViewChange: viewState.updateView,
        currentView: viewState.view,
      ),
      floatingActionButton: const MyFloatingActionButton(),
    );
  }

  String getSubtitle(MyView view) {
    if (view == MyView.mail) {
      return _selectedMail;
    } else {
      return _selectedMeet;
    }
  }

  void filtered(String filter) {
    setState(() {
      _selectedMail = filter;
      switch (filter) {
        case "All Mail":
          _currentMails = _mailService.getAllMail();
          break;
        case "Spam":
          _currentMails = _mailService.getSpamMail();
          break;
        case "Unread Mail":
          _currentMails = _mailService.getUnreadMail();
          break;
        case "Deleted Mail":
          _currentMails = _mailService.getDeletedMail();
          break;
      }
    });
  }

  void meetFiltered(String meetFilter) {
    setState(() {
      _selectedMeet = meetFilter;
      switch (meetFilter) {
        case "All Calls":
          _currentMeets = _meetService.getAllcalls();
          break;
        case "Rejected Calls":
          _currentMeets = _meetService.getRejectedMeet();
          break;
        case "Missed Calls":
          _currentMeets = _meetService.getMissedMeet();
          break;
      }
    });
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;

  MyAppBar({super.key, required this.title, required this.subtitle});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
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

class EmailDetailScreen extends StatelessWidget {
  final String sender;
  final String content;

  const EmailDetailScreen(
      {Key? key, required this.sender, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              sender,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(content, style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final PageController pageController;
  final List<Mail> mails;
  final List<Meet> meets;

  const HomePage(
      {super.key,
      required this.pageController,
      required this.mails,
      required this.meets});

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: <Widget>[
        MailView(mails: mails),
        MeetView(meets: meets),
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

  const BottomNavBar(
      {super.key, required this.onViewChange, required this.currentView});

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
