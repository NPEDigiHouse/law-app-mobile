// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:after_layout/after_layout.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/button_extension.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/extensions/datetime_extension.dart';
import 'package:law_app/core/helpers/asset_path.dart';
import 'package:law_app/core/helpers/category_helper.dart';
import 'package:law_app/core/services/file_service.dart';
import 'package:law_app/core/services/image_service.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/admin/data/models/book_models/book_category_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_detail_model.dart';
import 'package:law_app/features/admin/data/models/book_models/book_post_model.dart';
import 'package:law_app/features/library/presentation/providers/book_detail_provider.dart';
import 'package:law_app/features/library/presentation/providers/book_provider.dart';
import 'package:law_app/features/library/presentation/providers/create_book_provider.dart';
import 'package:law_app/features/library/presentation/providers/edit_book_provider.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_dropdown_field.dart';
import 'package:law_app/features/shared/widgets/form_field/custom_text_field.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/svg_asset.dart';

final coverPathProvider = StateProvider.autoDispose<String?>((ref) => null);
final filePathProvider = StateProvider.autoDispose<String?>((ref) => null);

class BookManagementFormPage extends ConsumerStatefulWidget {
  final String title;
  final BookDetailModel? book;

  const BookManagementFormPage({super.key, required this.title, this.book});

  @override
  ConsumerState<BookManagementFormPage> createState() =>
      _BookManagementFormPageState();
}

