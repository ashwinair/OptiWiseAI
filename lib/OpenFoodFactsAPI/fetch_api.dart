import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:optiwiseai/ProductDetails/product.dart';

class FetchAPI {
  static bool productNotFound = false;

  static Future<bool> fetch(String? barcodeID) async {
    // Await the http get response, then decode the json-formatted response.
    // www.world.openfoodfacts.org/api/v0/product/$barcodeOutput.json
    print('fetching.....');
    final response = await http.get(Uri.parse(
        'https://world.openfoodfacts.org/api/v3/product/$barcodeID.json'));
    if (response.statusCode == 200) {
      print('scanning.....');
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      //print("json: $jsonResponse");
      if (jsonResponse['status'] == 0 ||
          jsonResponse['status_verbose: '] == 'product not found') {
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
          jsonResponse['product']['nutriments'].toString(),
          jsonResponse['product']['nutrition_data_per']);
      return true;
    } else {
      productNotFound = true;
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
      return false;
    }
  }
}
