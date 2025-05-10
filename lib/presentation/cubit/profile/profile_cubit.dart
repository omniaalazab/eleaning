// import 'dart:developer';
// import 'dart:io';

// import 'package:appwrite/appwrite.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:eleaning/main.dart';
// import 'package:eleaning/presentation/cubit/profile/profile_state.dart';
// import 'package:eleaning/presentation/ui/widgets/common_widget/toast_dialog.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';

// class ProfileCubit extends Cubit<ProfileState> {
//   ProfileCubit() : super(InitialProfileState());
//     final ImagePicker picker = ImagePicker();
//   final storage = Storage(client); // Initialize the Storage service
//   String? _uploadedImageUrl;

//   Future<void> changeProfileImage(var context) async {
//     CreateDialogToaster.showErrorDialogDefult(
//       "Loading",
//       "Image Loading",
//       context,
//     );

//     try {
//       emit(LoadingProfileState());

//       final XFile? pickImage = await picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 80,
//       );

//       if (pickImage == null) {
//         emit(InitialProfileState());
//         Navigator.pop(context);
//         return;
//       }

//       File imageFile = File(pickImage.path);
//       String? userMail = FirebaseAuth.instance.currentUser?.email;

//       if (userMail == null) {
//         emit(FailureProfileState(error: "User not logged in"));
//         Navigator.pop(context);
//         return;
//       }

//       try {
//         log("Starting image upload to Appwrite for user: $userMail");

//         final String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";

//         // Create a file object for Appwrite
//         final InputFile inputFile = InputFile.fromBytes(
//           imageFile.readAsBytesSync(),
//           filename: fileName,
//         );

//         // Replace 'your_bucket_id' with your Appwrite storage bucket ID
//         final models.File uploadedFile = await storage.createFile(
//           bucketId: 'elearning_bucket_id1',
//           fileId: 'profile_$userMail', // Consider a more unique ID strategy
//           file: inputFile,
//         );

//         log("Image uploaded to Appwrite. File ID: ${uploadedFile.$id}");

//         // Get the URL of the uploaded file
//         final String imageUrl = storage.getFileView(
//           bucketId: 'elearning_bucket_id1',
//           fileId: uploadedFile.$id,
//         );
//         _uploadedImageUrl = imageUrl; // Store the URL

//         log("Appwrite image URL: $imageUrl");

//         // Update Firestore with the Appwrite image URL
//         DocumentReference userDocRef = FirebaseFirestore.instance
//             .collection('users')
//             .doc(userMail);

//         DocumentSnapshot userDoc = await userDocRef.get();

//         if (userDoc.exists) {
//           await userDocRef.update({"profileImage": imageUrl});
//           log("Updated existing user document with Appwrite URL");
//         } else {
//           await userDocRef.set({
//             "profileImage": imageUrl,
//             "email": userMail,
//             "createdAt": FieldValue.serverTimestamp(),
//           });
//           log("Created new user document with Appwrite URL");
//         }

//         emit(SucessProfileState(imageProvider: NetworkImage(imageUrl)));
//         Navigator.pop(context);
//         CreateDialogToaster.showErrorDialogDefult(
//           "Success",
//           "Profile image updated successfully",
//           context,
//         );
//       } catch (e) {
//         log("Appwrite storage error: $e");
//         emit(FailureProfileState(error: e.toString()));
//         Navigator.pop(context);
//         CreateDialogToaster.showErrorDialogDefult(
//           "Error",
//           "Failed to upload image to Appwrite: ${e.toString()}",
//           context,
//         );
//       }
//     } catch (e) {
//       log("Error in changeProfileImage: $e");
//       emit(FailureProfileState(error: e.toString()));
//       Navigator.pop(context);
//       CreateDialogToaster.showErrorDialogDefult(
//         "Error",
//         "An error occurred: ${e.toString()}",
//         context,
//       );
//     }
//   }

//   Future<void> fetchProfileImage(BuildContext context) async {
//     CreateDialogToaster.showErrorDialogDefult(
//       "Loading",
//       "Image Loading",
//       context,
//     );

//     try {
//       emit(LoadingProfileState());

//       String? userMail = FirebaseAuth.instance.currentUser?.email;

//       if (userMail == null) {
//         emit(FailureProfileState(error: "User not logged in"));
//         Navigator.pop(context);
//         return;
//       }

//       log("Fetching profile for user: $userMail");

//       DocumentSnapshot userDoc =
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(userMail)
//               .get();

//       if (userDoc.exists) {
//         Map<String, dynamic>? userData =
//             userDoc.data() as Map<String, dynamic>?;

//         if (userData != null && userData.containsKey('profileImage')) {
//           String imageUrl = userData['profileImage'] as String;

