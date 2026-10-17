import 'package:coach_app/core/di/dependency_injection.dart';
import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:coach_app/features/clients/data/models/client_model.dart';
import 'package:coach_app/features/clients/data/models/member_shift_model.dart';
import 'package:coach_app/features/clients/domain/entities/measurement_input.dart';
import 'package:coach_app/features/clients/presentation/cubit/trainee_details_cubit.dart';
import 'package:coach_app/features/clients/presentation/cubit/trainee_details_state.dart';
import 'package:coach_app/features/clients/presentation/screen/health_history_screen.dart';
import 'package:coach_app/features/clients/presentation/widgets/attendance_schedule_card.dart';
import 'package:coach_app/features/clients/presentation/widgets/health_and_biometrics.dart';
import 'package:coach_app/features/clients/presentation/widgets/personal_info_section.dart';
import 'package:coach_app/features/clients/presentation/widgets/trainee_details_app_bar.dart';
import 'package:coach_app/features/clients/presentation/widgets/trainee_header_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TraineeDetailsScreen extends StatefulWidget {
  final ClientModel? client;

  const TraineeDetailsScreen({super.key, this.client});

  @override
  State<TraineeDetailsScreen> createState() => _TraineeDetailsScreenState();
}

class _TraineeDetailsScreenState extends State<TraineeDetailsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _dobController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _weightTargetController;
  late final TextEditingController _startDateController;

  // متغيرات جدول الدوام القادمة من كارت AttendanceScheduleCard
  String _scheduleType = 'three_days';
  List<int> _selectedDays = [];
  String _startTime = '16:00';
  String _endTime = '17:30';

  String _selectedGender = 'Male';

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.client?.name ?? '');
    _ageController = TextEditingController();
    _dobController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _weightTargetController = TextEditingController();
    _startDateController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _dobController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _weightTargetController.dispose();
    _startDateController.dispose();
    super.dispose();
  }

  void _onSaveChanges(BuildContext context) {
    final memberId = widget.client?.id;
    if (memberId == null || memberId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot save: Trainee ID not found!')),
      );
      return;
    }

    final weight = double.tryParse(_weightController.text.trim());
    final height = double.tryParse(_heightController.text.trim());

    // 1. تجهيز القياسات إذا تم إدخال الوزن
    MeasurementInput? measurement;
    if (weight != null) {
      measurement = MeasurementInput(
        memberId: memberId,
        weight: weight,
        height: height,
        measurementDate: DateTime.now(),
      );
    }

    // 2. تجهيز جدول الدوام
    CreateShiftScheduleRequest? shiftSchedule;
    final bool hasValidSchedule =
        _scheduleType == 'daily' ||
        (_scheduleType == 'three_days' && _selectedDays.isNotEmpty) ||
        _scheduleType == 'custom';

    if (hasValidSchedule) {
      final now = DateTime.now();
      final currentMonth =
          '${now.year}-${now.month.toString().padLeft(2, '0')}';

      shiftSchedule = CreateShiftScheduleRequest(
        memberId: memberId,
        scheduleType: _scheduleType,
        month: currentMonth,
        selectedDays: _selectedDays,
        startTime: _startTime,
        endTime: _endTime,
        overwrite: true,
      );
    }

    // إذا لم يدخل الكوتش وزناً ولم يحدد دواماً
    if (measurement == null && shiftSchedule == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى إدخال وزن المتدرب أو تحديد جدول دوام لحفظ التغييرات',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 3. الإرسال عبر الكيوبت
    context.read<TraineeDetailsCubit>().saveChanges(
      measurement: measurement,
      shiftSchedule: shiftSchedule,
    );
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return BlocProvider(
      create: (_) {
        final cubit = getIt<TraineeDetailsCubit>();
        final memberId = widget.client?.id;
        if (memberId != null && memberId > 0) {
          cubit.loadMeasurements(memberId);
        }
        return cubit;
      },

      child: BlocConsumer<TraineeDetailsCubit, TraineeDetailsState>(
        listener: (context, state) {
          if (state is TraineeDetailsLoaded) {
            final m = state.latestMeasurement;
            if (m != null) {
              // تعبئة البيانات القادمة من الـ API في الحقول
              if (m.height != null)
                _heightController.text = m.height.toString();
              if (m.weight != null)
                _weightController.text = m.weight.toString();
            }
          } else if (state is TraineeDetailsSaveSuccess) {
            // 🎉 نافذة نجاح أنيقة وفخمة
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                contentPadding: EdgeInsets.all(24.w),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // أيقونة النجاح مع خلفية خضراء ناعمة
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: const Color(0xFF16A34A),
                        size: 48.s,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Saved Successfully!',
                      style: TextStyle(
                        fontSize: 18.s,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Trainee measurements have been updated and synced with the system.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13.s, color: grey),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(); // إغلاق الـ Dialog فقط
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 14.s,
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is TraineeDetailsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isSaving = state is TraineeDetailsSaving;
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: TraineeDetailsAppBar(title: "Training Details"),
            body: Stack(
              fit: StackFit.expand,
              children: [
                // 1. صورة خلفية الشاشة بالكامل
                Positioned.fill(
                  child: Image.asset(
                    'assets/image/splash_ground.jpg',
                    fit: BoxFit.cover,
                  ),
                ),

                // 2. المحتوى فوق الخلفية
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TraineeHeaderCart(
                          name: widget.client?.name ?? 'متدرب',
                          photoUrl: widget.client?.photoUrl,
                          phone: widget.client?.phone,
                          status: widget.client?.status,
                          sessionsAllocated:
                              widget.client?.sessionsAllocated ?? 0,
                          sessionsConsumed:
                              widget.client?.sessionsConsumed ?? 0,
                          startDate: widget.client?.startDate,
                          endDate: widget.client?.endDate,
                        ),

                        PersonalInfoSection(
                          nameController: _nameController,
                          ageController: _ageController,
                          dobController: _dobController,
                          heightController: _heightController,
                          weightController: _weightController,
                          weightTargetController: _weightTargetController,
                          startDateController: _startDateController,
                          selectedGender: _selectedGender,
                          onGenderChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedGender = value);
                            }
                          },
                        ),

                        HealthAndBiometricsCards(
                          onHealthTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => HealthHistoryScreen(
                                  memberId: widget.client?.id ?? 0,
                                  memberName: widget.client?.name ?? 'المتدرب',
                                ),
                              ),
                            );
                          },
                        ),
                        AttendanceScheduleCard(
                          onScheduleChanged:
                              ({
                                required String scheduleType,
                                required List<int> selectedDays,
                                required String startTime,
                                required String endTime,
                              }) {
                                _scheduleType = scheduleType;
                                _selectedDays = selectedDays;
                                _startTime = startTime;
                                _endTime = endTime;
                              },
                        ),

                        // أزرار التحكم
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: OutlinedButton(
                                  onPressed: () {
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                    side: BorderSide(
                                      color: grey.withOpacity(0.3),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 14.s,
                                      fontWeight: FontWeight.w600,
                                      color: grey,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton.icon(
                                  onPressed: isSaving
                                      ? null
                                      : () => _onSaveChanges(context),
                                  icon: isSaving
                                      ? SizedBox(
                                          width: 18.s,
                                          height: 18.s,
                                          child:
                                              const CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                        )
                                      : Icon(
                                          Icons.check,
                                          size: 18.s,
                                          color: white,
                                        ),
                                  label: Text(
                                    isSaving ? 'Saving...' : 'Save Changes',
                                    style: TextStyle(
                                      fontSize: 14.s,
                                      fontWeight: FontWeight.bold,
                                      color: white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primary,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
