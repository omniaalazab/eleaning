import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eleaning/data/models/user_model.dart';
import 'package:eleaning/presentation/cubit/user/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserCubit() : super(UserState(user: []));
  Future<void> addUser({
    required String userMail,
    required String userName,
    required String userPassword,
    required String fullName,
    String? userImagePath,

    // String? address,
    // String? city,
    // String? state,
    // String? country,
  }) async {
    final user = Users(
      userMail: userMail,
      userName: userName,
      userPassword: userPassword,
      userFullName: fullName,
      userImagePath:
          userImagePath ??
          "https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg",
      // address: address ,
      // city: city,
      // country: country ,
      // state: state ,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userMail)
        .set(user.toMap());

    final newUser = List<Users>.from(state.user);
    log("****************");
    newUser.add(user);
    emit(UserState(user: newUser));
  }

  Future<void> fetchUserData() async {
    User? user1 = FirebaseAuth.instance.currentUser;
    if (user1 == null) {
      print("No authenticated user found");
      return;
    }

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('userMail', isEqualTo: user1.email)
            .get();

    if (snapshot.docs.isEmpty) {
      print("No user data found in Firestore for email: ${user1.email}");
      return;
    }

    final user = snapshot.docs.map((doc) => Users.fromMap(doc.data())).toList();
    emit(UserState(user: user));
  }

  Future<void> fetchAllUsersData() async {
    User? user1 = FirebaseAuth.instance.currentUser;
    if (user1 != null) {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final user =
          snapshot.docs.map((doc) => Users.fromMap(doc.data())).toList();
      emit(UserState(user: user));
    }
  }

  Future<void> updateUser({
    required String userMail,
    String? userName,
    String? userPassword,

    String? userFullName,
    String? profileImage,
  }) async {
    final updateData = <String, dynamic>{};

    if (userName != null) updateData['userName'] = userName;
    if (userPassword != null) updateData['userPassword'] = userPassword;

    if (userFullName != null) updateData['userFullName'] = userFullName;
    if (profileImage != null) updateData['userImagePath'] = profileImage;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userMail)
        .update(updateData);

    // Fetch updated user data
    await fetchUserData();
  }
}
