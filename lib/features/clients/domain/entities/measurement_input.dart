class MeasurementInput {
  const MeasurementInput({
    this.memberId,
    this.measurementDate,
    this.weight,
    this.height,
    this.neckCircumference,
    this.shoulderCircumference,
    this.chestCircumference,
    this.waistCircumference,
    this.hipCircumference,
    this.buttocksCircumference,
    this.rightThighMid,
    this.leftThigh,
    this.aboveRightKnee,
    this.aboveLeftKnee,
    this.rightCalf,
    this.leftCalf,
    this.rightBicep,
    this.leftBicep,
    this.armCircumference,
    this.physicalActivityLevel,
  });

  final int? memberId;
  final DateTime? measurementDate;
  final double? weight;
  final double? height;
  final double? neckCircumference;
  final double? shoulderCircumference;
  final double? chestCircumference;
  final double? waistCircumference;
  final double? hipCircumference;
  final double? buttocksCircumference;
  final double? rightThighMid;
  final double? leftThigh;
  final double? aboveRightKnee;
  final double? aboveLeftKnee;
  final double? rightCalf;
  final double? leftCalf;
  final double? rightBicep;
  final double? leftBicep;
  final double? armCircumference;
  final String? physicalActivityLevel;
}