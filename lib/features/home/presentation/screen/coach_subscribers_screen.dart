import 'package:coach_app/core/helper/responsive.dart';
import 'package:coach_app/features/home/domain/entities/coach_subscriber.dart';
import 'package:coach_app/features/home/presentation/cubit/coach_subscribers_cubit.dart';
import 'package:coach_app/features/home/presentation/cubit/coach_subscribers_state.dart';
import 'package:coach_app/core/helper/subscriber_formatters.dart';
import 'package:coach_app/features/home/presentation/widgets/subscriber_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachSubscribersScreen extends StatefulWidget {
  const CoachSubscribersScreen({super.key});

  /// بيمرّر نفس الـ Cubit الموجود بالهوم
  static Future<void> open(BuildContext context) {
    final cubit = context.read<CoachSubscribersCubit>();
    return Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 380),
        pageBuilder: (_, __, ___) => BlocProvider.value(
          value: cubit,
          child: const CoachSubscribersScreen(),
        ),
        transitionsBuilder: (_, anim, __, child) {
          final curved =
              CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  State<CoachSubscribersScreen> createState() => _CoachSubscribersScreenState();
}

class _FilterOption {
  const _FilterOption(this.status, this.label);
  final SubscriptionStatus? status; // null = All
  final String label;
}

class _CoachSubscribersScreenState extends State<CoachSubscribersScreen> {
  static const Color _primary = Color(0xFF3B8FE3);
  static const Color _navy = Color(0xFF1B2D4F);
  static const Color _muted = Color(0xFF93A3BC);

  static const _filters = [
    _FilterOption(null, 'All'),
    _FilterOption(SubscriptionStatus.active, 'Active'),
    _FilterOption(SubscriptionStatus.pending, 'Pending'),
    _FilterOption(SubscriptionStatus.expired, 'Expired'),
    _FilterOption(SubscriptionStatus.cancelled, 'Cancelled'),
  ];

  final _searchController = TextEditingController();
  String _query = '';
  SubscriptionStatus? _filter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CoachSubscriber> _apply(List<CoachSubscriber> all) {
    final q = _query.trim().toLowerCase();
    return all.where((s) {
      if (_filter != null && s.status != _filter) return false;
      if (q.isEmpty) return true;
      return s.memberName.toLowerCase().contains(q) ||
          (s.memberNumber ?? '').toLowerCase().contains(q) ||
          (s.phone ?? '').contains(q) ||
          (s.planName ?? '').toLowerCase().contains(q);
    }).toList();
  }

  int _count(List<CoachSubscriber> all, SubscriptionStatus? s) =>
      s == null ? all.length : all.where((e) => e.status == s).length;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return MediaQuery(
      data: mq.copyWith(textScaler: mq.textScaler.clamp(maxScaleFactor: 1.0)),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/image/splash_ground.jpg",
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                child: Column(
                  children: [
                    _buildTopBar(context),
                    SizedBox(height: 14.h),
                    _buildSearchField(),
                    SizedBox(height: 12.h),
                    BlocBuilder<CoachSubscribersCubit, CoachSubscribersState>(
                      buildWhen: (p, c) => p.subscribers != c.subscribers,
                      builder: (_, state) => _buildChips(state.subscribers),
                    ),
                    SizedBox(height: 12.h),
                    Expanded(child: _buildList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 40.h,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.94),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _primary.withOpacity(0.10),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                size: 17.h, color: _navy),
          ),
        ),
        SizedBox(width: 14.w),
        const Text(
          'My Subscribers',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _navy,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 46.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v),
        style: const TextStyle(fontSize: 14, color: _navy),
        decoration: InputDecoration(
          hintText: 'Search name, number, phone or plan',
          hintStyle: const TextStyle(fontSize: 13, color: _muted),
          prefixIcon: Icon(Icons.search_rounded, size: 21.h, color: _muted),
          suffixIcon: _query.isEmpty
              ? null
              : GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                  child: Icon(Icons.close_rounded, size: 19.h, color: _muted),
                ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 13.h),
        ),
      ),
    );
  }

  Widget _buildChips(List<CoachSubscriber> all) {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final f = _filters[i];
          final selected = _filter == f.status;
          return GestureDetector(
            onTap: () => setState(() => _filter = f.status),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? _primary : Colors.white.withOpacity(0.94),
                borderRadius: BorderRadius.circular(18),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: _primary.withOpacity(0.28),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : const [],
              ),
              child: Text(
                '${f.label} ${_count(all, f.status)}',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : _muted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildList() {
    return BlocBuilder<CoachSubscribersCubit, CoachSubscribersState>(
      builder: (context, state) {
        if (state.isFirstLoad) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2.5),
          );
        }

        final items = _apply(state.subscribers);

        return RefreshIndicator(
          color: _primary,
          onRefresh: () =>
              context.read<CoachSubscribersCubit>().load(silent: true),
          child: items.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 80.h),
                    Icon(Icons.search_off_rounded,
                        size: 44.h, color: const Color(0xFFB9C7DB)),
                    SizedBox(height: 10.h),
                    Text(
                      state.status == CoachSubscribersStatus.failure
                          ? (state.errorMessage ?? 'Something went wrong.')
                          : 'No subscribers found',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: _muted),
                    ),
                  ],
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: EdgeInsets.only(bottom: 24.h),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (_, i) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.94),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SubscriberTile(
                      subscriber: items[i],
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      onTap: () => _showDetails(items[i]),
                    ),
                  ),
                ),
        );
      },
    );
  }

  void _showDetails(CoachSubscriber s) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DetailsSheet(subscriber: s),
    );
  }
}

// ═════════════════════════════════════════════════════════════
class _DetailsSheet extends StatelessWidget {
  const _DetailsSheet({required this.subscriber});

  final CoachSubscriber subscriber;

  @override
  Widget build(BuildContext context) {
    final s = subscriber;
    final period = (s.startDate == null || s.endDate == null)
        ? '—'
        : '${SubscriberFormatters.date(s.startDate!)} → ${SubscriberFormatters.date(s.endDate!)}';

    return Container(
      padding: EdgeInsets.fromLTRB(
        20.w,
        12.h,
        20.w,
        24.h + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE1E9F4),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 16.h),
          SubscriberTile(subscriber: s),
          SizedBox(height: 14.h),
          const Divider(height: 1, color: Color(0xFFEEF3FA)),
          SizedBox(height: 8.h),
          _row('Member No.', s.memberNumber ?? '—'),
          _row('Phone', s.phone ?? '—'),
          _row('Period', period),
          _row('Total', SubscriberFormatters.money(s.totalAmount, s.currency)),
          _row('Paid', SubscriberFormatters.money(s.paidAmount, s.currency)),
          _row(
            'Remaining',
            SubscriberFormatters.money(s.remainingAmount, s.currency),
            valueColor: s.hasRemaining
                ? const Color(0xFFE8890C)
                : const Color(0xFF1E9E5A),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF93A3BC)),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: valueColor ?? const Color(0xFF1B2D4F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}