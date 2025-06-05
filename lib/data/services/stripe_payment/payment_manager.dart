import 'package:eleaning/data/services/dio_helper.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentManager {
  static Future<bool> makePayment(int amount, String currency) async {
    try {
      String clientSecret = await _getClientSecret(
        (amount * 100).toString(),
        currency,
      );
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
      return true; // Payment successful
    } catch (e) {
      print("Error while making payment: $e");

      throw Exception(e.toString());
    }
  }

  static Future<void> _initializePaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,

        merchantDisplayName: 'Your Company Name',
      ),
    );
  }
}

Future<String> _getClientSecret(String amount, String currency) async {
  var response = await DioHelper.post(
    "https://api.stripe.com/v1/payment_intents",
    {'amount': amount, 'currency': currency},
  ); // Initialize Dio with Stripe API base URL
  return response.data['client_secret'] as String;
}
