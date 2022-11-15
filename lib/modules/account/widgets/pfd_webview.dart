
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFWebView extends StatefulWidget {
  const PDFWebView({Key? key}) : super(key: key);

  @override
  State<PDFWebView> createState() => _PDFWebViewState();
}

class _PDFWebViewState extends State<PDFWebView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: SfPdfViewer.network(
                'https://test.gadeer.org/storage/imagefiles/SfLhFeksHN5DagL1F2xl1WChbn5nHdJnpiue1Sty.pdf')));
  }
}
