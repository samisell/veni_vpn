import 'dart:convert';

class PaymentMethodItem {
  final int id;
  final String iconUrl;
  final String name;
  final String type;

  PaymentMethodItem({
    required this.id,
    required this.iconUrl,
    required this.name,
    required this.type,
  });
}

List<PaymentMethodItem> myList = [
  PaymentMethodItem(
    id: 0,
    iconUrl: '',
    name: 'In App Subscription',
    type: 'in_app',
  ),
  PaymentMethodItem(
    id: 1,
    iconUrl: 'https://flutterwave.com/images/logo/full.svg',
    name: 'Flutterwave',
    type: 'flutterwave',
  ),
  // PaymentMethodItem(
  //   id: 2,
  //   iconUrl: 'https://avatars.githubusercontent.com/u/103308159?s=200&v=4',
  //   name: 'UddoktaPay',
  //   type: 'uddoktapay',
  // ),
];

String createPaymentData({
  required String fullName,
  required String email,
  required String amount,
  required Map<String, String> metadata,
  required String redirectUrl,
  required String returnType,
  required String cancelUrl,
  required String webhookUrl,
}) {
  Map<String, dynamic> formData = {
    'full_name': fullName,
    'email': email,
    'amount': amount,
    'metadata': metadata,
    'redirect_url': redirectUrl,
    'return_type': returnType,
    'cancel_url': cancelUrl,
    'webhook_url': webhookUrl,
  };

  return jsonEncode(formData);
}

String verifyPaymentData({
  required String invoiceId
}) {
  Map<String, dynamic> formData = {
    'invoice_id': invoiceId
  };

  return jsonEncode(formData);
}

// Flutterwave payment data
String createFlutterwavePaymentData({
  required String userId,
  required String transactionRef,
  required String productId,
  required String amount,
  required String currency,
  required String paymentMethod,
  required String status,
  required String packageDuration,
}) {
  Map<String, dynamic> formData = {
    'user_id': userId,
    'transaction_ref': transactionRef,
    'product_id': productId,
    'amount': amount,
    'currency': currency,
    'payment_method': paymentMethod,
    'status': status,
    'package_duration': packageDuration,
    'date': DateTime.now().toIso8601String(),
  };

  return jsonEncode(formData);
}

String savePaymentData({
  required String userId,
  required String invoiceId,
  required String productId,
  required String amount,
  required String fee,
  required String chargedAmount,
  required String paymentMethod,
  required String senderNumber,
  required String transactionId,
  required String date,
  required String status,
}) {
  Map<String, dynamic> formData = {
    'user_id': userId,
    'invoice_id': invoiceId,
    'product_id': productId,
    'amount': amount,
    'fee': fee,
    'charged_amount': chargedAmount,
    'payment_method': paymentMethod,
    'sender_number': senderNumber,
    'transaction_id': transactionId,
    'date': date,
    'status': status,
  };

  return jsonEncode(formData);
}