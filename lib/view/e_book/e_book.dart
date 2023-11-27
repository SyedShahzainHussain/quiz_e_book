import 'package:go_router/go_router.dart';
import 'package:quiz_e_book/model/pdf_model.dart';
import 'package:quiz_e_book/viewModel/dynamic_link_view_model/dynamic_link_view_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:quiz_e_book/resources/color/app_color.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: pdf.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    GoRouter.of(context)
                        .push(RouteName.pdfviewScreen, extra: pdf[index].id);
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      pdf[index].imageUrl,
                    ),
                  ),
                  title: Text(
                    pdf[index].text,
                    maxLines: 1,
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                  subtitle: Text(pdf[index].datetime,
                      maxLines: 1,
                      style: const TextStyle(overflow: TextOverflow.ellipsis)),
                  trailing: IconButton(
                      onPressed: () async {
                        Share.share(
                            "https://zain.page.link?amv=0&apn=com.zain.quiz_e_book&link=https%3A%2F%2Fzain.page.link%2Fe_book_screen");
                      },
                      icon: const Icon(
                        Icons.share,
                        color: AppColors.black,
                      )),
                ),
                const Divider(
                  color: AppColors.bgColor3,
                  thickness: 1,
                )
              ],
            ),
          ),
        ));
  }
}

List<PdfModel> pdf = [
  PdfModel(
      '1',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3yOhJ_inIyiWC8eBiNpecmm98yVeseDZaRcgpF323fKP_JyoKgk1Scg_Q7yNF8mapNBc&usqp=CAU',
      "Science",
      "22/22/2020",
      "https://www.science.smith.edu/~jcardell/Courses/EGR328/Readings/KuroseRoss%20Ch1.pdf"),
  PdfModel(
      '2',
      'https://katib.pk/cdn/shop/products/9780199061068_71304cc0-418f-4d6c-8dfc-d98c6868f28c_480x.jpg?v=1697107063',
      "English",
      "12/02/2023",
      "https://ftms.edu.my/v2/wp-content/uploads/2019/02/CN1047-Chapter-1.pdf"),
];

class PdfViewScreen extends StatefulWidget {
  // final Map<String, dynamic> data;
  final String? id;
  const PdfViewScreen({
    super.key,
    // required this.data,
    required this.id,
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

  // Future<File?> _fetchAndStorePdf() async {
  //   return context.read<SavePDFViewModel>().storeFile(
  //         context,
  //         '/data/user/0/com.example.quiz_e_book/cache/file_picker/البرھان بائیکاٹ لسٹ .pdf',
  //         'your_pdf_file.pdf',
  //       );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.id.toString()),
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
          "          widget.data['pdf']",
          controller: _pdfViewerController,
          key: _pdfViewerState,
        ));
  }
}
