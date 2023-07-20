import 'dart:collection';
import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:optiwiseai/ProductDetails/product.dart';


class FetchAPI {

static bool productNotFound = false;
static Future<bool> fetch(String? barcodeID) async {
   //int barcodeOutput = barcodeID;

//8906005500090
//   var url =
//       Uri.https('world.openfoodfacts.org', '/api/v0/product/$barcodeOutput.json', {'q': '{}'});

  // Await the http get response, then decode the json-formatted response.
  // www.world.openfoodfacts.org/api/v0/product/$barcodeOutput.json
  print('fetching.....');
  final response = await http
      .get(Uri.parse('https://world.openfoodfacts.org/api/v2/product/$barcodeID.json'));
  if (response.statusCode == 200) {
    print('scanning.....');
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    //print("json: $jsonResponse");
    if(jsonResponse['status'] == 0 || jsonResponse['status_verbose: '] == 'product not found' ) {
      productNotFound = true;
      if (kDebugMode) {
        print('not found');
      }
        return false;
      }

     Product.productInfo[barcodeID] = Product(
            jsonResponse['product']['product_name'],
            jsonResponse['product']['categories'],
            jsonResponse['product']['quantity'],
            jsonResponse['product']['ingredients_text'],
            jsonResponse['product']['image_url'],
            jsonResponse['product']['nutriments'],
            jsonResponse['product']['nutrition_data_per']
     );


    // var productName = jsonResponse['product']['product_name'];
    // var ingredientsText = jsonResponse['product']['ingredients_text'];
    // var nutrimentsText = jsonResponse['product']['nutriments'].toString();
    // var categories = jsonResponse['product']['categories'];

    if (kDebugMode) {
      // print('productName: $productName');
      // print('ingredientsText: $ingredientsText');
      // print('nutrimentsText: $nutrimentsText');
    }
    //add the info in the HashMap
    //Product.productInfo[barcode] = Product(productName, ingredientsText, nutrimentsText);
    // productFound = productInfo.isNotEmpty;
    // print("i'm near productInfo");
    return true;
  } else {
    if (kDebugMode) {
      print('Request failed with status: ${response.statusCode}.');
    }
    return false;
  }
}



}