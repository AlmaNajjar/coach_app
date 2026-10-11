import 'dart:ui' show ImageFilter;

import 'package:coach_app/core/di/dependency_injection.dart';
import 'package:coach_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:coach_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:coach_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:coach_app/features/home/presentation/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: const _LogInView(),
    );
  }
}

class _LogInView extends StatefulWidget {
  const _LogInView();

  @override
  State<_LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<_LogInView>
    with SingleTickerProviderStateMixin {
  // ───────────────────────── Design tokens ─────────────────────────
  static const _accent = Color(0xFF318CC7);
  static const _titleColor = Color(0xFF173B59);
  static const _mutedColor = Color(0xFF658196);

  // ─────────────────────── Layout (phones) ─────────────────────────
  /// Width of the glass panel relative to the screen width. Everything (fields,
  /// button, texts) lives INSIDE this panel, so the photo on the right stays
  /// clear. Smaller value = more of the photo, but narrower fields.
  static const _panelFactor = 0.57;

  /// Safety floor so the fields never get too narrow on small phones.
  static const _minPanelWidth = 224.0;

  /// Space between the content and the panel edges.
  static const _contentStartPadding = 16.0;
  static const _contentEndInsetFactor = 0.08; // of the panel width

  /// The panel has a fixed geometry, so the form caps system font scaling.
  /// Raise it (e.g. 1.15) if you prefer to follow the user's font size.
  static const _maxTextScale = 1.0;

  /// Which part of the photo stays visible. If the faces are still too close to
  /// the panel, move it towards the left, e.g. Alignment(0.4, 0).
  static const _backgroundAlignment = Alignment.centerRight;

  /// Frosted-glass blur behind the panel. Set to false on very low-end devices.
  static const _useGlassBlur = true;

  /// White glow along the panel edge that dissolves into the photo.
  /// _glowIntensity: brightness (0 = off, 1 = strong).
  /// _glowSpread: how far the glow reaches into the photo.
  static const _glowIntensity = 0.9;
  static const _glowSpread = 0.8;

  // ─────────────────────── Animation timeline ──────────────────────
  // Everything below is expressed in milliseconds on a single timeline, so the
  // order and the gaps are easy to read and tweak.
  // _timeScale: 1.0 = as written, 1.3 = 30% slower, 0.8 = 20% faster.
  static const _timeScale = 1.0;
  static const _baseTotalMs = 5000;
  static const _itemMs = 1100;

  static const _imageFadeMs = 900;
  static const _panelStartMs = 250;
  static const _panelMs = 1200;

  // Reveal order and start time (ms) of each element.
  static const _logo = 0;
  static const _title = 1;
  static const _subtitle = 2;
  static const _username = 3;
  static const _password = 4;
  static const _options = 5;
  static const _button = 6;
  static const _footer = 7;
  static const _tagline = 8;
  static const _stepStartsMs = <int>[
    700, // logo
    1350, // "Log In"
    1650, // "Stronger Every Day"
    2100, // username field
    2500, // password field
    2900, // remember me / forgot password
    3250, // button
    3600, // sign up
    3900, // tagline
  ];

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _obscurePassword = ValueNotifier<bool>(true);

  late final AnimationController _controller;
  late final Animation<double> _imageFade;
  late final Animation<double> _panel;
  late final List<Animation<double>> _steps;

  bool _started = false;
  bool _rememberMe = true;

  @override
  void initState() {
    super.initState();
    assert(_stepStartsMs.last + _itemMs <= _baseTotalMs);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (_baseTotalMs * _timeScale).round()),
    );
    _imageFade = _timeline(0, _imageFadeMs, curve: Curves.easeOut);
    _panel = _timeline(
      _panelStartMs,
      _panelMs,
      curve: Curves.easeOutCubic,
    );
    // Linear windows: easing (fade vs. motion) is applied inside _Reveal.
    _steps = List.generate(
      _stepStartsMs.length,
      (index) => _timeline(_stepStartsMs[index], _itemMs),
      growable: false,
    );
  }

  /// A window [startMs, startMs + durationMs] of the master timeline,
  /// mapped to 0 → 1.
  Animation<double> _timeline(
    int startMs,
    int durationMs, {
    Curve curve = Curves.linear,
  }) {
    final begin = startMs / _baseTotalMs;
    final end = ((startMs + durationMs) / _baseTotalMs)
        .clamp(0.0, 1.0)
        .toDouble();
    return _controller.drive(
      CurveTween(curve: Interval(begin, end, curve: curve)),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    // Respect the system "remove animations" accessibility setting.
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _obscurePassword.dispose();
    super.dispose();
  }

  // ───────────────────────── Business logic ─────────────────────────
  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().login(
      username: _usernameController.text,
      password: _passwordController.text,
    );
  }

  void _onForgotPassword() {
    // TODO: navigate to the forgot-password flow.
  }

  void _onSignUp() {
    // TODO: navigate to the sign-up flow.
  }

  // ───────────────────────────── UI ─────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(builder: (_) => HomeScreen()),
            (_) => false,
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFEAF3FB),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;
            final double panelWidth;
            final double startPadding;
            if (isWide) {
              panelWidth = (constraints.maxWidth * 0.44)
                  .clamp(420.0, 560.0)
                  .toDouble();
              startPadding = 48;
            } else {
              panelWidth = (constraints.maxWidth * _panelFactor)
                  .clamp(_minPanelWidth, double.infinity)
                  .toDouble();
              startPadding = _contentStartPadding;
            }
            final endPadding = panelWidth * _contentEndInsetFactor;

            return Stack(
              fit: StackFit.expand,
              children: [
                // Photo: fades in first, then the panel slides over it.
                RepaintBoundary(
                  child: FadeTransition(
                    opacity: _imageFade,
                    child: Image.asset(
                      'assets/image/log.jpg',
                      fit: BoxFit.cover,
                      alignment: _backgroundAlignment,
                    ),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x1A0F3B60),
                        Color(0x000F3B60),
                        Color(0x330F3B60),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: panelWidth,
                    height: double.infinity,
                    child: Stack(
                      // The glow is allowed to paint outside the panel bounds.
                      clipBehavior: Clip.none,
                      children: [
                        // Layer 1: the frosted-glass panel.
                        Positioned.fill(
                          child: FadeTransition(
                            opacity: _panel,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(-0.25, 0),
                                end: Offset.zero,
                              ).animate(_panel),
                              child: _buildGlassPanel(),
                            ),
                          ),
                        ),
                        // Layer 2: the content, fully inside the panel.
                        Positioned.fill(
                          child: _buildContent(startPadding, endPadding),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGlassPanel() {
    Widget surface = const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          // Opaque-ish on the left, fading towards the photo on the right.
          colors: [Color(0xF2F8FBFF), Color(0xDCF1F7FD), Color(0xB8E8F2FC)],
          stops: [0.0, 0.7, 1.0],
        ),
      ),
      child: SizedBox.expand(),
    );
    if (_useGlassBlur) {
      surface = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: surface,
      );
    }

    return RepaintBoundary(
      child: CustomPaint(
        foregroundPainter: const _PanelGlowPainter(
          intensity: _glowIntensity,
          spread: _glowSpread,
        ),
        child: PhysicalShape(
          clipper: const _PanelClipper(),
          clipBehavior: Clip.antiAlias,
          elevation: 12,
          color: Colors.transparent,
          shadowColor: const Color(0x4D0E3554),
          child: surface,
        ),
      ),
    );
  }

  Widget _buildContent(double startPadding, double endPadding) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SafeArea(
        right: false,
        child: LayoutBuilder(
          builder: (context, box) {
            final minHeight = (box.maxHeight - 48)
                .clamp(0.0, double.infinity)
                .toDouble();
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(startPadding, 24, endPadding, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minHeight),
                child: Center(
                  child: MediaQuery.withClampedTextScaling(
                    maxScaleFactor: _maxTextScale,
                    child: SizedBox(
                      width: double.infinity,
                      child: _buildForm(),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1) Logo
          _Reveal(
            animation: _steps[_logo],
            offset: const Offset(0, 0.12),
            scaleFrom: 0.82,
            child: Center(
              child: Image.asset(
                'assets/image/splash_log.png',
                width: 160,
                height: 112,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 28),

          // 2) Title + subtitle
          _Reveal(
            animation: _steps[_title],
            offset: const Offset(-0.12, 0),
            child: const Text(
              'Log In',
              style: TextStyle(
                color: _titleColor,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 4),
          _Reveal(
            animation: _steps[_subtitle],
            offset: const Offset(-0.12, 0),
            child: const Text(
              'Stronger Every Day',
              style: TextStyle(
                color: _mutedColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 26),

          // 3) Fields
          _Reveal(
            animation: _steps[_username],
            offset: const Offset(0, 0.55),
            child: CustomTextField(
              controller: _usernameController,
              hintText: 'Email or Phone Number',
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.username],
              textInputAction: TextInputAction.next,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter your email or phone number.'
                  : null,
            ),
          ),
          const SizedBox(height: 14),
          _Reveal(
            animation: _steps[_password],
            offset: const Offset(0, 0.55),
            child: _buildPasswordField(),
          ),

          // Error message (animated height so the layout doesn't jump).
          BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (previous, current) =>
                previous.status != current.status ||
                previous.errorMessage != current.errorMessage,
            builder: (context, state) {
              final hasError = state.status == AuthStatus.failure;
              return AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                alignment: Alignment.topCenter,
                child: hasError
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 2),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            state.errorMessage ?? 'Unable to sign in.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFB33D3D),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(width: double.infinity, height: 4),
              );
            },
          ),
          const SizedBox(height: 10),

          // 4) Remember me / Forgot password
          _Reveal(
            animation: _steps[_options],
            offset: const Offset(0, 0.6),
            child: _buildOptionsRow(),
          ),
          const SizedBox(height: 18),

          // 5) Button
          _Reveal(
            animation: _steps[_button],
            offset: const Offset(0, 0.6),
            child: _buildSubmitButton(),
          ),
          const SizedBox(height: 16),

          // 6) Sign up
          _Reveal(
            animation: _steps[_footer],
            offset: const Offset(0, 0.6),
            child: _buildFooter(),
          ),
          const SizedBox(height: 30),

          // 7) Tagline
          _Reveal(
            animation: _steps[_tagline],
            offset: const Offset(-0.08, 0.2),
            child: _buildTagline(),
          ),
        ],
      ),
    );
  }

  /// Password field with a show/hide toggle. Only this field rebuilds when the
  /// visibility changes.
  Widget _buildPasswordField() {
    return ValueListenableBuilder<bool>(
      valueListenable: _obscurePassword,
      builder: (context, obscure, _) => CustomTextField(
        controller: _passwordController,
        hintText: 'Password',
        prefixIcon: Icons.lock_outline_rounded,
        obscureText: obscure,
        suffix: IconButton(
          onPressed: () => _obscurePassword.value = !obscure,
          tooltip: obscure ? 'Show password' : 'Hide password',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 36, height: 36),
          iconSize: 20,
          color: _mutedColor,
          icon: Icon(
            obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
        autofillHints: const [AutofillHints.password],
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        validator: (value) =>
            value == null || value.isEmpty ? 'Enter your password.' : null,
      ),
    );
  }

  /// Each side scales down (never truncates) if the panel is narrow.
  Widget _buildOptionsRow() {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _rememberMe = !_rememberMe),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (value) =>
                            setState(() => _rememberMe = value ?? false),
                        shape: const CircleBorder(),
                        activeColor: _accent,
                        side: const BorderSide(
                          color: Color(0xFF9DB6C9),
                          width: 1.5,
                        ),
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Remember me',
                      style: TextStyle(
                        color: _mutedColor,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: TextButton(
                onPressed: _onForgotPassword,
                style: TextButton.styleFrom(
                  foregroundColor: _accent,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) => SizedBox(
        height: 54,
        width: double.infinity,
        child: FilledButton(
          onPressed: state.isSubmitting ? null : _submit,
          style: FilledButton.styleFrom(
            backgroundColor: _accent,
            disabledBackgroundColor: const Color(0xFF8DBAD6),
            shape: const StadiumBorder(),
            elevation: 3,
            shadowColor: const Color(0x55318CC7),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: state.isSubmitting
                ? const SizedBox(
                    key: ValueKey('loading'),
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Row(
                    key: ValueKey('label'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            'Don\'t have an account? ',
            style: TextStyle(color: _mutedColor, fontSize: 12.5),
          ),
          TextButton(
            onPressed: _onSignUp,
            style: TextButton.styleFrom(
              foregroundColor: _accent,
              padding: const EdgeInsets.symmetric(vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Sign Up',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150),
          child: Text(
            'Small steps make big changes',
            style: TextStyle(
              color: Color(0xFF7C93A8),
              fontSize: 18,
              height: 1.3,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 32,
          height: 2,
          decoration: BoxDecoration(
            color: _accent.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

/// Reveal driven by a linear 0 → 1 window of the master timeline.
///
/// The fade finishes earlier than the movement (first 70% of the window), and
/// the movement decelerates smoothly. This is what makes the entrance feel
/// fluid rather than mechanical.
class _Reveal extends StatelessWidget {
  const _Reveal({
    required this.animation,
    required this.child,
    this.offset = const Offset(0, 0.35),
    this.scaleFrom,
  });

  final Animation<double> animation;
  final Widget child;
  final Offset offset;
  final double? scaleFrom;

  static final _fadeCurve = CurveTween(
    curve: const Interval(0, 0.7, curve: Curves.easeOut),
  );
  static final _moveCurve = CurveTween(curve: Curves.easeOutCubic);

  @override
  Widget build(BuildContext context) {
    final move = animation.drive(_moveCurve);

    Widget result = child;
    if (scaleFrom != null) {
      result = ScaleTransition(
        scale: move.drive(Tween<double>(begin: scaleFrom!, end: 1)),
        child: result,
      );
    }
    return FadeTransition(
      opacity: animation.drive(_fadeCurve),
      child: SlideTransition(
        position: move.drive(Tween<Offset>(begin: offset, end: Offset.zero)),
        child: result,
      ),
    );
  }
}

// ───────────────────────── Panel geometry ─────────────────────────

/// The curved right edge of the panel (nearly vertical, with a soft bulge).
Path _panelEdge(Size size) {
  final w = size.width;
  final h = size.height;
  return Path()
    ..moveTo(w * 0.95, 0)
    ..cubicTo(w * 1.01, h * 0.20, w * 1.01, h * 0.60, w * 0.94, h);
}

Path _panelShape(Size size) {
  return Path()
    ..moveTo(0, 0)
    ..extendWithPath(_panelEdge(size), Offset.zero)
    ..lineTo(0, size.height)
    ..close();
}

class _PanelClipper extends CustomClipper<Path> {
  const _PanelClipper();

  @override
  Path getClip(Size size) => _panelShape(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// The panel edge, extended past the top and bottom of the screen so the glow
/// keeps the same intensity all the way to both ends.
Path _panelGlowPath(Size size) {
  final w = size.width;
  final h = size.height;
  return Path()
    ..moveTo(w * 0.95, -120)
    ..lineTo(w * 0.95, 0)
    ..extendWithPath(_panelEdge(size), Offset.zero)
    ..lineTo(w * 0.94, h + 120);
}

/// Soft white glow along the curved edge. It is built from three blurred
/// strokes (wide haze, mid glow, tight core) so the edge fades gradually into
/// the photo instead of ending in a hard line.
class _PanelGlowPainter extends CustomPainter {
  const _PanelGlowPainter({this.intensity = 1.0, this.spread = 1.0});

  final double intensity;
  final double spread;

  // Ordered from the widest/faintest to the tightest/brightest.
  static const _layers = <({double width, double sigma, double alpha})>[
    (width: 56, sigma: 26, alpha: 0.26),
    (width: 26, sigma: 12, alpha: 0.42),
    (width: 8, sigma: 4, alpha: 0.55),
  ];

  // Pushes the glow slightly towards the photo.
  static const _shift = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity <= 0) return;
    final path = _panelGlowPath(size).shift(const Offset(_shift, 0));

    for (final layer in _layers) {
      final alpha = (layer.alpha * intensity).clamp(0.0, 1.0).toDouble();
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = layer.width * spread
          ..color = Colors.white.withValues(alpha: alpha)
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            layer.sigma * spread,
          ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PanelGlowPainter oldDelegate) =>
      oldDelegate.intensity != intensity || oldDelegate.spread != spread;
}