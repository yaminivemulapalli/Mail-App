import 'package:flutter/material.dart';
import '../Services/mailservice.dart';
class MailProvider extends ChangeNotifier {
  String _selectedMail = "All Mail";
  List<Mail> _currentMails = [];

  String get selectedMail => _selectedMail;
  List<Mail> get currentMails => _currentMails;

  final MailService _mailService = MailService();

  void updateMailFilter(String filter) {
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
    notifyListeners();
  }
}
