import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:coach_app/core/networking/api_constants.dart';
import 'package:coach_app/features/home/domain/entities/coach_profile.dart';
import 'package:coach_app/features/home/presentation/cubit/coach_profile_cubit.dart';
import 'package:coach_app/features/home/presentation/cubit/coach_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachProfileCard extends StatelessWidget {
  const CoachProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoachProfileCubit, CoachProfileState>(
      builder: (context, state) {
        if (state.isLoading || state.status == CoachProfileStatus.initial) {
          return _buildMessageCard(
            child: const Center(
              child: CircularProgressIndicator(),
            ),
            height: 150,
          );
        }

        if (state.status == CoachProfileStatus.failure) {
          return _buildMessageCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.errorMessage ?? 'Unable to load coach information.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor, fontSize: 13.s),
                ),
                SizedBox(height: 8.h),
                TextButton.icon(
                  onPressed: () => context.read<CoachProfileCubit>().load(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try again'),
                ),
              ],
            ),
          );
        }

        final profile = state.profile;
        if (profile == null) {
          return _buildMessageCard(
            child: const Text('Coach information is unavailable.'),
          );
        }

        return _buildProfileCard(context, profile);
      },
    );
  }

  Widget _buildProfileCard(BuildContext context, CoachProfile profile) {
    final details = <Widget>[
      if (profile.username != null)
        _detail(Icons.alternate_email, profile.username!),
      if (profile.phone != null) _detail(Icons.phone_outlined, profile.phone!),
      if (profile.email != null) _detail(Icons.mail_outline, profile.email!),
      if (profile.age != null || profile.gender != null)
        _detail(
          Icons.person_outline,
          [
            if (profile.age != null) '${profile.age} years',
            if (profile.gender != null) _displayValue(profile.gender!),
          ].join(' · '),
        ),
      if (profile.employmentType != null)
        _detail(
          Icons.work_outline,
          _displayValue(profile.employmentType!),
        ),
      if (profile.privateCommissionRate != null)
        _detail(
          Icons.percent,
          'Private commission ${_formatNumber(profile.privateCommissionRate!)}%',
        ),
      if (profile.defaultCommissionRate != null)
        _detail(
          Icons.pie_chart_outline,
          'Standard commission ${_formatNumber(profile.defaultCommissionRate!)}%',
        ),
      if (profile.experienceYears != null)
        _detail(
          Icons.workspace_premium_outlined,
          '${profile.experienceYears} years experience',
        ),
      if (profile.branches.isNotEmpty)
        _detail(
          Icons.location_on_outlined,
          profile.branches.map((branch) => branch.name).join(', '),
        ),
      if (profile.workStatus != null)
        _detail(Icons.badge_outlined, _displayValue(profile.workStatus!)),
      if (profile.baseSalary != null)
        _detail(
          Icons.payments_outlined,
          'Base salary ${_formatNumber(profile.baseSalary!)}',
        ),
      if (profile.address != null)
        _detail(Icons.home_outlined, profile.address!),
      if (profile.dateOfBirth != null)
        _detail(
          Icons.cake_outlined,
          _formatDate(profile.dateOfBirth!),
        ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAvatar(profile.photoUrl),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            profile.fullName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.s,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                        if (profile.isActive == true)
                          Padding(
                            padding: EdgeInsets.only(left: 4.w),
                            child: Icon(
                              Icons.verified,
                              size: 17.s,
                              color: primary,
                            ),
                          ),
                      ],
                    ),
                    if (profile.username != null) ...[
                      SizedBox(height: 3.h),
                      Text(
                        '@${profile.username}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.s, color: grey),
                      ),
                    ],
                    if (profile.isActive != null) ...[
                      SizedBox(height: 4.h),
                      _statusBadge(profile.isActive!),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (details.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Divider(height: 1, color: grey.withOpacity(0.18)),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 9.h,
              children: details,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(String? photoUrl) {
    final imageUrl = _resolvePhotoUrl(photoUrl);
    return Container(
      width: 58.w,
      height: 58.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: backgroundColor, width: 1.w),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl == null
          ? _avatarPlaceholder()
          : Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _avatarPlaceholder(),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return _avatarPlaceholder();
              },
            ),
    );
  }

  String? _resolvePhotoUrl(String? photoUrl) {
    final value = photoUrl?.trim();
    if (value == null || value.isEmpty) return null;

    final uri = Uri.tryParse(value);
    if (uri == null) return null;
    if (uri.hasScheme) return uri.toString();
    return Uri.parse(ApiConstants.baseUrl).resolve(value).toString();
  }

  Widget _avatarPlaceholder() {
    return Container(
      color: backgroundColor,
      alignment: Alignment.center,
      child: Icon(Icons.person, color: grey, size: 30.s),
    );
  }

  Widget _detail(IconData icon, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.s, color: primary),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 10.s, color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(bool isActive) {
    final color = isActive ? const Color(0xFF168A55) : grey;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 10.s,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMessageCard({required Widget child, double? height}) {
    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.all(18.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: child,
    );
  }

  String _displayValue(String value) {
    if (value.isEmpty) return value;
    return value
        .split('_')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  String _formatNumber(num value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }

  String _formatDate(DateTime value) {
    return '${value.year.toString().padLeft(4, '0')}-'
        '${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')}';
  }
}
