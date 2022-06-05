import 'dart:io';

import 'package:flutter/material.dart';

import '../../global/enviroments.dart';
import 'meeting_action_button.dart';

// Meeting ActionBar
class MeetingActionBar extends StatelessWidget {
  // control states
  final bool isMicEnabled,
      isWebcamEnabled,
      isScreenShareEnabled,
      isScreenShareButtonDisabled;

  // callback functions
  final void Function() onCallEndButtonPressed,
      onMicButtonPressed,
      onWebcamButtonPressed,
      onSwitchCameraButtonPressed,
      onScreenShareButtonPressed;

  const MeetingActionBar({
    Key? key,
    required this.isMicEnabled,
    required this.isWebcamEnabled,
    required this.isScreenShareEnabled,
    required this.isScreenShareButtonDisabled,
    required this.onCallEndButtonPressed,
    required this.onMicButtonPressed,
    required this.onWebcamButtonPressed,
    required this.onSwitchCameraButtonPressed,
    required this.onScreenShareButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Theme.of(context).backgroundColor,
      child: Row(
        children: [
          // Call End Control
          Expanded(
            child: MeetingActionButton(
              backgroundColor: Colors.red,
              onPressed: onCallEndButtonPressed,
              icon: Icons.call_end,
            ),
          ),

          // Mic Control
          Expanded(
            child: MeetingActionButton(
              onPressed: onMicButtonPressed,
              backgroundColor:
                  isMicEnabled ? Enviroments.hoverColor :Enviroments.hoverColor,
              icon: isMicEnabled ? Icons.mic : Icons.mic_off,
            ),
          ),

          // Webcam Control
          Expanded(
            child: MeetingActionButton(
              onPressed: onWebcamButtonPressed,
              backgroundColor: isWebcamEnabled
                  ? Enviroments.hoverColor :Enviroments.hoverColor,
              icon: isWebcamEnabled ? Icons.videocam : Icons.videocam_off,
            ),
          ),

          // Webcam Switch Control
          Expanded(
            child: MeetingActionButton(
              backgroundColor: Enviroments.secondaryColor,
              onPressed: isWebcamEnabled ? onSwitchCameraButtonPressed : null,
              icon: Icons.cameraswitch,
            ),
          ),

          // // ScreenShare Control
          // if (Platform.isAndroid)
          //   Expanded(
          //     child: MeetingActionButton(
          //       backgroundColor: isScreenShareEnabled
          //           ?Enviroments.hoverColor :Enviroments.hoverColor,
          //       onPressed: isScreenShareButtonDisabled
          //           ? null
          //           : onScreenShareButtonPressed,
          //       icon: isScreenShareEnabled
          //           ? Icons.screen_share
          //           : Icons.stop_screen_share,
          //       iconColor:
          //           isScreenShareButtonDisabled ? Colors.white30 : Colors.white,
          //     ),
          //   ),

          // More options
         
          
        ],
      ),
    );
  }
}
