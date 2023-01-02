
import 'package:flutter/material.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFWebView extends StatefulWidget {
  String url ;
  PDFWebView({required this.url});

  @override
  State<PDFWebView> createState() => _PDFWebViewState();
}

class _PDFWebViewState extends State<PDFWebView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
      ),
        body: SafeArea(
          child: Container(
              child: SfPdfViewer.network(widget.url)),
        ));
  }
}
