import 'package:eleaning/core/constants/constant_text.dart';
import 'package:eleaning/core/helper/color_helper.dart';
import 'package:eleaning/core/helper/text_style_helper.dart';
import 'package:eleaning/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:eleaning/shared/component/user_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserInfoRow extends StatefulWidget {
  const UserInfoRow({
    super.key,
    required this.userName,
    required this.userImagePath,
  });

  final String userName;
  final String userImagePath;

  @override
  State<UserInfoRow> createState() => _UserInfoRowState();
}

class _UserInfoRowState extends State<UserInfoRow> {
  late final String? userEmail;
  @override
  void initState() {
    userEmail = context.read<ProfileCubit>().getCurrentUserEmail();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get the user email from the current user in ProfileCubit

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${ConstantText.hello}, ${widget.userName}",
              style: TextStyleHelper.textStylefontSize22,
            ),
            Text(
              ConstantText.welcomeMessage,
              textAlign: TextAlign.start,
              style: TextStyleHelper.textStylefontSize16.copyWith(
                color: ColorHelper.grey,
              ),
            ),
          ],
        ),
        // Use the new UserImageWidget instead of directly using Image.network
        userEmail != null
            ? UserImageWidget(userId: userEmail ?? "", radius: 40)
            : CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
      ],
    );
  }
}
