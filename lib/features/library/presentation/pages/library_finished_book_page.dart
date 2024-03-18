// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:law_app/core/enums/banner_type.dart';
import 'package:law_app/core/extensions/context_extension.dart';
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/core/utils/const.dart';
import 'package:law_app/core/utils/keys.dart';
import 'package:law_app/features/library/presentation/providers/user_read_actions_provider.dart';
import 'package:law_app/features/library/presentation/providers/user_read_provider.dart';
import 'package:law_app/features/shared/widgets/custom_information.dart';
import 'package:law_app/features/shared/widgets/feature/book_card.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';
import 'package:law_app/features/shared/widgets/loading_indicator.dart';

class LibraryFinishedBookPage extends ConsumerWidget {
  const LibraryFinishedBookPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userReads = ref.watch(userReadProvider);

    ref.listen(userReadProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet(
              onPressedPrimaryButton: () {
                navigatorKey.currentState!.pop();
                ref.invalidate(userReadProvider);
              },
            );
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
      );
    });

    ref.listen(userReadActionsProvider, (_, state) {
      state.whenOrNull(
        error: (error, _) {
          if ('$error' == kNoInternetConnection) {
            context.showNetworkErrorModalBottomSheet();
          } else {
            context.showBanner(message: '$error', type: BannerType.error);
          }
        },
        data: (data) {
          if (data != null) {
            ref.invalidate(userReadProvider);
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Selesai Dibaca',
          withBackButton: true,
        ),
      ),
      body: userReads.whenOrNull(
        loading: () => const LoadingIndicator(withScaffold: true),
        error: (_, __) => const Scaffold(),
        data: (userReads) {
          if (userReads == null) return const Scaffold();

          if (userReads.isEmpty) {
            return const CustomInformation(
              illustrationName: 'book-lover-cuate.svg',
              title: 'Belum ada buku yang selesai dibaca',
              subtitle: 'Buku yang telah selesai dibaca akan muncul di sini.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 20,
            ),
            itemBuilder: (context, index) {
              return BookCard(
                book: userReads[index],
                onLongPress: () {
                  context.showDeleteConfirmDialog(
                    title: userReads[index].title!,
                    onIconPressed: () {
                      navigatorKey.currentState!.pop();

                      ref
                          .read(userReadActionsProvider.notifier)
                          .deleteUserRead(bookId: userReads[index].id!);
                    },
                  );
                },
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemCount: userReads.length,
          );
        },
      ),
    );
  }
}
