// Dart imports:
import 'dart:async';
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:after_layout/after_layout.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/helpers/app_size.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/routes/route_names.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/auth/presentation/providers/ask_reset_password_provider.dart';
import 'package:law_app/features/auth/presentation/widgets/secondary_header.dart';
import 'package:law_app/features/shared/providers/generated_providers/count_down_timer_provider.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

class OtpPage extends ConsumerStatefulWidget {
  final String email;
  final String otp;

  const OtpPage({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> with AfterLayoutMixin<OtpPage> {
  late final ValueNotifier<bool> isFilled;

  final formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();

    isFilled = ValueNotifier(false);
  }

  @override
  void dispose() {
    super.dispose();

    isFilled.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fieldSize = (AppSize.getAppWidth(context) / 4) - 40;

    final timer = ref.watch(
      CountDownTimerProvider(initialValue: 60),
    );

    final value = timer.when<int?>(
      data: (value) => value,
      error: (_, __) => null,
      loading: () => null,
    );

    final isDone = value == 0;

    ref.listen(askResetPasswordProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          navigatorKey.currentState!.pop();

          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet();
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        data: (data) {
          if (data != null) {
            ref.invalidate(countDownTimerProvider);

            context.showBanner(
              message: 'Kode OTP telah terkirim ke email ${widget.email}',
              type: BannerType.success,
            );
          }
        },
      );
    });

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        context.showConfirmDialog(
          title: 'Konfirmasi',
          message: 'Anda yakin ingin membatalkan proses ini?',
          onPressedPrimaryButton: () {
            context.back();
            navigatorKey.currentState!.pop();
          },
        );
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SecondaryHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SvgAsset(
                        assetPath: AssetPath.getVector('email_otp.svg'),
                        width: 200,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Masukkan Kode\nOTP!',
                      style: textTheme.displaySmall!.copyWith(
                        color: primaryColor,
                        height: 0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: textTheme.bodyMedium!.copyWith(
                          color: secondaryTextColor,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Kode OTP telah terkirim ke email\t',
                          ),
                          TextSpan(
                            text: widget.email,
                            style: textTheme.titleSmall!.copyWith(
                              color: primaryColor,
                            ),
                          ),
                          const TextSpan(
                            text: '. Masukkan kode tersebut untuk melanjutkan.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    FormBuilder(
                      key: formKey,
                      child: Center(
                        child: SizedBox(
                          height: fieldSize,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return buildOtpTextField(index, fieldSize);
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(width: 8);
                            },
                            itemCount: 4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ValueListenableBuilder(
                      valueListenable: isFilled,
                      builder: (context, isFilled, child) {
                        return FilledButton(
                          onPressed: isFilled ? verifyOtp : null,
                          child: const Text('Verifikasi'),
                        ).fullWidth();
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton.icon(
                        onPressed: isDone ? resendOtp : null,
                        label: Text(
                          'Kirim Ulang OTP ${isDone ? "" : "($value)"}',
                        ),
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Transform.rotate(
                            angle: -45 * math.pi / 180,
                            child: SvgAsset(
                              assetPath: AssetPath.getIcon('send-filled.svg'),
                              color: isDone ? primaryColor : secondaryTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    context.showBanner(
      message: 'Kode OTP telah terkirim ke email ${widget.email}',
      type: BannerType.success,
    );
  }

  SizedBox buildOtpTextField(int index, double fieldSize) {
    return SizedBox(
      width: fieldSize,
      height: fieldSize,
      child: FormBuilderTextField(
        name: '$index',
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 3),
        ),
        style: textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        onChanged: (value) {
          if (value?.length == 1) {
            FocusManager.instance.primaryFocus?.nextFocus();

            if (index == 3) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          }

          isFilled.value = areAllFieldsFilled();
        },
      ),
    );
  }

  bool areAllFieldsFilled() {
    formKey.currentState!.save();

    final data = formKey.currentState!.value;
    final values = data.values.cast<String?>().toList();

    for (var value in values) {
      if (value == null || value.isEmpty) return false;
    }

    return true;
  }

  void verifyOtp() {
    final data = formKey.currentState!.value;
    final values = data.values.cast<String?>().toList();
    final otp = values.join('');

    if (otp != widget.otp) {
      context.showBanner(
        message: 'Kode OTP yang Anda masukkan tidak sesuai!',
        type: BannerType.error,
      );
    } else {
      navigatorKey.currentState!.pushReplacementNamed(
        resetPasswordRoute,
        arguments: OtpPageArgs(email: widget.email, otp: otp),
      );
    }
  }

  void resendOtp() {
    ref.invalidate(askResetPasswordProvider);
    ref.read(askResetPasswordProvider.notifier).askResetPassword(email: widget.email);
  }
}

class OtpPageArgs {
  final String email;
  final String otp;

  const OtpPageArgs({
    required this.email,
    required this.otp,
  });
}
