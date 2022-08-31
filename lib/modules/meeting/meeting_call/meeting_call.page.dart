import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/app/bloc/app.bloc.dart';
import 'package:gadeer/modules/meeting/service/meeting_service.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:permission_handler/permission_handler.dart';

class MeetingCallPage extends StatefulWidget {
  final MeetingModel? meetingModel;
  MeetingCallPage(this.meetingModel);
  @override
  _MeetingCallPageState createState() => _MeetingCallPageState();
}

class _MeetingCallPageState extends State<MeetingCallPage> {
  List<UserStatus> _users = [];
  final _infoStrings = <String>[];
  bool muted = false;
  late RtcEngine _engine;
  bool videoEnabled = false;
  late Timer timer;
  late DateTime begin;
  Duration callDuration = Duration(seconds: 1);

  @override
  void dispose() {
    timer.cancel();

    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    if (widget.meetingModel?.userId == Get.find<AccountBloc>().state.user?.id) {
      Get.find<MeetingService>().endMeeting(widget.meetingModel?.id,
          callDuration.inSeconds, videoEnabled ? "video" : "voice");
      Get.find<FirebaseAnalytics>().logEvent(name: "end_meeting", parameters: {
        "duration": callDuration.inSeconds.toString(),
        "type": videoEnabled ? "video" : "voice",
      });
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //timer work

    begin = DateTime.now();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      callDuration = DateTime.now().difference(begin);
      setState(() {});
    });
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    await _initAgoraRtcEngine();

    _addAgoraEventHandlers();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(width: 640, height: 480);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(
        null, "${widget.meetingModel?.id}_meeting", null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create("3cacaabf83184f6c9c0e43570578a7e1");
    await [Permission.camera, Permission.microphone, Permission.storage]
        .request();
    await _engine.setChannelProfile(ChannelProfile.Communication);
    await _engine.enableVideo();
    await _engine.enableLocalVideo(videoEnabled);
    _engine.muteLocalVideoStream(!videoEnabled);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
        remoteVideoStateChanged: (id, state, _, __) {
          int index = _users.indexWhere((element) => element.id == id);
          _users[index] = UserStatus(id, state == VideoRemoteState.Decoding);
          setState(() {});
        },
        error: (code) {
          setState(() {
            final info = 'onError: $code';
            _infoStrings.add(info);
          });
        },
        joinChannelSuccess: (channel, uid, elapsed) {
          setState(() {
            final info = 'onJoinChannel: $channel, uid: $uid';
            _infoStrings.add(info);
          });
        },
        leaveChannel: (stats) {},
        userJoined: (uid, elapsed) {
          Get.find<FirebaseAnalytics>()
              .logEvent(name: "join_meeting", parameters: {
            "meeting_id": widget.meetingModel?.id.toString(),
            "current_user_count": _users.length.toString()
          });
          setState(() {
            final info = 'userJoined: $uid';
            _infoStrings.add(info);
            _users.add(UserStatus(uid, false));
          });
        },
        userOffline: (uid, elapsed) {
          setState(() {
            final info = 'userOffline: $uid';
            _infoStrings.add(info);
            _users.removeWhere((element) => element.id == uid);
          });
        },
        firstRemoteVideoFrame: (uid, width, height, elapsed) {
          setState(() {
            final info = 'firstRemoteVideo: $uid ${width}x $height';
            _infoStrings.add(info);
          });
        }));
  }

  /// Helper function to get list of native views
  List<ViewWRapper> _getRenderViews() {
    final List<ViewWRapper> list = [];

    list.add(ViewWRapper(
        userStatus: UserStatus(-1, videoEnabled),
        child: RtcLocalView.SurfaceView()));

    _users.forEach((UserStatus status) => list.add(ViewWRapper(
        userStatus: status,
        child: RtcRemoteView.SurfaceView(
          channelId: "",
          uid: status.id,
        ))));

    return list;
  }

  /// Video view wrapper
  Widget _videoView(ViewWRapper view) {
    return Expanded(child: LayoutBuilder(builder: (context, cons) {
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              repeat: ImageRepeat.repeat,
              image: AssetImage(
                Constants.background1,
              ),
            ),
          ),
          child: view.userStatus.videoOpened
              ? view
              : Center(
                  child: Image.asset(
                    Constants.logoFull,
                    height: cons.maxHeight / 2,
                    width: cons.maxHeight / 2,
                  ),
                ));
    }));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<ViewWRapper> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();

    // ignore: division_optimization
    int rows = (views.length / 2).toInt();
    if (views.length.isOdd) {
      rows += 1;
    }

    switch (views.length) {
      case 1:
        return Container(
            color: Colors.grey.shade300,
            child: Column(
              children: <Widget>[_videoView(views[0])],
            ));
      case 2:
        return Container(
            color: Colors.grey.shade300,
            child: Column(
              children: <Widget>[
                _expandedVideoRow([views[0]]),
                _expandedVideoRow([views[1]])
              ],
            ));

      default:
        return Container(
          color: Colors.grey.shade300,
          child: Column(
            children: [
              ...List<Widget>.generate(rows, (index) {
                int addedValue = 2;
                if (index == rows - 1) {
                  if (views.length.isOdd) {
                    addedValue = 1;
                  }
                }
                return _expandedVideoRow(
                    views.sublist(index * 2, index * 2 + addedValue));
              }).toList()
            ],
          ),
        );
    }
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            onTap: () => _onCallEnd(),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.call_end,
                color: Colors.red,
                size: 40.0,
              ),
            ),
          ),
          InkWell(
            onTap: _onToggleMute,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Icon(
                muted ? Icons.mic_off : Icons.mic,
                color: AppColors.primary,
                size: 40.0,
              ),
            ),
          ),
          InkWell(
            onTap: _onVideoChanged,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Icon(
                videoEnabled ? Icons.videocam : Icons.videocam_off,
                color: AppColors.primary,
                size: 40.0,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _engine.switchCamera();
            },
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.switch_camera,
                color: AppColors.primary,
                size: 40.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  _timerView() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 60),
        child: Container(
          child: Text(
            "${(callDuration.inSeconds - callDuration.inMinutes * 60).toInt().toString()} : ${callDuration.inMinutes < 10 ? "0" : ""}${callDuration.inMinutes}",
            style: TextStyles.subTitle.copyWith(color: Colors.black),
          ),
        ),
      ),
    );
  }

  void _onCallEnd() {
    Get.back();
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onVideoChanged() {
    videoEnabled = !videoEnabled;
    _engine.enableLocalVideo(videoEnabled);
    _engine.muteLocalVideoStream(!videoEnabled);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            _toolbar(),
            _timerView(),
          ],
        ),
      ),
    );
  }
}

class UserStatus {
  int id;
  bool videoOpened;
  UserStatus(this.id, this.videoOpened);
}

class ViewWRapper extends StatelessWidget {
  const ViewWRapper({Key? key, required this.userStatus, required this.child})
      : super(key: key);
  final UserStatus userStatus;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
    );
  }
}
