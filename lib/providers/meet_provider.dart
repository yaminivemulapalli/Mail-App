import 'package:flutter/material.dart';
import 'meetservice.dart';
class MeetProvider extends ChangeNotifier {
  String _selectedMeet = "All Calls";
  List<Meet> _currentMeets = [];

  String get selectedMeet => _selectedMeet;
  List<Meet> get currentMeets => _currentMeets;

  final MeetService _meetService = MeetService();

  void updateMeetFilter(String filter) {
    _selectedMeet = filter;
    switch (filter) {
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
    notifyListeners();
  }
}
