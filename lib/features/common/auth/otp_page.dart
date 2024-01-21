import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:law_app/core/extensions/app_extension.dart';
import 'package:law_app/core/helpers/app_size.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/core/utils/widget_utils.dart';
import 'package:law_app/features/common/widgets/auth/auth_app_bar.dart';
import 'package:law_app/features/common/widgets/shared/banner_type.dart';
import 'package:law_app/features/common/widgets/shared/svg_asset.dart';

class OtpPage extends StatefulWidget {
  final String email;

  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with AfterLayoutMixin<OtpPage> {
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

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthAppBar(),
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
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
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
                          padding: const EdgeInsets.all(0),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    showSuccessBanner();
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
        textInputAction:
            index != 3 ? TextInputAction.next : TextInputAction.done,
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
          isFilled.value = areAllFieldsFilled();

          if (value?.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  void showSuccessBanner() {
    final successBanner = WidgetUtils.createMaterialBanner(
      content: 'Kode OTP telah terkirim ke email ${widget.email}',
      type: BannerType.success,
    );

    scaffoldMessengerKey.currentState!
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(successBanner);
  }

  void verifyOtp() {
    final data = formKey.currentState!.value;

    debugPrint(data.toString());
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
}
