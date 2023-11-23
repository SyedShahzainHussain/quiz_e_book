import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Ebook extends StatelessWidget {
  const Ebook({super.key});

  @override
  Widget build(BuildContext context) {
    var inputFormat = DateFormat('dd/MM/yyyy');

    DateTime myDate = DateTime.parse(DateTime.now().toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ebook"),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.pdfviewScreen);
                },
                child: Column(
                  children: [
                    ListTile(
                      leading: Image.asset(
                        "assets/images/pdf.png",
                      ),
                      title: const Text(
                        "Science",
                        maxLines: 1,
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                      subtitle: Text(inputFormat.format(myDate),
                          maxLines: 1,
                          style:
                              const TextStyle(overflow: TextOverflow.ellipsis)),
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
    );
  }
}

class PdfViewScreen extends StatefulWidget {
  const PdfViewScreen({super.key});

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
          title: const Text("Ebook"),
          actions: [
            IconButton(
                onPressed: () {
                  _pdfViewerState.currentState!.openBookmarkView();
                },
                icon: const Icon(Icons.zoom_out)),
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
        body: SfPdfViewer.file(
          File(
              '/data/user/0/com.example.quiz_e_book/cache/file_picker/البرھان بائیکاٹ لسٹ.pdf'),
          controller: _pdfViewerController,
          key: _pdfViewerState,
        ));
  }
}
