// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:after_layout/after_layout.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/core/helpers/category_helper.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/reference_models/discussion_category_model.dart';
import 'package:law_app/features/admin/data/models/user_models/user_model.dart';
import 'package:law_app/features/admin/data/models/user_models/user_post_model.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/user_actions_provider.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/user_detail_provider.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class MasterDataFormPage extends ConsumerStatefulWidget {
  final String title;
  final String role;
  final UserModel? user;

  const MasterDataFormPage({
    super.key,
    required this.title,
    required this.role,
    this.user,
  });

  @override
  ConsumerState<MasterDataFormPage> createState() => _MasterDataFormPageState();
}

class _MasterDataFormPageState extends ConsumerState<MasterDataFormPage> with AfterLayoutMixin {
  late final GlobalKey<FormBuilderState> formKey;
  late DateTime date;
  late List<DiscussionCategoryModel> categories;
  late List<DiscussionCategoryModel> selectedExpertises;

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormBuilderState>();
    date = DateTime.now();
    categories = [];

    if (widget.user != null) {
      selectedExpertises = widget.user!.expertises!;
    } else {
      selectedExpertises = [];
    }
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    if (widget.role == 'teacher') {
      context.showLoadingDialog();

      final result = await CategoryHelper.getDiscussionCategories(ref);

      categories = result;

      navigatorKey.currentState!.pop();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTeacher = widget.role == 'teacher';

    ref.listen(userActionsProvider, (_, state) {
      state.whenOrNull(
        data: (data) {
          if (data != null) {
            navigatorKey.currentState!.pop();

            if (widget.user != null) {
              ref.invalidate(UserDetailProvider(id: widget.user!.id!));
            }
          }
        },
      );
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: HeaderContainer(
          title: widget.title,
          withBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        child: FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                name: 'name',
                label: 'Nama Lengkap',
                hintText: 'Masukkan nama lengkap',
                initialValue: widget.user?.name,
                hasPrefixIcon: false,
                hasSuffixIcon: false,
                textCapitalization: TextCapitalization.words,
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'Bagian ini harus diisi',
                  ),
                  FormBuilderValidators.match(
                    RegExp(r'^[a-zA-Z\s]*$'),
                    errorText: 'Nama tidak valid',
                  ),
                ],
              ),
              if (widget.user == null) ...[
                const SizedBox(height: 20),
                CustomTextField(
                  name: 'username',
                  label: 'Username',
                  hintText: 'Masukkan username',
                  hasPrefixIcon: false,
                  hasSuffixIcon: false,
                  textInputType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: 'Bagian ini harus diisi',
                    ),
                    FormBuilderValidators.match(
                      RegExp(r'^(?=.*[a-zA-Z])\d*[a-zA-Z\d]*$'),
                      errorText: 'Username tidak valid',
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              CustomTextField(
                name: 'email',
                label: 'Email',
                hintText: 'Masukkan email',
                initialValue: widget.user?.email,
                hasPrefixIcon: false,
                hasSuffixIcon: false,
                textInputType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'Bagian ini harus diisi',
                  ),
                  FormBuilderValidators.email(
                    errorText: 'Email tidak valid',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                name: 'birthDate',
                label: 'Tanggal Lahir',
                hintText: 'd MMMM yyyy',
                initialValue: widget.user?.birthDate?.toStringPattern('d MMMM yyyy'),
                hasPrefixIcon: false,
                suffixIconName: 'calendar.svg',
                textInputType: TextInputType.none,
                onTap: showBirthDatePicker,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                name: 'phoneNumber',
                label: 'No. HP',
                hintText: '+62xxx',
                initialValue: widget.user?.phoneNumber,
                hasPrefixIcon: false,
                hasSuffixIcon: false,
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validators: [
                  FormBuilderValidators.integer(
                    errorText: 'No. HP tidak valid',
                  ),
                ],
              ),
              if (isTeacher) buildTeacherCheckboxes(),
              SizedBox(height: isTeacher ? 12 : 20),
              FilledButton(
                onPressed: widget.user != null ? () => editUser(isTeacher) : () => createUser(isTeacher),
                child: Text('${widget.user != null ? "Edit" : "Tambah"} User'),
              ).fullWidth(),
            ],
          ),
        ),
      ),
    );
  }

  Column buildTeacherCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          'Pilih Kepakaran',
          style: textTheme.titleSmall,
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List<Row>.generate(
            categories.length,
            (index) {
              final category = categories[index];

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: selectedExpertises.contains(category),
                    checkColor: scaffoldBackgroundColor,
                    side: const BorderSide(
                      color: secondaryTextColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    visualDensity: const VisualDensity(
                      vertical: VisualDensity.minimumDensity,
                      horizontal: VisualDensity.minimumDensity,
                    ),
                    onChanged: (_) {
                      setState(() {
                        if (selectedExpertises.contains(category)) {
                          selectedExpertises.remove(category);
                        } else {
                          selectedExpertises.add(category);
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedExpertises.contains(category)) {
                            selectedExpertises.remove(category);
                          } else {
                            selectedExpertises.add(category);
                          }
                        });
                      },
                      child: Text('${category.name}'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void editUser(bool isTeacher) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      if (isTeacher && selectedExpertises.isEmpty) {
        context.showBanner(
          message: 'Pilih setidaknya 1 kepakaran yang dimiliki pakar!',
          type: BannerType.error,
        );
      } else {
        final data = formKey.currentState!.value;

        ref.read(userActionsProvider.notifier).editUser(
              user: widget.user!.copyWith(
                name: data['name'],
                email: data['email'],
                expertises: selectedExpertises,
                birthDate: data['birthDate'] != null
                    ? (data['birthDate'] as String).isNotEmpty
                        ? date
                        : null
                    : null,
                phoneNumber: data['phoneNumber'] != null
                    ? (data['phoneNumber'] as String).isNotEmpty
                        ? data['phoneNumber']
                        : null
                    : null,
              ),
            );
      }
    }
  }

  void createUser(bool isTeacher) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      if (isTeacher && selectedExpertises.isEmpty) {
        context.showBanner(
          message: 'Pilih setidaknya 1 kepakaran yang dimiliki pakar!',
          type: BannerType.error,
        );
      } else {
        final data = formKey.currentState!.value;

        ref.read(userActionsProvider.notifier).createUser(
              user: UserPostModel(
                name: data['name'],
                username: data['username'],
                email: data['email'],
                password: data['username'],
                role: widget.role,
                teacherDiscussionCategoryIds: selectedExpertises.map((e) => e.id!).toList(),
                birthDate: data['birthDate'] != null
                    ? (data['birthDate'] as String).isNotEmpty
                        ? date
                        : null
                    : null,
                phoneNumber: data['phoneNumber'] != null
                    ? (data['phoneNumber'] as String).isNotEmpty
                        ? data['phoneNumber']
                        : null
                    : null,
              ),
            );
      }
    }
  }

  Future<void> showBirthDatePicker() async {
    final birthDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(date.year - 50),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Pilih Tanggal Lahir',
      locale: const Locale('id', 'ID'),
    );

    if (birthDate != null) {
      date = birthDate;

      final value = date.toStringPattern('d MMMM yyyy');

      formKey.currentState!.fields['birthDate']!.didChange(value);
    }
  }
}

class MasterDataFormPageArgs {
  final String title;
  final String role;
  final UserModel? user;

  const MasterDataFormPageArgs({
    required this.title,
    required this.role,
    this.user,
  });
}
