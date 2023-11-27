import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/viewModel/save_pdf_view_model/save_pdf_view_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SafePdfScreen extends StatefulWidget {
  const SafePdfScreen({super.key});

  @override
  State<SafePdfScreen> createState() => _SafePdfScreenState();
}

class _SafePdfScreenState extends State<SafePdfScreen> {
  late PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerState = GlobalKey();
  late Future<File?>? _pdfFuture;
  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    _pdfFuture = _fetchAndStorePdf();
    getlist();
    super.initState();
  }

  Future<List<String>> getAllFilenames() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = Directory(dir.path).listSync();

    final filenames = files.map((file) => file.path.split('/').last).toList();

    return filenames;
  }

// Function to fetch and store the PDF
  Future<File?> _fetchAndStorePdf() async {
    return context.read<SavePDFViewModel>().storeFile(
          context,
          '/data/user/0/com.example.quiz_e_book/cache/file_picker/البرھان بائیکاٹ لسٹ .pdf',
          'your_pdf_file.pdf',
        );
  }

  getlist() async {
    List<String> filenames = await getAllFilenames();
    print(filenames);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<File?>(
        future: _pdfFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Utils
                .showLoadingSpinner(); // Show loading indicator while fetching PDF
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            // Use the saved PDF file
            return SfPdfViewer.file(
              snapshot.data!,
              controller: _pdfViewerController,
              key: _pdfViewerState,
            );
          } else {
            return const Center(
              child: Text('No PDF available'),
            );
          }
        },
      ),
    );
  }
}
