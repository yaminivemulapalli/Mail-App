class Mail {
  String sender;
  List<String> content;
  bool unread;
  bool spam;
  bool deletedmail;

  Mail({
    required this.sender,
    required this.content,
    this.unread = true,
    this.spam = false,
    this.deletedmail = false,
  });
}

class MailService {
  List<Mail> mails = [];

  MailService() {
    mails = [
      Mail(
        sender: "Google",
        content:[
            "We noticed a new sign-in to your Google Account on a Windows device.",
            "If this was you, you don’t need to do anything. If not, we’ll help you secure your account."],
        spam: true,
      ),
      Mail(
        sender: "Figma",
        content: ["Updates about the AI teams"],
        unread: false,
      ),
      Mail(
        sender: "BookMyshow",
        content: ["Book your tickets at half price"],
        spam: true,
      ),
      Mail(
        sender: "Amazon wow",
        content:
            ["Hi yamini Vemulapalli , Join our free session on SDE and join your hands in the beautiful journey  of the amazon lets grow together and make the world a better place"],
        deletedmail: true,
      ),
    ];
  }

  List<Mail> getAllMail() {
    return mails;
  }

  List<Mail> getSpamMail() {
    return mails.where((mail) => mail.spam).toList();
  }

  List<Mail> getUnreadMail() {
    return mails.where((mail) => mail.unread).toList();
  }

  List<Mail> getDeletedMail() {
    return mails.where((mail) => mail.deletedmail).toList();
  }
}
