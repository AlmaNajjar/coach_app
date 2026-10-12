import 'dart:ui';

import 'package:coach_app/core/helper/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CoachBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CoachBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color _primary = Color(0xFF3B8FE3);
  static const Color _primaryDark = Color(0xFF2B73CC);
  static const Color _inactive = Color(0xFF8A9BB5);

  static const List<_NavItem> _items = [
    _NavItem('Home', Icons.home_rounded, Icons.home_rounded),
    _NavItem('Clients', Icons.people_outline_rounded, Icons.people_rounded),
    _NavItem(
      'Schedule',
      Icons.calendar_month_outlined,
      Icons.calendar_month_rounded,
    ),
    _NavItem('Account', Icons.person_outline_rounded, Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final visualIndex = isRtl ? _items.length - 1 - currentIndex : currentIndex;

    final double barHeight = 70.h;
    final double bubbleSize = 42.h;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, bottomInset + 10.h),
      child: SizedBox(
        height: barHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / _items.length;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // ───────── Glass background ─────────
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B8FE3).withOpacity(0.18),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withOpacity(0.92),
                                Colors.white.withOpacity(0.78),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.9),
                              width: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ───────── Sliding bubble ─────────
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 550),
                  curve: Curves.easeOutBack,
                  left: visualIndex * itemWidth + (itemWidth - bubbleSize) / 2,
                  top: 6.h,
                  width: bubbleSize,
                  height: bubbleSize,
                  child: _Bubble(
                    index: currentIndex,
                    icon: _items[currentIndex].activeIcon,
                    size: bubbleSize,
                  ),
                ),

                // ───────── Items ─────────
                Positioned.fill(
                  child: Row(
                    children: List.generate(_items.length, (i) {
                      return Expanded(
                        child: _NavButton(
                          item: _items[i],
                          selected: i == currentIndex,
                          iconAreaHeight: bubbleSize,
                          topGap: 6.h,          // نفس قيمة top فوق
                          labelBottom: 8.h,
                          onTap: () {
                            if (i == currentIndex) return;
                            HapticFeedback.selectionClick();
                            onTap(i);
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  const _NavItem(this.label, this.icon, this.activeIcon);
}

// ═════════════════════════════════════════════════════════════
class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final double iconAreaHeight;
  final double topGap;
  final double labelBottom;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.selected,
    required this.iconAreaHeight,
    required this.topGap,
    required this.labelBottom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        children: [
          // ───── الأيقونة ─────
          Positioned(
            top: topGap,
            left: 0,
            right: 0,
            height: iconAreaHeight,
            child: Center(
              child: Transform.translate(
                // نزّلت الأيقونة شوي عشان تقرب من الليبل (غيّر 3 كما بدك)
                offset: Offset(0, 3.h),
                child: AnimatedScale(
                  scale: selected ? 0.3 : 1,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  child: AnimatedOpacity(
                    opacity: selected ? 0 : 1,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      item.icon,
                      size: 22.h,
                      color: CoachBottomNavBar._inactive,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ───── الليبل ─────
          Positioned(
            left: 0,
            right: 0,
            bottom: labelBottom,
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                style: TextStyle(
                  fontSize: selected ? 11.5 : 11,
                  height: 1.1,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? CoachBottomNavBar._primary
                      : CoachBottomNavBar._inactive,
                  letterSpacing: selected ? 0.2 : 0,
                ),
                child: Text(item.label),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
class _Bubble extends StatelessWidget {
  final int index;
  final IconData icon;
  final double size;

  const _Bubble({
    required this.index,
    required this.icon,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // حلقة النبض عند كل تغيير
        Positioned.fill(
          child: TweenAnimationBuilder<double>(
            key: ValueKey('pulse_$index'),
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, t, _) {
              return Opacity(
                opacity: (1 - t) * 0.45,
                child: Transform.scale(
                  scale: 1 + t * 0.9,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: CoachBottomNavBar._primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // الدائرة الأساسية
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF58A8F2),
                CoachBottomNavBar._primaryDark,
              ],
            ),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: CoachBottomNavBar._primary.withOpacity(0.45),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, anim) => RotationTransition(
              turns: Tween<double>(begin: -0.25, end: 0).animate(anim),
              child: ScaleTransition(
                scale: anim,
                child: FadeTransition(opacity: anim, child: child),
              ),
            ),
            child: Icon(
              icon,
              key: ValueKey(icon),
              color: Colors.white,
              size: 22.h,
            ),
          ),
        ),
      ],
    );
  }
}