import 'package:coach_app/core/helper/responsive.dart';
import 'package:coach_app/features/home/presentation/cubit/coach_subscribers_cubit.dart';
import 'package:coach_app/features/home/presentation/cubit/coach_subscribers_state.dart';
import 'package:coach_app/features/home/presentation/screen/coach_subscribers_screen.dart';
import 'package:coach_app/features/home/presentation/widgets/subscriber_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachSubscribersCard extends StatelessWidget {
  const CoachSubscribersCard({super.key});

  static const Color _primary = Color(0xFF3B8FE3);
  static const Color _navy = Color(0xFF1B2D4F);
  static const Color _muted = Color(0xFF93A3BC);
  static const int _previewCount = 4;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return MediaQuery(
      data: mq.copyWith(textScaler: mq.textScaler.clamp(maxScaleFactor: 1.0)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 14.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.94),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: _primary.withOpacity(0.08),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: BlocBuilder<CoachSubscribersCubit, CoachSubscribersState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Header(state: state),
                SizedBox(height: 12.h),
                const _FadingDivider(),
                SizedBox(height: 6.h),
                AnimatedSize(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    child: _buildBody(context, state),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CoachSubscribersState state) {
    if (state.isFirstLoad) {
      return const _SkeletonList(key: ValueKey('loading'));
    }

    if (state.status == CoachSubscribersStatus.failure &&
        state.subscribers.isEmpty) {
      return _ErrorView(
        key: const ValueKey('error'),
        message: state.errorMessage ?? 'Something went wrong.',
        onRetry: () => context.read<CoachSubscribersCubit>().load(),
      );
    }

    if (state.subscribers.isEmpty) {
      return const _EmptyView(key: ValueKey('empty'));
    }

    final preview = state.subscribers.take(_previewCount).toList();

    return Column(
      key: const ValueKey('content'),
      children: [
        for (var i = 0; i < preview.length; i++) ...[
          _Reveal(
            index: i,
            child: SubscriberTile(
              subscriber: preview[i],
              padding: EdgeInsets.symmetric(vertical: 10.h),
              onTap: () => CoachSubscribersScreen.open(context),
            ),
          ),
          if (i != preview.length - 1)
            Container(
              height: 1,
              margin: EdgeInsets.only(left: 56.w),
              color: const Color(0xFFEEF3FA),
            ),
        ],
        SizedBox(height: 8.h),
        _ViewAllButton(
          count: state.subscribers.length,
          onTap: () => CoachSubscribersScreen.open(context),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════
class _Header extends StatelessWidget {
  const _Header({required this.state});

  final CoachSubscribersState state;

  @override
  Widget build(BuildContext context) {
    final loaded = state.status == CoachSubscribersStatus.success;

    return Row(
      children: [
        Icon(Icons.groups_rounded,
            size: 20.h, color: CoachSubscribersCard._primary),
        SizedBox(width: 10.w),
        const Text(
          'My Subscribers',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: CoachSubscribersCard._navy,
            letterSpacing: 0.1,
          ),
        ),
        const Spacer(),
        if (loaded)
          Text(
            '${state.activeSubscribers} active · ${state.totalSubscribers} total',
            style: const TextStyle(
              fontSize: 12,
              color: CoachSubscribersCard._muted,
            ),
          ),
      ],
    );
  }
}

class _FadingDivider extends StatelessWidget {
  const _FadingDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x00F1F6FC), Color(0xFFE4EDF8), Color(0x00F1F6FC)],
        ),
      ),
    );
  }
}

/// ظهور متتالي للصفوف (Fade + Slide)
class _Reveal extends StatelessWidget {
  const _Reveal({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 380 + index * 110),
      curve: Curves.easeOutCubic,
      builder: (_, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 14),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

class _ViewAllButton extends StatefulWidget {
  const _ViewAllButton({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  State<_ViewAllButton> createState() => _ViewAllButtonState();
}

class _ViewAllButtonState extends State<_ViewAllButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 42.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F6FC),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'View all (${widget.count})',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: CoachSubscribersCard._primary,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(Icons.arrow_forward_rounded,
                  size: 16.h, color: CoachSubscribersCard._primary),
            ],
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
class _SkeletonList extends StatefulWidget {
  const _SkeletonList({super.key});

  @override
  State<_SkeletonList> createState() => _SkeletonListState();
}

class _SkeletonListState extends State<_SkeletonList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _bar(double w, double h) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: const Color(0xFFE9F0F8),
          borderRadius: BorderRadius.circular(8),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 1).animate(_controller),
      child: Column(
        children: List.generate(3, (_) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              children: [
                Container(
                  width: 44.h,
                  height: 44.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE9F0F8),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bar(120.w, 12.h),
                      SizedBox(height: 8.h),
                      _bar(80.w, 10.h),
                    ],
                  ),
                ),
                _bar(54.w, 22.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        children: [
          Icon(Icons.group_off_rounded,
              size: 34.h, color: const Color(0xFFB9C7DB)),
          SizedBox(height: 10.h),
          const Text(
            'No subscribers yet',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: CoachSubscribersCard._muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          Icon(Icons.cloud_off_rounded,
              size: 32.h, color: const Color(0xFFB9C7DB)),
          SizedBox(height: 8.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              color: CoachSubscribersCard._muted,
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F6FC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: CoachSubscribersCard._primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}