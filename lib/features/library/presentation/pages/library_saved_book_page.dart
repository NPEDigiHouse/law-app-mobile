// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:law_app/core/styles/color_scheme.dart';
import 'package:law_app/dummies_data.dart';
import 'package:law_app/features/shared/widgets/header_container.dart';

class LibrarySavedBookPage extends StatelessWidget {
  const LibrarySavedBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: HeaderContainer(
          title: 'Buku Disimpan',
          withBackButton: true,
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        itemBuilder: (context, index) {
          return const SizedBox();
          //return BookCard(book: dummyBooks[index]);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8);
        },
        itemCount: dummyBooks.length,
      ),
    );
  }

  //  CustomScrollView buildBookHistoryList() {
  //   return CustomScrollView(
  //     slivers: [
  //       SliverPadding(
  //         padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
  //         sliver: SliverToBoxAdapter(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 '*Swipe ke samping untuk menghapus history buku',
  //                 style: textTheme.labelSmall!.copyWith(
  //                   color: secondaryTextColor,
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: Text(
  //                       'Riwayat Pencarian',
  //                       style: textTheme.titleLarge,
  //                     ),
  //                   ),
  //                   GestureDetector(
  //                     onTap: () => context.showConfirmDialog(
  //                       title: 'Konfirmasi',
  //                       message:
  //                           'Anda yakin ingin menghapus seluruh riwayat pencarian?',
  //                       onPressedPrimaryButton: () {},
  //                     ),
  //                     child: Text(
  //                       'Hapus Semua',
  //                       style: textTheme.bodySmall!.copyWith(
  //                         fontWeight: FontWeight.w500,
  //                         color: primaryColor,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       SliverPadding(
  //         padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
  //         sliver: SliverList(
  //           delegate: SliverChildBuilderDelegate(
  //             (context, index) {
  //               return Dismissible(
  //                 key: ValueKey<String>(bookHistoryList[index].title),
  //                 onDismissed: (_) {
  //                   setState(() {
  //                     bookHistoryList.removeWhere((book) {
  //                       return book.title == bookHistoryList[index].title;
  //                     });
  //                   });
  //                 },
  //                 child: const Padding(
  //                   padding: EdgeInsets.only(bottom: 8),
  //                   // child: BookCard(
  //                   //   isThreeLine: false,
  //                   //   book: bookHistoryList[index],
  //                   // ),
  //                 ),
  //               );
  //             },
  //             childCount: bookHistoryList.length,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
