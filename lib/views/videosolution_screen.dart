import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoSolutionScreen extends StatefulWidget {
  const VideoSolutionScreen({Key? key}) : super(key: key);

  @override
  _VideoSolutionScreenState createState() => _VideoSolutionScreenState();
}

class _VideoSolutionScreenState extends State<VideoSolutionScreen> {
  YoutubePlayerController? _controller;
  String? youtubeID;

  @override
  void initState() {
    youtubeID = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_youtube")['youtubeID'];

    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: youtubeID!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller!,
      showVideoProgressIndicator: true,
      // videoProgressIndicatorColor: Colors.amber,
      // progressColors: ProgressColors(
      //   playedColor: Colors.amber,
      //   handleColor: Colors.amberAccent,
      // ),
      onReady: () {
        print('Player is ready.');
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}
