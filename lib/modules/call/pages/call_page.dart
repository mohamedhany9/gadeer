import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/data/request/consulting/end_consulting.request.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/call/service/call.service.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

bool inCall = false;

class CallPage extends StatefulWidget {
  final Map<String, dynamic> arguments;
  CallPage(this.arguments);
  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  Map<String, dynamic>? parameters;

  AccountType? type;
  bool _joined = false;
  bool? video;
  int? _remoteUid;
  bool _switch = true;
  RtcEngine? engine;
  bool? videoEnabled;
  bool? remoteVideoEnabled;
  bool voiceEnabled = true;
  bool enableSpeaker = true;
  late Timer timer;
  late DateTime begin;
  Duration callDuration = Duration(seconds: 1);

  @override
  void initState() {
    inCall = true;
    if (Get.find<AccountBloc>().state.user != null) {
      type = Get.find<AccountBloc>().state.accountType;
    } else {
      type = AccountType.consultant;
    }
    parameters = widget.arguments;
    print(parameters);
    begin = DateTime.now();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      callDuration = DateTime.now().difference(begin);
      setState(() {});
    });

    if (parameters?["video"] != null) {
      video = parameters?["video"] == "0" ? false : true;
    } else {
      video = false;
    }

    videoEnabled = video;
    remoteVideoEnabled = video;
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _mainView(),
            _actionsRow(),
            _subView(),
            _timerView(),
          ],
        ),
      ),
    );
  }

  Widget _renderLocalPreview() {
    if (_joined) {
      if (videoEnabled!) {
        return RtcLocalView.SurfaceView();
      } else {
        return Center(
            child: Container(
          height: 200,
          decoration: BoxDecoration(
            shape: !_switch ? BoxShape.circle : BoxShape.rectangle,
            image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: CachedNetworkImageProvider(
                  type == AccountType.consultant
                      ? parameters!["consultant_photo"]
                      : parameters!["association_photo"],
                )),
          ),
        ));
      }
    } else {
      return Text(
        'برجاء الانضمام للقناة',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _renderRemoteVideo() {
    if (_remoteUid != null) {
      return (remoteVideoEnabled == true)
          ? RtcRemoteView.SurfaceView(
              uid: _remoteUid!,
            )
          : Center(
              child: Container(
              height: 200,
              decoration: BoxDecoration(
                shape: _switch ? BoxShape.circle : BoxShape.rectangle,
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: CachedNetworkImageProvider(
                      type == AccountType.association
                          ? parameters!["consultant_photo"]
                          : parameters!["association_photo"],
                    )),
              ),
            ));
    } else {
      return Center(
        child: Text(
          'برجاء انتظار الرد من المستخدم',
          style: TextStyles.subTitle.copyWith(color: Colors.black),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  @override
  void dispose() {
    timer.cancel();
    inCall = false;
    if (engine != null) {
      engine!.leaveChannel();

      engine!.destroy();
    }

    super.dispose();
  }

  _mainView() {
    return Center(
        child: Container(
      child: _switch ? _renderRemoteVideo() : _renderLocalPreview(),
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          repeat: ImageRepeat.repeat,
          image: AssetImage(
            Constants.background1,
          ),
        ),
      ),
    ));
  }

  _actionsRow() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 80,
        margin: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        width: Get.width,
        child: Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: InkWell(
                  child: Icon(
                    !enableSpeaker ? Icons.speaker_phone : Icons.volume_down,
                    size: 40,
                    color: AppColors.primary,
                  ),
                  onTap: () {
                    if (enableSpeaker) {
                      engine!.setEnableSpeakerphone(false);

                      enableSpeaker = false;
                    } else {
                      engine!.setEnableSpeakerphone(true);
                      enableSpeaker = true;
                    }
                    setState(() {});
                  }),
            ),
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: InkWell(
                  child: Icon(
                    voiceEnabled ? Icons.mic : Icons.mic_off,
                    size: 40,
                    color: !voiceEnabled ? Colors.red : AppColors.primary,
                  ),
                  onTap: () {
                    if (voiceEnabled) {
                      engine!.muteLocalAudioStream(true);

                      voiceEnabled = false;
                    } else {
                      engine!.muteLocalAudioStream(false);
                      voiceEnabled = true;
                    }
                    setState(() {});
                  }),
            ),
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: InkWell(
                  child: Icon(
                    videoEnabled!
                        ? Icons.video_call
                        : Icons.video_call_outlined,
                    size: 40,
                    color: !videoEnabled! ? Colors.red : AppColors.primary,
                  ),
                  onTap: () {
                    if (videoEnabled!) {
                      engine!.muteLocalVideoStream(true);
                      videoEnabled = false;
                    } else {
                      engine!.muteLocalVideoStream(false);
                      engine!.setEnableSpeakerphone(true);
                      enableSpeaker = true;
                      videoEnabled = true;
                    }
                    setState(() {});
                  }),
            ),
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: InkWell(
                  child: Icon(
                    Icons.switch_camera,
                    color: AppColors.primary,
                    size: 40,
                  ),
                  onTap: () async {
                    engine?.switchCamera();
                  }),
            ),
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: InkWell(
                  child: Icon(
                    Icons.call_end_rounded,
                    color: Colors.red,
                    size: 40,
                  ),
                  onTap: () async {
                    Get.back();
                  }),
            )
          ],
        ),
      ),
    );
  }

  _subView() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0),
        width: 150,
        decoration: BoxDecoration(
          // color: Colors.white,
          image: DecorationImage(
            repeat: ImageRepeat.repeat,
            image: AssetImage(
              Constants.background1,
            ),
          ),
        ),
        height: 200,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _switch = !_switch;
            });
          },
          child: _switch ? _renderLocalPreview() : _renderRemoteVideo(),
        ),
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

  Future<void> initPlatformState() async {
    await [Permission.camera, Permission.microphone, Permission.storage]
        .request();

    engine = await RtcEngine.create("3cacaabf83184f6c9c0e43570578a7e1");

    engine!.setEventHandler(
        RtcEngineEventHandler(remoteVideoStateChanged: (id, state, _, __) {
      remoteVideoEnabled = state == VideoRemoteState.Decoding;
      setState(() {});
    }, error: (e) {
      Notifications.error(e.toString());
    }, leaveChannel: (s) {
      Notifications.success('تم انهاء المكالمة');
      endConsulting();
    }, joinChannelSuccess: (String channel, int uid, int elapsed) {
      setState(() {
        _joined = true;
      });
    }, userJoined: (int uid, int elapsed) {
      Notifications.success('تم الرد علي المكالمة');

      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      Notifications.success('تم انهاء المكالمة');
      endConsulting();
      setState(() {
        _remoteUid = null;
      });
    }));
    await engine!.enableAudio();
    await engine!.enableVideo();

    if (video!) {
      await engine!.setEnableSpeakerphone(true);
      await engine?.muteLocalVideoStream(false);
      enableSpeaker = true;
    } else {
      enableSpeaker = false;
      await engine?.muteLocalVideoStream(true);
    }
    setState(() {});

    await engine?.joinChannel(null, parameters?["id"], null, 0);
  }

  Future endConsulting() async {
    Get.back();

    if (type == AccountType.consultant) {
      return;
    }
    await Get.find<CallService>()
        .endConsulting(int.parse(parameters!["id"]),
            EndConsultingRequest(callDuration.inSeconds))
        .then((value) {
      if (value.status == 1) {
      } else {
        Notifications.error(value.message ?? "");
      }
    }).catchError((e) {
      print(e.toString());
      Notifications.error(Constants.netError);
    });
  }
}
