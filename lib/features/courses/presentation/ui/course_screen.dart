import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/core/helper/text_style_helper.dart';
import 'package:eleaning/features/courses/data/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key, required this.courseModel});
  final CourseModel courseModel;

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late YoutubePlayerController _youtubeController;
  int _currentVideoIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeYoutubePlayer();
  }

  void _initializeYoutubePlayer() {
    final videoId = YoutubePlayer.convertUrlToId(
      widget.courseModel.videos[_currentVideoIndex].youtubeUrl,
    );
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  void _loadVideo(int index) {
    final videoId = YoutubePlayer.convertUrlToId(
      widget.courseModel.videos[index].youtubeUrl,
    );
    if (videoId != null) {
      _youtubeController.load(videoId);
      setState(() {
        _currentVideoIndex = index;
      });
    }
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.white,
      appBar: AppBar(
        title: Text(widget.courseModel.title),
        backgroundColor: ColorHelper.red,
        foregroundColor: ColorHelper.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubePlayer(
            controller: _youtubeController,
            showVideoProgressIndicator: true,
            progressIndicatorColor: ColorHelper.red,
          ),
          if (widget.courseModel.videos.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.courseModel.videos[_currentVideoIndex].title,
                    style: TextStyleHelper.textStylefontSize14.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.courseModel.description,
                    style: TextStyleHelper.textStylefontSize14,
                  ),
                ],
              ),
            ),
          Divider(height: 2.h, thickness: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Text(
              "Course Videos",
              style: TextStyleHelper.textStylefontSize14.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.courseModel.videos.length,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemBuilder: (context, index) {
                final video = widget.courseModel.videos[index];
                final isCurrentVideo = index == _currentVideoIndex;

                return Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  decoration: BoxDecoration(
                    color:
                        isCurrentVideo
                            ? ColorHelper.red.withOpacity(0.1)
                            : ColorHelper.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isCurrentVideo
                              ? ColorHelper.red
                              : ColorHelper.greyLight,
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 0.5.h,
                    ),
                    title: Text(
                      video.title,
                      style: TextStyleHelper.textStylefontSize14.copyWith(
                        fontWeight:
                            isCurrentVideo
                                ? FontWeight.bold
                                : FontWeight.normal,
                        color:
                            isCurrentVideo
                                ? ColorHelper.red
                                : ColorHelper.black,
                      ),
                    ),
                    leading: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color:
                            isCurrentVideo
                                ? ColorHelper.red
                                : ColorHelper.greyLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isCurrentVideo
                            ? Icons.play_arrow
                            : Icons.play_circle_outline,
                        color:
                            isCurrentVideo
                                ? ColorHelper.white
                                : ColorHelper.black,
                        size: 6.w,
                      ),
                    ),
                    onTap: () {
                      if (!isCurrentVideo) {
                        _loadVideo(index);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
