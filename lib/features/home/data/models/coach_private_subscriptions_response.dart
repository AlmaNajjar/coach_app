import 'package:coach_app/features/home/domain/entities/coach_profile.dart';

class CoachPrivateSubscriptionsResponse {
  const CoachPrivateSubscriptionsResponse({required this.coach});

  final CoachProfile coach;

  factory CoachPrivateSubscriptionsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = _asStringMap(json['data']);
    if (data == null) {
      throw const FormatException(
        'Coach subscriptions response has no data object.',
      );
    }

    final coach = _asStringMap(data['coach']);
    if (coach == null) {
      throw const FormatException(
        'Coach subscriptions response has no coach object.',
      );
    }

    return CoachPrivateSubscriptionsResponse(
      coach: _coachFromJson(coach),
    );
  }

  static CoachProfile _coachFromJson(Map<String, dynamic> json) {
    final firstName = _stringValue(json['first_name']);
    final lastName = _stringValue(json['last_name']);
    final fullName = _firstNonEmpty([
      json['full_name'],
      json['name'],
      [firstName, lastName].whereType<String>().join(' '),
    ]);
    if (fullName == null) {
      throw const FormatException(
        'Coach subscriptions response has no coach name.',
      );
    }

    return CoachProfile(
      id: _intValue(json['coach_id'] ?? json['id']),
      fullName: fullName,
      firstName: firstName,
      lastName: lastName,
      gender: _stringValue(json['gender']),
      age: _intValue(json['age']),
      dateOfBirth: _dateValue(json['dob'] ?? json['date_of_birth']),
      address: _stringValue(json['address']),
      photoUrl: _firstNonEmpty([json['photo_url'], json['photo']]),
      phone: _firstNonEmpty([json['phone'], json['phone_number']]),
      email: _stringValue(json['email']),
      username: _stringValue(json['username']),
      workStatus: _stringValue(json['work_status']),
      isActive: _boolValue(json['is_active']),
      employmentType: _firstNonEmpty([
        json['employment_type'],
        json['contract_type'],
      ]),
      baseSalary: _numValue(json['base_salary']),
      defaultCommissionRate: _numValue(json['default_commission_rate']),
      privateCommissionRate: _numValue(json['private_commission_rate']),
      experienceYears: _intValue(json['experience_years']),
      branches: _branchList(json['branches']),
    );
  }

  static List<CoachBranch> _branchList(dynamic value) {
    if (value == null) return const [];
    if (value is! List) {
      throw const FormatException('Coach branches must be a list.');
    }

    return value.map((branch) {
      final json = _asStringMap(branch);
      if (json == null) {
        throw const FormatException('Coach branch must be an object.');
      }
      return CoachBranch(
        id: _intValue(json['id']),
        name: _stringValue(json['name']) ?? '',
      );
    }).where((branch) => branch.name.isNotEmpty).toList(growable: false);
  }

  static Map<String, dynamic>? _asStringMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static String? _stringValue(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static String? _firstNonEmpty(Iterable<dynamic> values) {
    for (final value in values) {
      final text = _stringValue(value);
      if (text != null) return text;
    }
    return null;
  }

  static int? _intValue(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static num? _numValue(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '');
  }

  static bool? _boolValue(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      switch (value.trim().toLowerCase()) {
        case 'true':
        case '1':
        case 'yes':
          return true;
        case 'false':
        case '0':
        case 'no':
          return false;
      }
    }
    return null;
  }

  static DateTime? _dateValue(dynamic value) {
    final date = _stringValue(value);
    return date == null ? null : DateTime.tryParse(date);
  }
}
