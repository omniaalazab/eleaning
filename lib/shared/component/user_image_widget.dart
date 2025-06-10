import 'package:eleaning/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:eleaning/features/profile/presentation/cubit/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserImageWidget extends StatefulWidget {
  final String userId;
  final double radius;

  const UserImageWidget({
    super.key,
    required this.userId,
    this.radius = 40, // Default radius
  });

  @override
  State<UserImageWidget> createState() => _UserImageWidgetState();
}

class _UserImageWidgetState extends State<UserImageWidget> {
  @override
  void initState() {
    super.initState();
    // Fetch the profile image when the widget initializes
    context.read<ProfileCubit>().fetchProfileImage(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is LoadingProfileState) {
          return CircleAvatar(
            radius: widget.radius,
            child: CircularProgressIndicator(),
          );
        } else if (state is SucessProfileState) {
          // Use the MemoryImage from the ProfileCubit
          return CircleAvatar(
            radius: widget.radius,
            backgroundImage: state.imageProvider,
          );
        } else {
          // Fallback to a placeholder if there's no image or an error
          return CircleAvatar(
            radius: widget.radius,
            child: Icon(Icons.person, size: widget.radius),
          );
        }
      },
    );
  }
}