class _BookManagementFormPageState extends ConsumerState<BookManagementFormPage>
    with AfterLayoutMixin {
  late final GlobalKey<FormBuilderState> formKey;
  late DateTime date;
  late List<BookCategoryModel> categories;

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormBuilderState>();
    date = DateTime.now();
    categories = [];
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    context.showLoadingDialog();

    final result = await CategoryHelper.getBookCategories(ref);

    categories = result;

    if (widget.book != null) {
      final coverPath =
          await FileService.downloadFile(url: widget.book!.coverImage!);

      if (coverPath != null) {
        ref.read(coverPathProvider.notifier).state = coverPath;
      }

      final filePath =
          await FileService.downloadFile(url: widget.book!.bookUrl!);

      if (filePath != null) {
        ref.read(filePathProvider.notifier).state = filePath;
      }
    }

    navigatorKey.currentState!.pop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bookCover = ref.watch(coverPathProvider);
    final bookFile = ref.watch(filePathProvider);

    ref.listen(editBookProvider, (_, state) {
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
            ref.invalidate(BookDetailProvider(id: widget.book!.id!));
            ref.invalidate(bookProvider);

            context.showBanner(
              message: 'Berhasil mengedit buku!',
              type: BannerType.success,
            );

            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pop();
          }
        },
      );
    });

    ref.listen(createBookProvider, (_, state) {
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
            ref.invalidate(bookProvider);

            context.showBanner(
              message: 'Berhasil menambahkan buku!',
              type: BannerType.success,
            );

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
              Text(
                'Sampul Buku',
                style: textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: bookCover != null
                        ? AspectRatio(
                            aspectRatio: 2 / 3,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(File(bookCover)),
                                ),
                              ),
                            ),
                          )
                        : DottedBorder(
                            borderType: BorderType.RRect,
                            strokeCap: StrokeCap.round,
                            radius: const Radius.circular(12),
                            dashPattern: const [4, 4],
                            color: secondaryTextColor,
                            child: AspectRatio(
                              aspectRatio: 2 / 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Center(
                                  child: Text(
                                    'Ekstensi file yang diizinkan: .jpg, .jpeg, atau .png',
                                    textAlign: TextAlign.center,
                                    style: textTheme.bodyMedium!.copyWith(
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: pickCoverFile,
                      icon: const Icon(
                        Icons.photo_library_rounded,
                        size: 20,
                      ),
                      label: Text(
                        bookCover != null ? 'Ganti Sampul' : 'Pilih Sampul',
                      ),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: secondaryColor,
                        foregroundColor: primaryColor,
                        textStyle: textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                name: 'title',
                label: 'Judul',
                hintText: 'Masukkan judul buku',
                initialValue: widget.book?.title,
                hasPrefixIcon: false,
                hasSuffixIcon: false,
                textCapitalization: TextCapitalization.words,
                validators: [
                  FormBuilderValidators.required(
                    errorText: "Bagian ini harus diisi",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                name: 'writer',
                label: 'Penulis',
                hintText: 'Masukkan nama penulis',
                initialValue: widget.book?.writer,
                hasPrefixIcon: false,
                hasSuffixIcon: false,
                textCapitalization: TextCapitalization.words,
                validators: [
                  FormBuilderValidators.required(
                    errorText: "Bagian ini harus diisi",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                name: 'publisher',
                label: 'Penerbit',
                hintText: 'Masukkan nama penerbit',
                initialValue: widget.book?.publisher,
                hasPrefixIcon: false,
                hasSuffixIcon: false,
                textCapitalization: TextCapitalization.words,
                validators: [
                  FormBuilderValidators.required(
                    errorText: "Bagian ini harus diisi",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                name: 'pageAmt',
                label: 'Jumlah Halaman',
                hintText: 'Masukkan jumlah halaman',
                initialValue: widget.book?.pageAmt.toString(),
                hasPrefixIcon: false,
                hasSuffixIcon: false,
                textInputType: TextInputType.number,
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'Bagian ini harus diisi',
                  ),
                  FormBuilderValidators.integer(
                    errorText: 'Masukkan angka integer',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomDropdownField(
                name: 'categoryId',
                label: 'Kategori',
                onChanged: (_) {},
                items: categories.map((e) => e.name!).toList(),
                values: categories.map((e) => e.id!.toString()).toList(),
                initialValue: widget.book != null
                    ? widget.book!.category!.id.toString()
                    : categories.isNotEmpty
                        ? categories.first.id.toString()
                        : null,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                name: 'releaseDate',
                label: 'Tahun Terbit',
                hintText: 'd MMMM yyyy',
                initialValue:
                    widget.book?.releaseDate?.toStringPattern('d MMMM yyyy'),
                hasPrefixIcon: false,
                suffixIconName: 'calendar.svg',
                textInputType: TextInputType.none,
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'Bagian ini harus diisi',
                  ),
                ],
                onTap: showReleaseDatePicker,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: pickBookFile,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  strokeCap: StrokeCap.round,
                  radius: const Radius.circular(14),
                  dashPattern: const [4, 4],
                  color: bookFile != null ? accentColor : secondaryTextColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgAsset(
                            assetPath: AssetPath.getIcon('file-solid.svg'),
                            color: bookFile != null
                                ? primaryColor
                                : secondaryTextColor,
                            width: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bookFile != null
                                ? p.basename(bookFile)
                                : 'Pilih Dokumen (.pdf)',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium!.copyWith(
                              color: bookFile != null
                                  ? primaryColor
                                  : secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                name: 'synopsis',
                label: 'Sinopsis',
                hintText: 'Masukkan sinopsis buku',
                initialValue: widget.book?.synopsis,
                maxLines: 4,
                hasPrefixIcon: false,
                hasSuffixIcon: false,
                textInputAction: TextInputAction.newline,
                validators: [
                  FormBuilderValidators.required(
                    errorText: "Bagian ini harus diisi",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: widget.book != null
                    ? () => editBook(bookCover ?? '', bookFile ?? '')
                    : () => createBook(bookCover, bookFile),
                child: Text(widget.title),
              ).fullWidth(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showReleaseDatePicker() async {
    final releaseDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(date.year - 50),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Pilih Tanggal Buku Dirilis',
      locale: const Locale('id', 'ID'),
    );

    if (releaseDate != null) {
      date = releaseDate;

      final value = date.toStringPattern('d MMMM yyyy');

      formKey.currentState!.fields['releaseDate']!.didChange(value);
    }
  }

  Future<void> pickCoverFile() async {
    final imagePath = await ImageService.pickImage(ImageSource.gallery);

    if (imagePath != null) {
      final compressedImagePath = await ImageService.cropImage(
        imagePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 2, ratioY: 3),
      );

      if (compressedImagePath != null) {
        ref.read(coverPathProvider.notifier).state = compressedImagePath;
      }
    }
  }

  Future<void> pickBookFile() async {
    final path = await FileService.pickFile(extensions: ['pdf']);

    if (path != null) {
      ref.read(filePathProvider.notifier).state = path;
    }
  }

  void editBook(String bookCover, String bookFile) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;

      final isUpdatedCover =
          p.basename(widget.book!.coverImage!) != p.basename(bookCover);

      final isUpdatedFile =
          p.basename(widget.book!.bookUrl!) != p.basename(bookFile);

      ref.read(editBookProvider.notifier).editBook(
            book: widget.book!.copyWith(
              title: data['title'],
              writer: data['writer'],
              publisher: data['publisher'],
              synopsis: data['synopsis'],
              pageAmt: int.parse(data['pageAmt']),
              releaseDate: date,
              category: categories
                  .where((e) => e.id == int.parse(data['categoryId']))
                  .first,
            ),
            imagePath: isUpdatedCover ? bookCover : null,
            bookPath: isUpdatedFile ? bookFile : null,
          );
    }
  }

  void createBook(String? bookCover, String? bookFile) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      if (bookCover == null) {
        context.showBanner(
          message: 'Anda belum memilih sampul buku!',
          type: BannerType.error,
        );

        return;
      }

      if (bookFile == null) {
        context.showBanner(
          message: 'Anda belum memilih file buku!',
          type: BannerType.error,
        );

        return;
      }

      final data = formKey.currentState!.value;

      ref.read(createBookProvider.notifier).createBook(
            book: BookPostModel(
              title: data['title'],
              writer: data['writer'],
              publisher: data['publisher'],
              synopsis: data['synopsis'],
              pageAmt: data['pageAmt'],
              categoryId: data['categoryId'],
              releaseDate: date,
            ),
            imagePath: bookCover,
            bookPath: bookFile,
          );
    }
  }
}

class BookManagementFormPageArgs {
  final String title;
  final BookDetailModel? book;

  const BookManagementFormPageArgs({
    required this.title,
    this.book,
  });
}
