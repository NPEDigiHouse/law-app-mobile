// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/styles/text_style.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/credential_saver.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/library/presentation/providers/book_saved_actions_provider.dart';
import 'package:law_app/features/library/presentation/providers/book_saved_provider.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/book_card.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class LibrarySavedBookPage extends ConsumerWidget {
  const LibrarySavedBookPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedBooks = ref.watch(
      BookSavedProvider(userId: CredentialSaver.user!.id!),
    );

    ref.listen(
      BookSavedProvider(userId: CredentialSaver.user!.id!),
      (_, state) {
        state.whenOrNull(
          error: (error, _) {
            if ('$error' == kNoInternetConnection) {
              context.showNetworkErrorModalBottomSheet(
                onPressedPrimaryButton: () {
                  navigatorKey.currentState!.pop();
                  ref.invalidate(bookSavedProvider);
                },
              );
            } else {
              context.showBanner(message: '$error', type: BannerType.error);
            }
          },
        );
      },
    );

    ref.listen(bookSavedActionsProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showBanner(
              message: 'Gagal melakukan aksi. Periksa koneksi internet!',
              type: BannerType.error,
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        data: (data) {
          if (data != null) {
            ref.invalidate(bookSavedProvider);
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Buku Disimpan',
          withBackButton: true,
        ),
      ),
      body: savedBooks.whenOrNull(
        loading: () => const LoadingIndicator(),
        data: (savedBooks) {
          if (savedBooks == null) return null;

          if (savedBooks.isEmpty) {
            return const CustomInformation(
              illustrationName: 'book-lover-cuate.svg',
              title: 'Belum ada buku yang disimpan',
              subtitle: 'Buku yang kamu simpan akan muncul di sini.',
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text(
                  '*Tekan tahan untuk memilih opsi hapus',
                  style: textTheme.bodySmall!.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  itemBuilder: (context, index) {
                    return BookCard(
                      book: savedBooks[index].book!,
                      onLongPress: () {
                        context.showDeleteConfirmDialog(
                          title: savedBooks[index].book!.title!,
                          onIconPressed: () {
                            navigatorKey.currentState!.pop();

                            ref
                                .read(bookSavedActionsProvider.notifier)
                                .unsaveBook(id: savedBooks[index].id!);
                          },
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 8);
                  },
                  itemCount: savedBooks.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
