import 'package:flutter/material.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:meetup/models/meeting.dart';
import 'package:meetup/models/user.dart';
import 'package:meetup/requests/meeting.request.dart';
import 'package:meetup/services/auth.service.dart';
import 'package:meetup/view_models/base.view_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:meetup/translations/dialogs.i18n.dart';

class LoungeViewModel extends MyBaseViewModel {
  //
  MeetingRequest _meetingRequest = MeetingRequest();
  User currentUser;

  //
  int queryPage = 1;
  List<Meeting> publicMeetings = [];
  RefreshController refreshController = RefreshController();

  //
  LoungeViewModel(BuildContext context) {
    this.viewContext = context;
  }

  void initialise() async {
    //
    if (AuthServices.authenticated()) {
      currentUser = await AuthServices.getCurrentUser(force: true);
      notifyListeners();
    }

    //
    getPublicMeetings();
  }

  /**
   * Meeting creating and joining
   */

  //initiate the vidoe call
  initiateNewMeeting({Meeting meeting}) async {
    try {
      FeatureFlag featureFlag = FeatureFlag();
      featureFlag.welcomePageEnabled = false;
      // Limit video resolution to 360p
      featureFlag.resolution = FeatureFlagVideoResolution.MD_RESOLUTION;
      featureFlag.chatEnabled = true;

      var options = JitsiMeetingOptions()
        ..room = meeting.meetingID // Required, spaces will be trimmed
        ..subject = meeting.meetingTitle
        ..userDisplayName = currentUser?.name
        ..userAvatarURL = currentUser?.photo
        ..audioOnly = true
        ..audioMuted = true
        ..videoMuted = true
        ..featureFlag = featureFlag;

      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      viewContext.showToast(
        msg: "There was an error joining new meeting".i18n,
      );
    }
  }

  /**
   * 
   */
  void getPublicMeetings({bool initial = true}) async {
    //
    initial ? queryPage = 1 : queryPage++;
    //
    if (initial) {
      setBusyForObject(publicMeetings, true);
      refreshController.refreshCompleted();
    }
    //
    final mMeetings =
        await _meetingRequest.publicMeetingsRequest(page: queryPage);
    if (initial) {
      publicMeetings = mMeetings;
    } else {
      publicMeetings.addAll(mMeetings);
    }

    //
    initial
        ? setBusyForObject(publicMeetings, false)
        : refreshController.loadComplete();
  }
}
