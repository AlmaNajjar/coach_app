class MemberMeasurement {
  const MemberMeasurement({
    required this.id,
    this.memberId,
    this.measurementDate,
    this.weight,
    this.height,
    this.bodyFatPercentage,
    this.muscleMass,
    this.waistCircumference,
    this.neckCircumference,
    this.shoulderCircumference,
    this.rightBicep,
    this.leftBicep,
    this.hipCircumference,
    this.chestCircumference,
    this.rightThighMid,
    this.leftThigh,
    this.rightCalf,
    this.leftCalf,
    this.fatFreeMassPercentage,
    this.bmi,
    this.bodyWaterPercentage,
    this.restingMetabolicRate,
    this.totalDailyEnergyExpenditure,
    this.physicalActivityLevel,
    this.buttocksCircumference,
    this.aboveRightKnee,
    this.aboveLeftKnee,
    this.armCircumference,
    this.lastUpdatedAt,
  });

  final int id;
  final int? memberId;
  final DateTime? measurementDate;

  /// kg
  final double? weight;

  /// cm
  final double? height;

  final double? bodyFatPercentage;
  final double? muscleMass;
  final double? waistCircumference;
  final double? neckCircumference;
  final double? shoulderCircumference;
  final double? rightBicep;
  final double? leftBicep;
  final double? hipCircumference;
  final double? chestCircumference;
  final double? rightThighMid;
  final double? leftThigh;
  final double? rightCalf;
  final double? leftCalf;
  final double? fatFreeMassPercentage;
  final double? bmi;
  final double? bodyWaterPercentage;
  final double? restingMetabolicRate;
  final double? totalDailyEnergyExpenditure;
  final String? physicalActivityLevel;
  final double? buttocksCircumference;
  final double? aboveRightKnee;
  final double? aboveLeftKnee;
  final double? armCircumference;
  final DateTime? lastUpdatedAt;
}

/// صفحة من القياسات (الـ API فيه pagination)
class MeasurementsPage {
  const MeasurementsPage({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  final List<MemberMeasurement> items;
  final int currentPage;
  final int lastPage;
  final int total;

  bool get hasNext => currentPage < lastPage;

  /// أحدث قياس حسب التاريخ (ما بنفترض إنو الباك مرتّب الرد)
  MemberMeasurement? get latest {
    if (items.isEmpty) return null;
    return items.reduce((a, b) {
      final da = a.measurementDate ?? DateTime(0);
      final db = b.measurementDate ?? DateTime(0);
      if (da == db) return a.id >= b.id ? a : b;
      return da.isAfter(db) ? a : b;
    });
  }
}