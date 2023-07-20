import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:optiwiseai/utils/product_utils.dart';
import 'package:sizer/sizer.dart';

class ProductPage extends StatefulWidget {
  //const ProductPage({super.key});

  final String barcode; //8901725002206
  const ProductPage({super.key, required this.barcode});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    String? imgURL = "https://m.media-amazon.com/images/I/81yJLRc3B3L.jpg";
    //Product.productInfo[widget.barcode]?.imgURL;
    var url = '';
    if (imgURL != null) {
      url = imgURL;
    } else {
      url =
          'https://st.depositphotos.com/1987177/3470/v/450/depositphotos_34700099-stock-illustration-no-photo-available-or-missing.jpg';
    }
    //"https://m.media-amazon.com/images/I/81yJLRc3B3L.jpg";
    //"https://m.media-amazon.com/images/I/81d8vzofulL._SL1500_.jpg";
    const String out =
        '"REFINED PALM OIL", "SUGAR", "INVERT SYRUP", "LIQUID GLUCOSE", "RAISING AGENTS", "MALTODEXTRIN", "EMULSIFERS", "IODIZED SALT", "NATURAL FLAVOUR & NATURAL FLAVOURING SUBSTANCES", "MALT EXTRACT", "ARTIFICIAL FLAVOURING SUBSTANCES", "FLOUR TREATMENT AGENT", "NATURE IDENTICAL FLAVOURING SUBSTANCES"';

    List<String>? badIngredients = ProductUtils.cleanString(out);

    //ProductUtils.badIngredients(barcode);
    final List<String> highLowOrModerate = [
      "High in Sugar",
      "Moderate in Salt",
      "Low in Fat"
    ];
    //ProductUtils.highLowOrModerate(barcode);
    // print("i'm ProductPage");
    if (true) {
      double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
      double multiplier = 10;
      //Product.productInfo[barcode]?.imgURL;
      return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        //white   yellow : const Color(0xFFF2BB05)
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color(0xFF1F1F23)),
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
            padding: const EdgeInsets.all(2.0),
            child: Container(
              height: 100.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: Colors.black54,
                    width: 1,
                  )),
              child: Column(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 100.w,
                    //MediaQuery.of(context).size.width - 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                            width: 1, color: Color(0xFF1F1F23)), //black
                      ),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 12.w,
                            height: 12.h,
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
                                padding: const EdgeInsets.only(top: 15.0),
                                child: AutoSizeText(
                                  '{Product.productInfo[barcode]?.productName}',
                                  //maxFontSize: 30,
                                  minFontSize: 12,
                                  //style: TextStyle(fontSize: 30),
                                  maxLines: 2,
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                              ),
                              AutoSizeText(
                                '{Product.productInfo[barcode]?.size}',
                                //maxFontSize: 30,
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
                    width: 80.w,
                    //MediaQuery.of(context).size.width - 20,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: highLowOrModerate.map((item) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              elevation: 2,
                              //avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: const Text('AH')),
                              child: AutoSizeText(
                                item,
                                style: TextStyle(fontSize: 12.sp),
                                //maxFontSize: 20,
                                //minFontSize: 12,
                                maxLines: 1,
                              )),
                        );
                      }).toList(),
                    ),
                  ),

                  AutoSizeText(
                    '{ProductAnalysis.productAnalysisResult[barcode]?.note}',
                    style: TextStyle(fontSize: 12.sp),
                    //maxFontSize: 20,
                    //minFontSize: 12,
                  ),
                  //Text(
                  //'"This product is high in carbohydrates and sugar, and contains unhealthy fats. It is also a potential source of allergens, including wheat, oats, milk, soy, and sulfites. It may not be a good choice for people who are looking for a healthy snack or meal."',
                  //),
                  const Text(
                    'Bad Ingredients Present:',
                  ),

                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: badIngredients!.map((item) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Chip(
                            //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: 2,
                            backgroundColor: Colors.redAccent,
                            //avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: const Text('AH')),
                            label: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: AutoSizeText(
                                item,
                                //minFontSize: 10.sp,
                                //maxFontSize: 10.sp,
                                maxLines: 1,
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                            labelPadding: const EdgeInsets.all(2.0)),
                      );
                    }).toList(),
                  ),

                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Product Page'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BARCODE IS NUL {-_-} ',
              ),
            ],
          ),
        ),
      );
    }
  }
}
