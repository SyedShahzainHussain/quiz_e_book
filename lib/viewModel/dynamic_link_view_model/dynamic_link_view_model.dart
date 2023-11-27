import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:quiz_e_book/model/pdf_model.dart';

import 'package:share_plus/share_plus.dart';

class FirebaseDynamicLink {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  static Future<void> createDynamicLink(
    String? screenPath,
    PdfModel pdfModel,
  ) async {
    
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
    
      link: Uri.parse(
          'https://zain.page.link/$screenPath/1'),
          
      uriPrefix: 'https://zain.page.link',

      androidParameters: const AndroidParameters(
        packageName: "com.zain.quiz_e_book",
        minimumVersion: 0,

      ),
    );
    

    Uri url;
    final shortDynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParameters,);
    url = shortDynamicLink;
    Share.share(url.toString());
  }

  Future<void> initDynamicLinks(
    Function(PendingDynamicLinkData openLink) dataObj,
  ) async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      dataObj(dynamicLinkData);
    }).onError((error) {
    });
  }
}
