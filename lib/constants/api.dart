// import 'package:velocity_x/velocity_x.dart';

class Api {
  static String get baseUrl {
    return "https://meet.mysp3.life/api";
  }

  static String get webUrl {
    return "https://meet.mysp3.life/";
  }

  static const login = "/login";
  static const register = "/register";
  static const logout = "/logout";
  static const forgotPassword = "/password/reset/init";
  static const updateProfile = "/profile/update";
  static const deleteProfile = "/profile/delete";

  //
  static const meetings = "/meetings";
  static const joinMeeting = "/meetings/join";
  static const publicMeetings = "/public/meetings";
  static String get privacyPolicy {
    final webUrl = baseUrl.replaceAll('/api', '');
    return "$webUrl";
  }

  //
  static String settings = "/app/settings";
}
