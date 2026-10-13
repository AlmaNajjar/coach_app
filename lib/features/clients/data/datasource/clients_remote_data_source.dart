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
      ApiConstants.playerSubscriptions,
      queryParameters: queryParams,
    );

    // 3. تحويل مصفوفة 'data' القادمة من السيرفر إلى قائمة من ClientModel
    final dynamic data = response.data['data'];
    if (data is List) {
      return data
          .map(
            (item) =>
                ClientModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    }

    return const [];
  }
}
