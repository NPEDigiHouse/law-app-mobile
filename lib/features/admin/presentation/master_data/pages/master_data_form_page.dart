// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/discussion_models/discussion_category_model.dart';
import 'package:law_app/features/admin/data/models/user_models/user_detail_model.dart';
import 'package:law_app/features/admin/data/models/user_models/user_post_model.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/create_user_provider.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/edit_user_provider.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/master_data_provider.dart';
import 'package:law_app/features/admin/presentation/master_data/providers/user_detail_provider.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class MasterDataFormPage extends ConsumerStatefulWidget {
  final String title;
  final UserDetailModel? user;
  final List<DiscussionCategoryModel>? discussionCategories;

  const MasterDataFormPage({
    super.key,
    required this.title,
    this.user,
    this.discussionCategories,
  });

  @override
  ConsumerState<MasterDataFormPage> createState() => _MasterDataFormPageState();
}

class _MasterDataFormPageState extends ConsumerState<MasterDataFormPage> {
  late GlobalKey<FormBuilderState> formKey;
  late DateTime date;
  late List<DiscussionCategoryModel> selectedExpertises;

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormBuilderState>();
    date = DateTime.now();

    if (widget.user != null) {
      selectedExpertises = widget.user!.expertises!;
    } else {
      selectedExpertises = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTeacher = widget.title.split(' ').last.toLowerCase() == 'teacher';

    ref.listen(editUserProvider, (_, state) {
      state.when(
        error: (error, _) {
          navigatorKey.currentState!.pop();

          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet();
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        loading: () => context.showLoadingDialog(),
        data: (data) {
          ref.invalidate(UserDetailProvider(id: widget.user!.id!));
          ref.invalidate(masterDataProvider);

          navigatorKey.currentState!.pop();
          navigatorKey.currentState!.pop();
        },
      );
    });

    ref.listen(createUserProvider, (_, state) {
      state.when(
        error: (error, _) {
          navigatorKey.currentState!.pop();

          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet();
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        loading: () => context.showLoadingDialog(),
        data: (data) {
          if (data != null) {
            ref.invalidate(masterDataProvider);

            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();
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
                textInputType: TextInputType.name,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'Bagian ini harus diisi',
                  ),
                  FormBuilderValidators.match(
                    r'^[a-zA-Z\s]*$',
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
                  textInputAction: TextInputAction.next,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: 'Bagian ini harus diisi',
                    ),
                    FormBuilderValidators.match(
                      r'^(?=.*[a-zA-Z])\d*[a-zA-Z\d]*$',
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
                textInputAction: TextInputAction.next,
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
                initialValue:
                    widget.user?.birthDate?.toStringPattern('d MMMM yyyy'),
                hasPrefixIcon: false,
                suffixIconName: 'calendar.svg',
                textInputType: TextInputType.none,
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'Bagian ini harus diisi',
                  ),
                ],
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
                  FormBuilderValidators.required(
                    errorText: 'Bagian ini harus diisi',
                  ),
                  FormBuilderValidators.integer(
                    errorText: 'No. HP tidak valid',
                  ),
                ],
              ),
              if (isTeacher) buildTeacherCheckboxes(),
              SizedBox(height: isTeacher ? 12 : 20),
              FilledButton(
                onPressed: widget.user != null
                    ? () => editUser(isTeacher)
                    : () => createUser(isTeacher),
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
            widget.discussionCategories!.length,
            (index) {
              final category = widget.discussionCategories![index];

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

        ref.read(editUserProvider.notifier).editUser(
              user: widget.user!.copyWith(
                name: data['name'],
                email: data['email'],
                phoneNumber: data['phoneNumber'],
                birthDate: date,
                expertises: selectedExpertises,
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
        final role = widget.title.split(' ').last.toLowerCase();

        ref.read(createUserProvider.notifier).createUser(
              user: UserPostModel(
                name: data['name'],
                username: data['username'],
                email: data['email'],
                password: data['username'],
                phoneNumber: data['phoneNumber'],
                birthDate: date,
                role: role,
                teacherDiscussionCategoryIds:
                    selectedExpertises.map((e) => e.id!).toList(),
              ),
            );
      }
    }
  }

  Future<void> showBirthDatePicker() async {
    final birthDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(date.year - 30),
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
  final UserDetailModel? user;
  final List<DiscussionCategoryModel>? discussionCategories;

  const MasterDataFormPageArgs({
    required this.title,
    this.user,
    this.discussionCategories,
  });
}
