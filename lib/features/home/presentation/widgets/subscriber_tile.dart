import 'package:coach_app/core/helper/responsive.dart';
import 'package:coach_app/features/home/domain/entities/coach_subscriber.dart';
import 'package:coach_app/core/helper/subscriber_formatters.dart';
import 'package:flutter/material.dart';

class SubscriberTile extends StatefulWidget {
  const SubscriberTile({
    super.key,
    required this.subscriber,
    this.onTap,
    this.padding = EdgeInsets.zero,
  });

  final CoachSubscriber subscriber;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  State<SubscriberTile> createState() => _SubscriberTileState();
}

class _SubscriberTileState extends State<SubscriberTile> {
  static const Color _primary = Color(0xFF3B8FE3);
  static const Color _navy = Color(0xFF1B2D4F);
  static const Color _muted = Color(0xFF93A3BC);

  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.subscriber;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        child: Padding(
          padding: widget.padding,
          child: Row(
            children: [
              _buildAvatar(s),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.memberName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _navy,
                      ),
                    ),
                    if (s.planName != null) ...[
                      SizedBox(height: 3.h),
                      Text(
                        s.planName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: _muted),
                      ),
                    ],
                    if (s.endDate != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        'Ends ${SubscriberFormatters.date(s.endDate!)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: _muted.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SubscriptionStatusChip(status: s.status),
                  if (s.hasRemaining) ...[
                    SizedBox(height: 6.h),
                    Text(
                      'Due ${SubscriberFormatters.money(s.remainingAmount, s.currency)}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE8890C),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(CoachSubscriber s) {
    final size = 44.h;
    final initials = Center(
      child: Text(
        SubscriberFormatters.initials(s.memberName),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _primary,
        ),
      ),
    );

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFEAF3FC),
      ),
      child: s.photoUrl == null
          ? initials
          : Image.network(
              s.photoUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => initials,
            ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
class SubscriptionStatusChip extends StatelessWidget {
  const SubscriptionStatusChip({super.key, required this.status});

  final SubscriptionStatus status;

  @override
  Widget build(BuildContext context) {
    final (String label, Color fg, Color bg) = switch (status) {
      SubscriptionStatus.active => (
          'Active', const Color(0xFF1E9E5A), const Color(0xFFE6F6EE)),
      SubscriptionStatus.pending => (
          'Pending', const Color(0xFFE8890C), const Color(0xFFFFF2E0)),
      SubscriptionStatus.expired => (
          'Expired', const Color(0xFF7C8BA3), const Color(0xFFEEF2F7)),
      SubscriptionStatus.cancelled => (
          'Cancelled', const Color(0xFFD64545), const Color(0xFFFDEAEA)),
      SubscriptionStatus.unknown => (
          '—', const Color(0xFF7C8BA3), const Color(0xFFEEF2F7)),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}