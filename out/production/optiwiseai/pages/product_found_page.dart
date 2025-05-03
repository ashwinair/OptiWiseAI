import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:optiwiseai/utils/product_utils.dart';

class ProductFoundPage extends StatelessWidget {
  const ProductFoundPage({super.key});

  //final String barcode; 8901725002206
  //const ProductPage({super.key, required this.barcode});
  @override
  Widget build(BuildContext context) {
    // print("i'm ProductPage");
    if (true) {
      var url = "https://m.media-amazon.com/images/I/81yJLRc3B3L.jpg";
          //"https://m.media-amazon.com/images/I/81d8vzofulL._SL1500_.jpg";
      String out =
          '"REFINED PALM OIL", "SUGAR", "INVERT SYRUP", "LIQUID GLUCOSE", "RAISING AGENTS", "MALTODEXTRIN", "EMULSIFERS", "IODIZED SALT", "NATURAL FLAVOUR & NATURAL FLAVOURING SUBSTANCES", "MALT EXTRACT", "ARTIFICIAL FLAVOURING SUBSTANCES", "FLOUR TREATMENT AGENT", "NATURE IDENTICAL FLAVOURING SUBSTANCES"';

      final List<String>? badIngredient = ProductUtils.cleanString(out);
      double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
      double multiplier = 10;
      //Product.productInfo[barcode]?.imgURL;
      return Scaffold(
        backgroundColor: Color(0xFFffb8b9),
        // extendBodyBehindAppBar: true,
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
            padding: const EdgeInsets.all(8.0),
            child: Container(

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: Colors.black54,
                  width: 1,
                )
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                    border:Border(
                  bottom: BorderSide(width: 1, color: Colors.black),
            ),
                    ),

                    child: CachedNetworkImage(
                      imageUrl: url,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  const Text(
                    'Sunfeast Farmlite 5 Grain Digestive Biscuit...',
                    //'${Product.productInfo[barcode]?.productName}',
                    style: TextStyle(fontSize: 15),
                  ),
                  const Text(
                    'goodIngredients:',
                  ),
                  const Text(
                    '"WHEAT FLOUR (51.2%)", "MILK SOLIDS", "OAT FLAKES (0.4%)"',
                    //'${Product.productInfo[barcode]?.goodIngredients}',
                    style: TextStyle(fontSize: 10),
                  ),
                  const Text(
                    'badIngredients:',
                  ),
                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: badIngredient!.map((item) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Chip(
                            elevation: 2,
                            backgroundColor: Colors.redAccent,
                            //avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: const Text('AH')),
                            label: Text(
                              item,
                              style: const TextStyle(fontSize: 11.5),
                            ),
                            labelPadding: const EdgeInsets.all(2.0)),
                      );
                    }).toList(),
                  ),
                  // Text(
                  //   '"REFINED PALM OIL", "SUGAR", "INVERT SYRUP", "LIQUID GLUCOSE", "RAISING AGENTS", "MALTODEXTRIN", "EMULSIFERS", "IODIZED SALT", "NATURAL FLAVOUR & NATURAL FLAVOURING SUBSTANCES", "MALT EXTRACT", "ARTIFICIAL FLAVOURING SUBSTANCES", "FLOUR TREATMENT AGENT", "NATURE IDENTICAL FLAVOURING SUBSTANCES"',
                  //   //'${Product.productInfo[barcode]?.badIngredients}',
                  //   style: TextStyle(fontSize: 11),
                  // ),
                  const Text(
                    'Note:',
                  ),
                  const Text(
                    '"This product is high in carbohydrates and sugar, and contains unhealthy fats. It is also a potential source of allergens, including wheat, oats, milk, soy, and sulfites. It may not be a good choice for people who are looking for a healthy snack or meal."',
                    //'${Product.productInfo[barcode]?.note}',
                    style: TextStyle(fontSize: 15),
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
                'Product NOT FOUND :( ',
              ),
            ],
          ),
        ),
      );
    }
  }
}
