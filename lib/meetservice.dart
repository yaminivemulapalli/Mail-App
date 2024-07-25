class Meet {
  String dialer;
  bool missed;
  bool rejected;

  Meet({
    required this.dialer,
    this.missed = false,
    this.rejected = false,
  });
}

class MeetService {
  List<Meet> meets = [];

  MeetService() {
    meets = [
      Meet(dialer: "Fitpaa", missed: true),
      Meet(dialer: "TechCorp", rejected: true),
      Meet(dialer: "VRSEC"),
    ];
  }
  List<Meet> getAllcalls() {
    return meets;
  }

  List<Meet> getMissedMeet() {
    return meets.where((meet) => meet.missed).toList();
  }

  List<Meet> getRejectedMeet() {
    return meets.where((meet) => meet.rejected).toList();
  }
}
