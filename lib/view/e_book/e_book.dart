import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Ebook extends StatefulWidget {
  const Ebook({super.key});

  @override
  State<Ebook> createState() => _EbookState();
}

class _EbookState extends State<Ebook> {
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
                icon:const  Icon(Icons.zoom_in)),
            IconButton(
                onPressed: () {
                  _pdfViewerController.zoomLevel = 0;
                },
                icon: const Icon(Icons.zoom_out)),
          ],
        ),
        body: SfPdfViewer.file(
          File(
              '/data/user/0/com.example.quiz_e_book/cache/file_picker/البرھان بائیکاٹ لسٹ .pdf'),
          controller: _pdfViewerController,
          key: _pdfViewerState,

        ));
  }
}
