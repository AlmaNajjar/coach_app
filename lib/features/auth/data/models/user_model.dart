class UserModel {
  UserModel._(Map<String, dynamic> json) : _json = Map.unmodifiable(json);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel._(Map<String, dynamic>.from(json));

  final Map<String, dynamic> _json;

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(_json);

  dynamic get id => _json['id'];
  String? get name => _stringValue(_json['name']);
  String? get username => _stringValue(_json['username']);
  String? get email => _stringValue(_json['email']);
  String? get phone => _stringValue(_json['phone']);
  String? get role => _stringValue(_json['role']);
  int? get branchId => (_json['branch_id'] as num?)?.toInt();

  static String? _stringValue(dynamic value) => value?.toString();
}
