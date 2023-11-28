class PdfUploadMOdel {
  String? dateTime;
  String? id;
  String? imagefile;
  String? pdffile;
  String? title;

  PdfUploadMOdel({
    required this.dateTime,
    required this.id,
    required this.imagefile,
    required this.pdffile,
    required this.title,
  });

  Map<String, dynamic> toJSon() {
    final Map<String, dynamic> json = Map<String, dynamic>();
    json['dateTime'] = dateTime;
    json['id'] = id;
    json['imagefile'] = imagefile;
    json['pdffile'] = pdffile;
    json['title'] = title;
    return json;
  }
}
