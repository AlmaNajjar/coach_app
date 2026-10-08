import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordHashService {
  static const String defaultPassword = '12345678';

  static const String _secretKey = String.fromEnvironment(
    'PASSWORD_HASH_SECRET_KEY',
    defaultValue: 'oid900=rjfreipwhefdk',
  );

  /// Checks if a string is already a valid SHA-256 hex string (64 hex characters)
  static bool isAlreadyHashed(String input) {
    final hexRegex = RegExp(r'^[a-fA-F0-9]{64}$');
    return hexRegex.hasMatch(input);
  }

  /// Hashes a password according to the shared contract:
  /// lowercaseHex(SHA-256(UTF-8(secretKey + password)))
  static String hashPassword(String password, {String? customSecretKey}) {
    final trimmedPassword = password.trim();

    // 1. إذا كانت كلمة المرور فارغة، نعيدها كما هي
    if (trimmedPassword.isEmpty) return trimmedPassword;

    if (isAlreadyHashed(trimmedPassword)) {
      return trimmedPassword.toLowerCase();
    }

    final key = customSecretKey ?? _secretKey;

    if (key.isEmpty) {
      throw StateError('إعداد مفتاح تشفير كلمة المرور غير موجود.');
    }

    // 3. Concatenation المباشر بدون فواصل
    final inputString = '$key$trimmedPassword';

    // 4. UTF-8 byte encoding
    final bytes = utf8.encode(inputString);

    // 5. SHA-256 hashing
    final digest = sha256.convert(bytes);

    // 6. Return lowercase hexadecimal string
    return digest.toString().toLowerCase();
  }

  /// Hashes the default system password ("12345678")
  static String hashDefaultPassword({String? customSecretKey}) {
    return hashPassword(defaultPassword, customSecretKey: customSecretKey);
  }
}
