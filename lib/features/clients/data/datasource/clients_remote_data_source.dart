import 'package:coach_app/core/networking/api_constants.dart';
import 'package:dio/dio.dart';
import '../models/client_model.dart';

abstract interface class ClientsRemoteDataSource {
  // دالة لجلب قائمة المتدربين مع إمكانية الفلترة بالحالة والبحث
  Future<List<ClientModel>> getClients({String? status, String? search});
}

class ClientsRemoteDataSourceImpl implements ClientsRemoteDataSource {
  final Dio _dio;

  const ClientsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ClientModel>> getClients({String? status, String? search}) async {
    // 1. تجهيز الفلاتر (Query Parameters)
    final Map<String, dynamic> queryParams = {};

    // إذا تم اختيار فلتر غير 'all'، نرسله للسيرفر
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      queryParams['status'] = status;
    }

    // إذا كتب الكوتش نصاً في مربع البحث، نرسله للسيرفر
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }
    // 2. إرسال طلب GET للسيرفر
    final response = await _dio.get(
      ApiConstants.coachPrivateSubscriptions,
      queryParameters: queryParams,
    );

    // 3. استخراج مصفوفة المتدربين بأمان سواء كانت مباشرة أو داخل all_subscriptions
    final dynamic rawData = response.data['data'];
    List<dynamic> itemsList = [];

    if (rawData is List) {
      itemsList = rawData;
    } else if (rawData is Map) {
      if (rawData['all_subscriptions'] is List) {
        itemsList = rawData['all_subscriptions'] as List;
      } else if (rawData['subscriptions'] is List) {
        itemsList = rawData['subscriptions'] as List;
      }
    }

    if (itemsList.isNotEmpty) {
      print('ALL_KEYS: ${(itemsList.first as Map).keys.toList()}');
    }

    return itemsList
        .whereType<Map>()
        .map((item) => ClientModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
