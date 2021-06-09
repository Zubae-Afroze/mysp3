import 'package:i18n_extension/i18n_widget.dart';
import 'package:intl/intl.dart';

class Meeting {
  int id;
  String meetingID;
  String meetingTitle;
  String banner;
  String created_at;
  bool isPublic;

  Meeting();

  factory Meeting.fromJSON(dynamic json) {
    final meeting = Meeting();
    meeting.id = json["id"];
    meeting.meetingID = json["meeting_id"];
    meeting.meetingTitle = json["meeting_title"];
    meeting.banner = json["banner"];
    meeting.isPublic = json["public"] == 1;
    meeting.created_at = json["created_at"];
    return meeting;
  }

  String get meetingDate {
    final formattedDateTime = DateTime.parse(this.created_at);
    final dateClean = DateFormat("dd MMM, yyy \| hh:mm a", I18n.language)
        .format(formattedDateTime);
    return dateClean.toString();
  }
}
