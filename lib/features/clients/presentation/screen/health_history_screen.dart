import 'package:coach_app/core/di/dependency_injection.dart';
import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:coach_app/features/clients/domain/entities/health_profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/health_profile_cubit.dart';
import '../cubit/health_profile_state.dart';
import '../widgets/health_expendable_card.dart';
import '../widgets/health_general_details_card.dart';
import '../widgets/health_info_banner.dart';
import '../widgets/health_save_button.dart';
import '../widgets/trainee_details_app_bar.dart';

class HealthHistoryScreen extends StatefulWidget {
  final int memberId;
  final String memberName;

  const HealthHistoryScreen({
    super.key,
    required this.memberId,
    required this.memberName,
  });

  @override
  State<HealthHistoryScreen> createState() => _HealthHistoryScreenState();
}

class _HealthHistoryScreenState extends State<HealthHistoryScreen> {
  final TextEditingController _injuriesController = TextEditingController();
  final TextEditingController _chronicController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _emergencyNameController =
      TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();
  final TextEditingController _sportGoalController = TextEditingController();

  String _selectedBloodType = 'O+';
  String _selectedFitnessLevel = 'intermediate';

  bool _isInjuriesExpanded = true;
  bool _isChronicExpanded = false;
  bool _isMedicationsExpanded = false;
  bool _isAllergiesExpanded = false;
  bool _isGeneralExpanded = false;

  @override
  void dispose() {
    _injuriesController.dispose();
    _chronicController.dispose();
    _medicationsController.dispose();
    _allergiesController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _sportGoalController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    final entity = HealthProfileEntity(
      memberId: widget.memberId,
      physicalInjuries: _injuriesController.text.trim(),
      organicDiseases: _chronicController.text.trim(),
      medications: _medicationsController.text.trim(),
      allergies: _allergiesController.text.trim(),
      bloodType: _selectedBloodType,
      emergencyContactName: _emergencyNameController.text.trim(),
      emergencyContactPhone: _emergencyPhoneController.text.trim(),
      sportGoal: _sportGoalController.text.trim(),
      fitnessLevel: _selectedFitnessLevel,
    );

    context.read<HealthProfileCubit>().saveHealthProfile(entity);
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return BlocProvider(
      create: (_) =>
          getIt<HealthProfileCubit>()..loadHealthProfile(widget.memberId),
      child: BlocConsumer<HealthProfileCubit, HealthProfileState>(
        listener: (context, state) {
          if (state is HealthProfileLoaded && state.profile != null) {
            final p = state.profile!;
            _injuriesController.text = p.physicalInjuries ?? '';
            _chronicController.text = p.organicDiseases ?? '';
            _medicationsController.text = p.medications ?? '';
            _allergiesController.text = p.allergies ?? '';
            _emergencyNameController.text = p.emergencyContactName ?? '';
            _emergencyPhoneController.text = p.emergencyContactPhone ?? '';
            _sportGoalController.text = p.sportGoal ?? '';
            if (p.bloodType != null && p.bloodType!.isNotEmpty) {
              setState(() => _selectedBloodType = p.bloodType!);
            }
            if (p.fitnessLevel != null && p.fitnessLevel!.isNotEmpty) {
              setState(() => _selectedFitnessLevel = p.fitnessLevel!);
            }
          } else if (state is HealthProfileSaveSuccess) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                contentPadding: EdgeInsets.all(24.w),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: primary,
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
                      'Trainee health profile has been saved to the server.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13.s, color: grey),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
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
          } else if (state is HealthProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: primary,
              ),
            );
          }
        },
        builder: (context, state) {
          final isSaving = state is HealthProfileSaving;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Scaffold(
              backgroundColor: backgroundColor,
              appBar: TraineeDetailsAppBar(
                title: 'Health History',
                subtitle: 'Medical history & conditions',
                trailing: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.09), // خلفية دائرية زرقاء ناعمة
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(Icons.monitor_heart, color: primary, size: 20.s),
                  ),
                ),
              ),
            
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: Column(
                          children: [
                            const HealthInfoBanner(),
                            SizedBox(height: 16.h),
            
                            // 1. Injuries
                            HealthExpandableCard(
                              title: 'Injuries',
                              subtitle: 'E.g. knee injury, back pain...',
                              icon: Icons.healing_rounded,
                              isExpanded: _isInjuriesExpanded,
                              onToggle: () => setState(
                                () => _isInjuriesExpanded = !_isInjuriesExpanded,
                              ),
                              controller: _injuriesController,
                              hint:
                                  'Describe any previous or current physical injuries...',
                            ),
                            SizedBox(height: 12.h),
            
                            // 2. Chronic Conditions
                            HealthExpandableCard(
                              title: 'Chronic Conditions',
                              subtitle: 'E.g. diabetes, hypertension...',
                              icon: Icons.favorite_border_rounded,
                              isExpanded: _isChronicExpanded,
                              onToggle: () => setState(
                                () => _isChronicExpanded = !_isChronicExpanded,
                              ),
                              controller: _chronicController,
                              hint: 'Describe any organic or chronic diseases...',
                            ),
                            SizedBox(height: 12.h),
            
                            // 3. Medications
                            HealthExpandableCard(
                              title: 'Medications',
                              subtitle: 'E.g. vitamin D, painkillers...',
                              icon: Icons.medication_outlined,
                              isExpanded: _isMedicationsExpanded,
                              onToggle: () => setState(
                                () => _isMedicationsExpanded =
                                    !_isMedicationsExpanded,
                              ),
                              controller: _medicationsController,
                              hint: 'List any prescribed drugs or supplements...',
                            ),
                            SizedBox(height: 12.h),
            
                            // 4. Allergies
                            HealthExpandableCard(
                              title: 'Allergies & Dietary Restrictions',
                              subtitle: 'E.g. nuts allergy, gluten-free...',
                              icon: Icons.spa_outlined,
                              isExpanded: _isAllergiesExpanded,
                              onToggle: () => setState(
                                () =>
                                    _isAllergiesExpanded = !_isAllergiesExpanded,
                              ),
                              controller: _allergiesController,
                              hint: 'Mention any food or chemical allergies...',
                            ),
                            SizedBox(height: 12.h),
            
                            // 5. Emergency Contact & Fitness Details
                            HealthGeneralDetailsCard(
                              isExpanded: _isGeneralExpanded,
                              onToggle: () => setState(
                                () => _isGeneralExpanded = !_isGeneralExpanded,
                              ),
                              selectedBloodType: _selectedBloodType,
                              onBloodTypeChanged: (v) {
                                if (v != null)
                                  setState(() => _selectedBloodType = v);
                              },
                              selectedFitnessLevel: _selectedFitnessLevel,
                              onFitnessLevelChanged: (v) {
                                if (v != null)
                                  setState(() => _selectedFitnessLevel = v);
                              },
                              sportGoalController: _sportGoalController,
                              emergencyNameController: _emergencyNameController,
                              emergencyPhoneController: _emergencyPhoneController,
                            ),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),
                    ),
            
                    // 6. زر الحفظ
                    HealthSaveButton(
                      isSaving: isSaving,
                      onSave: () => _onSave(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
