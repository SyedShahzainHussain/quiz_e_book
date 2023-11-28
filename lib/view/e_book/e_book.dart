import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Ebook extends StatelessWidget {
  const Ebook({super.key});

  @override
  Widget build(BuildContext context) {
    // var inputFormat = DateFormat('dd/MM/yyyy');

    // DateTime myDate = DateTime.parse(DateTime.now().toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ebook"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('files')
            .orderBy("dateTime", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          if (data == null) {
            return Center(
              child: Utils.showLoadingSpinner(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Books"),
            );
          }
          Widget dynamicRow = Row(
            children: List.generate(
              min(data.length, 3),
              (index) => Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: context.screenheight * .2,
                    width: context.screenwidth * .35,
                    margin: const EdgeInsets.only(
                        left: 5, right: 5), // Adjust the height as needed
                    child: Column(
                      children: [
                        Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                data[index]['imagefile'],
                                width: double.infinity,
                                height: context.screenheight * .15,
                              )),
                        ),
                        Text(data[index]['title'])
                      ],
                    ), // Replace with your widget
                  ),
                ),
              ),
            ),
          );
          return SingleChildScrollView(
            child: Column(
              children: [
                dynamicRow,
                ListView.builder(
                    key: ValueKey(const Uuid().v1()),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final String? date = data[index].data()['dateTime'];
                      final formattedDate = DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(date!));

                      if (index < 3) {
                        // Skip the first three items
                        return const SizedBox
                            .shrink(); // or any widget you want for the skipped items
                      }
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  GoRouter.of(context)
                                      .push(RouteName.pdfviewScreen, extra: {
                                    "title": data[index].data()['title'],
                                    "pdf": data[index].data()['pdffile']
                                  });
                                },
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    data[index].data()['imagefile'],
                                  ),
                                ),
                                title: Text(
                                  data[index].data()['title'],
                                  maxLines: 1,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis),
                                ),
                                subtitle: Text(formattedDate,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis)),
                                trailing: IconButton(
                                  onPressed: () async {
                                    Share.share(
                                        "https://zain.page.link?amv=0&apn=com.zain.quiz_e_book&link=https%3A%2F%2Fzain.page.link%2Fe_book_screen");
                                  },
                                  icon: const Icon(
                                    Icons.share,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              const Divider(
                                color: AppColors.bgColor3,
                                thickness: 1,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PdfViewScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  // final String? id;
  const PdfViewScreen({
    super.key,
    required this.data,
  });

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  late PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerState = GlobalKey();

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.data['title'].toString()),
          actions: [
            IconButton(
                onPressed: () {
                  _pdfViewerState.currentState!.openBookmarkView();
                },
                icon: const Icon(Icons.bookmark)),
            IconButton(
                onPressed: () {
                  _pdfViewerController.zoomLevel = 1.25;
                },
                icon: const Icon(Icons.zoom_in)),
            IconButton(
                onPressed: () {
                  _pdfViewerController.zoomLevel = 0;
                },
                icon: const Icon(Icons.zoom_out)),
          ],
        ),
        body: SfPdfViewer.network(
          widget.data['pdf'],
          controller: _pdfViewerController,
          key: _pdfViewerState,
        ));
  }
}
