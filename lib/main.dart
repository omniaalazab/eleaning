import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:eleaning/data/services/stripe_payment/stripe_api.dart';
import 'package:eleaning/firebase_options.dart';
import 'package:eleaning/presentation/cubit/profile/profile_cubit.dart';
import 'package:eleaning/presentation/cubit/user/user_cubit.dart';
import 'package:eleaning/presentation/ui/screens/onboarding/onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:sizer/sizer.dart';

Client client = Client();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  client
      .setEndpoint('https://fra.cloud.appwrite.io/v1')
      .setProject('681f671300018995c931')
      .setSelfSigned(status: true);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _preventRecording();
  _preventScreenshot();
  await dotenv.load();
  Stripe.publishableKey = ApiKeys.stripePublishableKey;
  runApp(const MyApp());
}

Future<void> _preventRecording() async {
  if (Platform.isAndroid) {
    await ScreenProtector.protectDataLeakageOn();
  } else if (Platform.isIOS) {
    await ScreenProtector.preventScreenshotOn();
  }
}

Future<void> _preventScreenshot() async {
  if (Platform.isAndroid) {
    await ScreenProtector.protectDataLeakageOn();
  } else if (Platform.isIOS) {
    // iOS does not have a direct equivalent, but you can use ScreenProtector
    await ScreenProtector.preventScreenshotOn();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<UserCubit>(create: (context) => UserCubit()),
            BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: OnboardingScreen(),
          ),
        );
      },
    );
  }
}
