import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

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

  // Services
  final ImagePicker _picker = ImagePicker();
  final Storage _storage = Storage(client);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Cache
  Uint8List? _profileImageBytes;
  String? _profileImageId;

  // Constants
  static const String _bucketId = 'elearning_bucket_id1';
  static const String _userCollection = 'users';

  /// Selects and changes the user's profile image
  Future<void> changeProfileImage(BuildContext context) async {
    try {
      // Check if user is logged in first
      String? userEmail = getCurrentUserEmail();
      if (userEmail == null) {
        // Handle gracefully - don't show error, just return
        return;
      }

      // Show loading dialog
      _showLoadingDialog(context, "Please wait while we process your image");

      // Update state to loading
      emit(LoadingProfileState());

      // Pick image from gallery
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      // Handle case where user canceled image selection
      if (pickedImage == null) {
        emit(InitialProfileState());
        Navigator.pop(context);
        return;
      }

      // Process and upload image
      File imageFile = File(pickedImage.path);
      await _uploadAndSaveImage(context, imageFile, userEmail);
    } catch (e) {
      _handleError(context, "An error occurred: ${e.toString()}");
    }
  }

  /// Fetches the user's profile image
  Future<void> fetchProfileImage(BuildContext context) async {
    try {
      emit(LoadingProfileState());

      // Get the current user's email
      String? userEmail = getCurrentUserEmail();
      if (userEmail == null) {
        emit(FailureProfileState(error: "User not logged in."));
        return;
      }

      // Get fileId from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection(_userCollection).doc(userEmail).get();

      if (!userDoc.exists ||
          !userDoc.data().toString().contains('userImagePath')) {
        emit(FailureProfileState(error: "No profile image found."));
        return;
      }

      final String fileId = userDoc.get('userImagePath');

      // Download the image bytes using fileId
      final Uint8List imageBytes = await _downloadImageBytes(fileId);

      // Emit success state
      emit(SucessProfileState(imageProvider: MemoryImage(imageBytes)));
    } catch (e) {
      emit(FailureProfileState(error: e.toString()));
    }
  }

  /// Returns the cached profile image bytes if available
  // Uint8List? get profileImageBytes => _profileImageBytes;

  /// Upload image to Appwrite and save reference in Firestore
  Future<void> _uploadAndSaveImage(
    BuildContext context,
    File imageFile,
    String userEmail,
  ) async {
    try {
      log("Starting image upload to Appwrite for user: $userEmail");

      final String fileName =
          "profile_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final String fileId = ID.unique();

      // Create input file from image bytes
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final InputFile inputFile = InputFile.fromBytes(
        bytes: imageBytes,
        filename: fileName,
      );

      // Upload file to Appwrite storage
      final models.File uploadedFile = await _storage.createFile(
        bucketId: _bucketId,
        fileId: fileId,
        file: inputFile,
      );

      log("Image uploaded to Appwrite. File ID: ${uploadedFile.$id}");

      // Cache the image bytes and ID
      _profileImageBytes = imageBytes;
      _profileImageId = uploadedFile.$id;

      // Update Firestore with file ID
      await _updateUserProfileInFirestore(userEmail, uploadedFile.$id);

      // Update UI with success state using MemoryImage
      emit(SucessProfileState(imageProvider: MemoryImage(imageBytes)));

      // Close loading dialog and show success message
      Navigator.pop(context);
      CreateDialogToaster.showErrorDialogDefult(
        "Success",
        "Profile image updated successfully",
        context,
      );
    } catch (e) {
      log("Error uploading image: $e");
      _handleError(context, "Failed to upload image: ${e.toString()}");
    }
  }

  /// Download image bytes from Appwrite
  Future<Uint8List> _downloadImageBytes(String fileId) async {
    try {
      return await _storage.getFileDownload(
        bucketId: _bucketId,
        fileId: fileId,
      );
    } catch (e) {
      log("Error downloading file: $e");
      throw Exception('Failed to download image: $e');
    }
  }

  /// Update user profile in Firestore
  Future<void> _updateUserProfileInFirestore(
    String userEmail,
    String fileId,
  ) async {
    DocumentReference userDocRef = _firestore
        .collection(_userCollection)
        .doc(userEmail);

    DocumentSnapshot userDoc = await userDocRef.get();

    if (userDoc.exists) {
      await userDocRef.update({"userImagePath": fileId});
      log("Updated existing user document with file ID");
    } else {
      await userDocRef.set({
        "userImagePath": fileId,
        "email": userEmail,
        "createdAt": FieldValue.serverTimestamp(),
      });
      log("Created new user document with file ID");
    }
  }

  /// Get current user email
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  /// Show loading dialog
  void _showLoadingDialog(BuildContext context, String message) {
    CreateDialogToaster.showErrorDialogDefult("Loading", message, context);
  }

  /// Handle errors
  void _handleError(BuildContext context, String errorMessage) {
    emit(FailureProfileState(error: errorMessage));
    Navigator.pop(context);
    CreateDialogToaster.showErrorDialogDefult("Error", errorMessage, context);
  }
}
