class CoachProfile {
  const CoachProfile({
    required this.id,
    required this.fullName,
    this.firstName,
    this.lastName,
    this.gender,
    this.age,
    this.dateOfBirth,
    this.address,
    this.photoUrl,
    this.phone,
    this.email,
    this.username,
    this.workStatus,
    this.isActive,
    this.employmentType,
    this.baseSalary,
    this.defaultCommissionRate,
    this.privateCommissionRate,
    this.experienceYears,
    this.branches = const [],
    this.totalSubscribers,
    this.activeSubscribers,
  });

  final int? id;
  final String fullName;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final int? age;
  final int? totalSubscribers;
  final int? activeSubscribers;

  final DateTime? dateOfBirth;
  final String? address;
  final String? photoUrl;
  final String? phone;
  final String? email;
  final String? username;
  final String? workStatus;
  final bool? isActive;
  final String? employmentType;
  final num? baseSalary;
  final num? defaultCommissionRate;
  final num? privateCommissionRate;
  final int? experienceYears;
  final List<CoachBranch> branches;
}

class CoachBranch {
  const CoachBranch({required this.name, this.id});

  final int? id;
  final String name;
}
