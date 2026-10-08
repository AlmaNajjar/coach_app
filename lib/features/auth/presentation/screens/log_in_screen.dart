import 'package:coach_app/core/di/dependency_injection.dart';
import 'package:coach_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:coach_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:coach_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:coach_app/features/dashboard/presentation/screens/coach_home_screen.dart';
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

class _LogInViewState extends State<_LogInView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().login(
      username: _usernameController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final panelTop = size.height * 0.505;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/image/splash.jpg', fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x4DDFEEFA),
                  Color(0x12FFFFFF),
                  Color(0x003D82AF),
                ],
                stops: [0, 0.48, 1],
              ),
            ),
          ),
          Positioned(
            top: panelTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildLoginPanel(),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + size.height * 0.018,
            left: 20,
            right: 20,
            bottom: size.height - panelTop + 8,
            child: _buildWelcomeHeader(),
          ),
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == AuthStatus.success) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(
                    builder: (_) => const CoachHomeScreen(),
                  ),
                  (_) => false,
                );
              }
            },
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          'assets/image/splash_log.png',
          width: 174,
          height: 122,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 4),
        const Text(
          'Welcome Back',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF173B59),
            fontSize: 25,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          'Log in to continue your journey',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF658196), fontSize: 14),
        ),
        const SizedBox(height: 10),
        Container(
          width: 48,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFF378DC4),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginPanel() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF9FF).withValues(alpha: 0.96),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(42)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2637637F),
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 18),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: (constraints.maxHeight - 50)
                      .clamp(0, double.infinity)
                      .toDouble(),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        controller: _usernameController,
                        hintText: 'Email or Phone Number',
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.username],
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Enter your email or phone number.'
                            : null,
                      ),
                      const SizedBox(height: 13),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        autofillHints: const [AutofillHints.password],
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter your password.'
                            : null,
                        suffix: IconButton(
                          tooltip: _obscurePassword
                              ? 'Show password'
                              : 'Hide password',
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF7891A2),
                            size: 20,
                          ),
                        ),
                      ),
                      BlocBuilder<AuthCubit, AuthState>(
                        buildWhen: (previous, current) =>
                            previous.status != current.status ||
                            previous.errorMessage != current.errorMessage,
                        builder: (context, state) {
                          if (state.status != AuthStatus.failure) {
                            return const SizedBox(height: 22);
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 10),
                            child: Text(
                              state.errorMessage ?? 'Unable to sign in.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFB33D3D),
                                fontSize: 13,
                              ),
                            ),
                          );
                        },
                      ),
                      BlocBuilder<AuthCubit, AuthState>(
                        buildWhen: (previous, current) =>
                            previous.status != current.status,
                        builder: (context, state) => SizedBox(
                          height: 52,
                          child: FilledButton(
                            onPressed: state.isSubmitting ? null : _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF388FC7),
                              disabledBackgroundColor: const Color(0xFF8DBAD6),
                              shape: const StadiumBorder(),
                              elevation: 2,
                            ),
                            child: state.isSubmitting
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Log In',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Your goals. Our plan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF66869A),
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
