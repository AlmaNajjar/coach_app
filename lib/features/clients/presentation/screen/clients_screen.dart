import 'dart:async';
import 'package:coach_app/core/di/dependency_injection.dart';
import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:coach_app/features/clients/presentation/cubit/clients_cubit.dart';
import 'package:coach_app/features/clients/presentation/cubit/clients_state.dart';
import 'package:coach_app/features/clients/presentation/widgets/buildfilterchips.dart';
import 'package:coach_app/features/clients/presentation/widgets/buildheader.dart';
import 'package:coach_app/features/clients/presentation/widgets/buildsearchandfilter.dart';
import 'package:coach_app/features/clients/presentation/widgets/client_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ClientsCubit>()..loadClients(),
      child: const _ClientsView(),
    );
  }
}

class _ClientsView extends StatefulWidget {
  const _ClientsView();

  @override
  State<_ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<_ClientsView> {
  int _selectedFilter = 0;
  String _searchQuery = '';
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  // تحويل رقم الكبسولة إلى حالة يفهمها الـ API
  String? _mapFilterToStatus(int index) {
    switch (index) {
      case 1:
        return 'active';
      case 2:
        return 'expiring_soon';
      case 3:
        return 'finished';
      default:
        return null; // All
    }
  }

  void _onFilterSelected(int index) {
    setState(() {
      _selectedFilter = index;
    });
    context.read<ClientsCubit>().loadClients(
      status: _mapFilterToStatus(index),
      search: _searchQuery,
    );
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _debounceTimer?.cancel();
    // ننتظر 400ms بعد توقف المستخدم عن الكتابة قبل إرسال الطلب
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        context.read<ClientsCubit>().loadClients(
          status: _mapFilterToStatus(_selectedFilter),
          search: _searchQuery,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // الخلفية
          Positioned.fill(
            child: Image.asset(
              'assets/image/splash_ground.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  const Buildheader(),
                  SizedBox(height: 16.h),
                  _buildTitleSection(),
                  SizedBox(height: 16.h),
                  Buildsearchandfilter(onSearchChanged: _onSearchChanged),
                  SizedBox(height: 14.h),
                  Buildfilterchips(
                    selectedIndex: _selectedFilter,
                    onSelected: _onFilterSelected,
                  ),
                  SizedBox(height: 16.h),
                  // قائمة المشتركين الحقيقية
                  Expanded(child: _buildClientsContent()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // العنوان والوصف والخط الأزرق
  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Clients',
          style: TextStyle(
            fontSize: 24.s,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Text(
              'Stronger Together',
              style: TextStyle(
                fontSize: 12.s,
                color: grey,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 25.w,
              height: 2.h,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.6),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // محتوى قائمة المتدربين (تحميل، خطأ، نجاح)
  Widget _buildClientsContent() {
    return BlocBuilder<ClientsCubit, ClientsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: CircularProgressIndicator(color: primary));
        }

        if (state.isFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                  size: 40.s,
                ),
                SizedBox(height: 8.h),
                Text(
                  state.errorMessage ?? 'Failed to load clients',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor, fontSize: 13.s),
                ),
                SizedBox(height: 12.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<ClientsCubit>().loadClients(
                      status: _mapFilterToStatus(_selectedFilter),
                      search: _searchQuery,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text('Retry', style: TextStyle(color: white)),
                ),
              ],
            ),
          );
        }

        if (state.clients.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline_rounded,
                  size: 48.s,
                  color: grey.withOpacity(0.5),
                ),
                SizedBox(height: 8.h),
                Text(
                  'No clients found',
                  style: TextStyle(color: grey, fontSize: 14.s),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: primary,
          onRefresh: () async {
            await context.read<ClientsCubit>().loadClients(
              status: _mapFilterToStatus(_selectedFilter),
              search: _searchQuery,
            );
          },
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 100.h),
            itemCount: state.clients.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final client = state.clients[index];
              return ClientCard(
                name: client.name,
                programName: client.planName,
                status: client.status,
                progress: client.progress,
                photoUrl: client.photoUrl,
                onTap: () {
                  // هنا سنربط الانتقال لصفحة تفاصيل المتدرب بالـ client.id
                },
              );
            },
          ),
        );
      },
    );
  }
}
