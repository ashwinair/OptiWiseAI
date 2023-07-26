import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:optiwiseai/utils/find_and_analysis.dart';
import 'package:optiwiseai/utils/product_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:typewritertext/typewritertext.dart';

import '../ProductDetails/product.dart';
import '../ProductDetails/product_analysis.dart';

class ProductPage extends StatefulWidget {
  final String barcode;

  const ProductPage({super.key, required this.barcode});

  @override
  State<ProductPage> createState() => ProductPageState(barcode);
}

class ProductPageState extends State<ProductPage> {
  final String barcode;

  ProductPageState(this.barcode);

  late Future<bool> _value;

  @override
  void initState() {
    super.initState();
    _value = FindAndAnalysisProduct.checkAndGetData(barcode);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _value,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData &&
              Product.productInfo[barcode] != null &&
              ProductAnalysis.productAnalysisResult[barcode] != null) {
            String? imgURL = Product.productInfo[barcode]?.imgURL;
            var url = '';
            if (imgURL != null) {
              url = imgURL;
            } else {
              url =
                  'https://st.depositphotos.com/1987177/3470/v/450/depositphotos_34700099-stock-illustration-no-photo-available-or-missing.jpg';
            }
            List<String>? badIngredients = ProductUtils.badIngredients(barcode);
            final List<String> highLowOrModerate =
                ProductUtils.highLowOrModerate(barcode);
            return Scaffold(
              backgroundColor: const Color(0xFFbdb6ff),
              appBar: AppBar(
                title: const Text(
                  "Product info",
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: Colors.black54,
                          width: 1,
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 100.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFFfff250),
                            border: Border(
                              bottom: BorderSide(
                                  width: 1, color: Color(0xFF141414)), //black
                            ),
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.spaceAround,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  width: 20.w,
                                  //height: 20.h,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(10)),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: url,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 70.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: AutoSizeText(
                                        '${Product.productInfo[barcode]?.productName}',
                                        minFontSize: 12,
                                        maxLines: 2,
                                        style: TextStyle(fontSize: 13.sp),
                                      ),
                                    ),
                                    AutoSizeText(
                                      '${Product.productInfo[barcode]?.size}',
                                      minFontSize: 10,
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 10.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 90.w,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: highLowOrModerate.map((item) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    elevation: 2,
                                    shadowColor: const Color(0xFF141414),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: AutoSizeText(
                                        item,
                                        style: TextStyle(fontSize: 12.sp),
                                        maxLines: 1,
                                      ),
                                    )),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          width: 90.w,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: AutoSizeText(
                              '${ProductAnalysis.productAnalysisResult[widget.barcode]?.note}',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ),
                        ),
                        AutoSizeText(
                          'Bad Ingredients Found ',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: badIngredients!.map((item) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Chip(
                                    avatar: const Text(
                                      '❌',
                                      style:
                                          TextStyle(color: Color(0xFFF32013)),
                                    ),
                                    elevation: 2,
                                    label: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: AutoSizeText(
                                        item,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                    ),
                                    labelPadding: const EdgeInsets.all(1.0)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  height: 100.h,
                  width: 100.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                                width: 60.w,
                                height: 60.w,
                                child:
                                    Lottie.asset('assets/BarcodeScanner.json')),
                            const Padding(
                                padding: EdgeInsets.only(bottom: 5.0)),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  TypeWriterText(
                                    play: true,
                                    maintainSize: false,
                                    alignment: Alignment.topCenter,
                                    text: Text(
                                      barcode,
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                    duration: const Duration(milliseconds: 60),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      child: Center(
                                        child: TypeWriterText(
                                          maintainSize: false,
                                          play: true,
                                          repeat: true,
                                          text: Text('Analyzing....'),
                                          duration: Duration(milliseconds: 60),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
