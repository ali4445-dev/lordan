import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lordan_v1/providers/auth_provider.dart';
import 'package:lordan_v1/screens/home_screen.dart';
import 'package:lordan_v1/service/user_storage_service.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../../../theme.dart';
import '../../../utils/components/pinput_style.dart';
import '../../../utils/components/primary_back_button.dart';
import '../../../utils/components/primary_button.dart';
import '../../../utils/components/gradient_backdrop.dart';

class OtpScreen extends StatefulWidget {
  static const String routeName = '/otp';

  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  final pinController = TextEditingController();
  bool hasError = false;

  // Timer
  late Timer _timer;
  int countDown = 2 * 60;
  int minutes = 2;
  int seconds = 00;

  void startTimer() {
    countDown = 2 * 60;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) return;
        setState(() {
          if (countDown > 0) {
            countDown--;
          } else {
            _timer.cancel();
          }
          minutes = countDown ~/ 60;
          seconds = countDown % 60;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    bool isDark = userProvider.themeMode == ThemeMode.dark;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: const PrimaryBackButton(),
        ),
        body: Stack(
          children: [
            GradientBackdrop(isDark: isDark),
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 24, right: 24, bottom: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // AuthAppbar(title: 'confirm_your_phone'),
                    const SizedBox(height: 24.0),
                    Text(
                      'Confirmation sent to your email',
                      style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 100.0),

                    ///  OTP autofill
                    Form(
                      key: _formKey,
                      child: Pinput(
                        controller: pinController,
                        length: 6,
                        // onCompleted: (pin) => print(pin),
                        forceErrorState: hasError,
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,

                        // smsRetriever: (!kIsWeb && Platform.isAndroid) ? smsRetrieverImpl : null,
                        onClipboardFound: (value) {
                          pinController.setText(value);
                        },
                        onCompleted: (pin) async {
                          bool success = await context
                              .read<AuthProvider>()
                              .verifyEmailOtp(pin);
                          if (success) {
                            await UserStorageService.createUserRecord();
                            UserStorageService.printAll();
                            context.go(HomeScreen.routeName);
                          }
                        },
                        isCursorAnimationEnabled: true,
                        defaultPinTheme: defaultPinTheme(context),
                        focusedPinTheme: focusedPinTheme(context),
                        errorPinTheme: defaultPinTheme(context).copyBorderWith(
                          border: Border.all(color: kRed400Color),
                        ),
                        showCursor: false,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    countDown == 0
                        ? Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: GestureDetector(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.refresh, size: 20.0),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    'Resend Code',
                                    style: theme.textTheme.labelLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                await context
                                    .read<AuthProvider>()
                                    .sendEmailOtp();
                                startTimer();
                              },
                            ),
                          )
                        : Text(
                            "0$minutes:${seconds > 9 ? '' : '0'}$seconds",
                            style: theme.textTheme.labelLarge
                                ?.copyWith(color: Colors.white),
                          ),
                    const Spacer(),
                    // PrimaryButton(
                    //   horizontalMargin: 0,
                    //   label: 'Confirm',
                    //   onPressed: () async {},
                    //   enabled: true,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