//           if (imageUrl.isNotEmpty) {
//             log("Found image URL: $imageUrl");
//             emit(SucessProfileState(imageProvider: NetworkImage(imageUrl)));
//           } else {
//             log("Image URL is empty");
//             emit(InitialProfileState());
//           }
//         } else {
//           log("No profile image found in user data");
//           emit(InitialProfileState());
//         }
//       } else {
//         log("User document doesn't exist");
//         emit(InitialProfileState());
//       }
//     }
//     // Add this state if it doesn't exist
//     catch (e) {
//       log(e.toString());
//       emit(FailureProfileState(error: e.toString()));
//     }
//     Navigator.pop(context);
//   }
// }
import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleaning/main.dart';
import 'package:eleaning/presentation/cubit/profile/profile_state.dart';
import 'package:eleaning/presentation/ui/widgets/common_widget/toast_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(InitialProfileState());
  final ImagePicker picker = ImagePicker();
  final Storage storage = Storage(
    client,
  ); // Initialize Storage service with client from main.dart
  String? _uploadedImageUrl;

  // Constants to avoid magic strings
  static const String BUCKET_ID = 'elearning_bucket_id1';
  static const String USERS_COLLECTION = 'users';

  Future<void> changeProfileImage(BuildContext context) async {
    CreateDialogToaster.showErrorDialogDefult(
      "Loading",
      "Please wait while we process your image",
      context,
    );

    try {
      emit(LoadingProfileState());

      final XFile? pickImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickImage == null) {
        emit(InitialProfileState());
        Navigator.pop(context);
        return;
      }

      File imageFile = File(pickImage.path);
      String? userMail = FirebaseAuth.instance.currentUser?.email;

      if (userMail == null) {
        emit(FailureProfileState(error: "User not logged in"));
        Navigator.pop(context);
        return;
      }

      try {
        log("Starting image upload to Appwrite for user: $userMail");

        final String fileName =
            "profile_${DateTime.now().millisecondsSinceEpoch}.jpg";
        final String fileId = ID.unique(); // Generate a unique ID for the file

        // Create input file from the image bytes
        final InputFile inputFile = InputFile.fromBytes(
          bytes: await imageFile.readAsBytes(),
          filename: fileName,
        );

        // Upload file to Appwrite storage
        final models.File uploadedFile = await storage.createFile(
          bucketId: BUCKET_ID,
          fileId: fileId,
          file: inputFile,
        );

        log("Image uploaded to Appwrite. File ID: ${uploadedFile.$id}");

        // Generate the file view URL
        final String imageUrl = await _getFileViewUrl(uploadedFile.$id);
        _uploadedImageUrl = imageUrl;

        log("Appwrite image URL: $imageUrl");

        // Update Firestore with the image URL
        await _updateUserProfileInFirestore(userMail, imageUrl);

        // Update UI with success state
        emit(SucessProfileState(imageProvider: NetworkImage(imageUrl)));
        Navigator.pop(context);
        CreateDialogToaster.showErrorDialogDefult(
          "Success",
          "Profile image updated successfully",
          context,
        );
      } catch (e) {
        log("Appwrite storage error: $e");
        emit(FailureProfileState(error: e.toString()));
        Navigator.pop(context);
        CreateDialogToaster.showErrorDialogDefult(
          "Error",
          "Failed to upload image: ${e.toString()}",
          context,
        );
      }
    } catch (e) {
      log("Error in changeProfileImage: $e");
      emit(FailureProfileState(error: e.toString()));
      Navigator.pop(context);
      CreateDialogToaster.showErrorDialogDefult(
        "Error",
        "An error occurred: ${e.toString()}",
        context,
      );
    }
  }

  Future<void> fetchProfileImage(BuildContext context) async {
    CreateDialogToaster.showErrorDialogDefult(
      "Loading",
      "Loading profile data",
      context,
    );

    try {
      emit(LoadingProfileState());

      String? userMail = FirebaseAuth.instance.currentUser?.email;

      if (userMail == null) {
        emit(FailureProfileState(error: "User not logged in"));
        Navigator.pop(context);
        return;
      }

      log("Fetching profile for user: $userMail");

      // Get user document from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection(USERS_COLLECTION)
              .doc(userMail)
              .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('profileImage')) {
          String imageUrl = userData['profileImage'] as String;

          if (imageUrl.isNotEmpty) {
            log("Found image URL: $imageUrl");
            _uploadedImageUrl = imageUrl;
            emit(SucessProfileState(imageProvider: NetworkImage(imageUrl)));
          } else {
            log("Image URL is empty");
            emit(InitialProfileState());
          }
        } else {
          log("No profile image found in user data");
          emit(InitialProfileState());
        }
      } else {
        log("User document doesn't exist");
        emit(InitialProfileState());
      }

      Navigator.pop(context);
    } catch (e) {
      log("Error in fetchProfileImage: $e");
      emit(FailureProfileState(error: e.toString()));
      Navigator.pop(context);
    }
  }

  // Helper method to get file view URL
  Future<String> _getFileViewUrl(String fileId) async {
    return storage.getFileView(bucketId: BUCKET_ID, fileId: fileId).toString();
  }

  // Helper method to update user profile in Firestore
  Future<void> _updateUserProfileInFirestore(
    String userMail,
    String imageUrl,
  ) async {
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection("users")
        .doc(userMail);

    DocumentSnapshot userDoc = await userDocRef.get();

    if (userDoc.exists) {
      await userDocRef.update({"UserImagePath": imageUrl});
      log("Updated existing user document with Appwrite URL");
    } else {
      await userDocRef.set({
        "userImagePath": imageUrl,
        "userMail": userMail,
        "createdAt": FieldValue.serverTimestamp(),
      });
      log("Created new user document with Appwrite URL");
    }
  }
}
