import 'package:flutter/material.dart';

enum MyView { mail, meet }

class ViewStateManage extends ChangeNotifier {
  MyView _view = MyView.mail;
  final PageController _pageController = PageController(initialPage: 0);

  MyView get view => _view;
  PageController get pageController => _pageController;

  void updateView(MyView view) {
    _view = view;
    _pageController.jumpToPage(view == MyView.mail ? 0 : 1);
    notifyListeners();
  }

  String getAppTitle() {
    switch (_view) {
      case MyView.mail:
        return 'Mail';
      case MyView.meet:
        return 'Meet';
      default:
        return 'default';
    }
  }
}
