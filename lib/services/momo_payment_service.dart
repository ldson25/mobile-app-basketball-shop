import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class MomoPaymentResult {
  const MomoPaymentResult({
    required this.orderId,
    required this.requestId,
    required this.payUrl,
    required this.deeplink,
    required this.qrCodeUrl,
    required this.resultCode,
    required this.message,
  });

  final String orderId;
  final String requestId;
  final String payUrl;
  final String deeplink;
  final String qrCodeUrl;
  final int resultCode;
  final String message;

  bool get canPay => resultCode == 0 && (deeplink.isNotEmpty || payUrl.isNotEmpty);
}

class MomoPaymentService {
  static const _partnerCode = String.fromEnvironment(
    'MOMO_PARTNER_CODE',
    defaultValue: 'MOMO',
  );
  static const _accessKey = String.fromEnvironment(
    'MOMO_ACCESS_KEY',
    defaultValue: 'F8BBA842ECF85',
  );
  static const _secretKey = String.fromEnvironment(
    'MOMO_SECRET_KEY',
    defaultValue: 'K951B6PE1waDMi640xX08PD3vg6EkVlz',
  );
  static const _redirectUrl = String.fromEnvironment(
    'MOMO_REDIRECT_URL',
    defaultValue: 'https://test-payment.momo.vn/return',
  );
  static const _ipnUrl = String.fromEnvironment(
    'MOMO_IPN_URL',
    defaultValue: 'https://test-payment.momo.vn/ipn',
  );
  static const _endpoint = String.fromEnvironment(
    'MOMO_CREATE_ENDPOINT',
    defaultValue: 'https://test-payment.momo.vn/v2/gateway/api/create',
  );

  bool get isConfigured =>
      _partnerCode.isNotEmpty &&
      _accessKey.isNotEmpty &&
      _secretKey.isNotEmpty &&
      _redirectUrl.isNotEmpty &&
      _ipnUrl.isNotEmpty;

  Future<MomoPaymentResult> createPayment({
    required String orderId,
    required double amount,
    required String orderInfo,
  }) async {
    if (!isConfigured) {
      throw const MomoPaymentException(
        'Chua cau hinh MoMo. Can MOMO_PARTNER_CODE, MOMO_ACCESS_KEY, MOMO_SECRET_KEY, MOMO_REDIRECT_URL, MOMO_IPN_URL.',
      );
    }

    final requestId =
        '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(9999)}';
    final amountText = amount.round().toString();
    const requestType = 'captureWallet';
    const extraData = '';

    final rawSignature =
        'accessKey=$_accessKey&amount=$amountText&extraData=$extraData&ipnUrl=$_ipnUrl&orderId=$orderId&orderInfo=$orderInfo&partnerCode=$_partnerCode&redirectUrl=$_redirectUrl&requestId=$requestId&requestType=$requestType';
    final signature = Hmac(sha256, utf8.encode(_secretKey))
        .convert(utf8.encode(rawSignature))
        .toString();

    final payload = {
      'partnerCode': _partnerCode,
      'partnerName': 'Kinetic',
      'storeId': 'KineticStore',
      'requestId': requestId,
      'amount': amountText,
      'orderId': orderId,
      'orderInfo': orderInfo,
      'redirectUrl': _redirectUrl,
      'ipnUrl': _ipnUrl,
      'extraData': extraData,
      'requestType': requestType,
      'autoCapture': true,
      'signature': signature,
      'lang': 'vi',
    };

    debugPrint(
      'MoMo sandbox request: ${jsonEncode({
        ...payload,
        'signature': '${signature.substring(0, 8)}...',
      })}',
    );

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    debugPrint('MoMo sandbox response: ${response.statusCode} ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw MomoPaymentException('MoMo HTTP ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return MomoPaymentResult(
      orderId: (data['orderId'] ?? orderId).toString(),
      requestId: (data['requestId'] ?? requestId).toString(),
      payUrl: (data['payUrl'] ?? '').toString(),
      deeplink: (data['deeplink'] ?? '').toString(),
      qrCodeUrl: (data['qrCodeUrl'] ?? '').toString(),
      resultCode: int.tryParse((data['resultCode'] ?? -1).toString()) ?? -1,
      message: (data['message'] ?? '').toString(),
    );
  }
}

class MomoPaymentException implements Exception {
  const MomoPaymentException(this.message);

  final String message;

  @override
  String toString() => message;
}
