import 'package:flutter/foundation.dart';

import '../Database/firebase_db.dart';
import '../OpenAI/open_ai_api.dart';
import '../OpenFoodFactsAPI/fetch_api.dart';
import '../ProductDetails/product.dart';
import '../ProductDetails/product_analysis.dart';
import '../constant/openAI_constants.dart';

class FindAndAnalysisProduct {
  static late bool problemWithAI;
  static late String barcode;

  static Future<bool> checkAndGetData(String barcodeID) async {
    if (kDebugMode) {
      print('checking in current session....');
      print(barcodeID);
    }
    barcode = barcodeID;
    if (Product.productInfo[barcodeID] != null) {
      return true;
    } else if (await isProductFoundInFirebaseDB()) {
      return true;
    } else if (await isProductFoundInOpenFoodFactsDB()) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> isProductFoundInFirebaseDB() async {
    //check if data related to scanned barcode is already present in the database
    //if present then pull it and store it in Map
    if (kDebugMode) {
      print('Not found!');
      print('checking in firebase....');
      print('searching in firebase');
    }
    if (await FirebaseDB.getFirebaseDB(barcode)) {
      if (kDebugMode) {
        print('Found!');
      }
      Product.productInfo[barcode] = Product(
        FirebaseDB.productName,
        FirebaseDB.genericName,
        FirebaseDB.size,
        FirebaseDB.ingredients,
        FirebaseDB.imgURL,
        FirebaseDB.nutritionValues,
        FirebaseDB.nutritionDataPer,
      );
      ProductAnalysis.productAnalysisResult[barcode] = ProductAnalysis(
        FirebaseDB.choice,
        FirebaseDB.badIngredients,
        FirebaseDB.note,
        FirebaseDB.fatLevels,
        FirebaseDB.totalFat,
        FirebaseDB.saltLevels,
        FirebaseDB.totalSalt,
        FirebaseDB.sugarLevels,
        FirebaseDB.totalSugar,
      );
      return true;
    }
    return false;
  }

  static Future<bool> isProductFoundInOpenFoodFactsDB() async {
    if (kDebugMode) {
      print('Not found!');
      print('checking in Open FOOD Facts DB....');
    }
    //fetch the data from Open Food Facts API and give it to LLM to generate response....
    if (await FetchAPI.fetch(barcode)) {
      if (kDebugMode) print('Found!, sending data to LLM for analysis...');

      AIConstants.barcode = barcode;
      var analysisDoneByLLM = await OpenAIAPI.generateJSONAnsWithAI();
      if (analysisDoneByLLM) {
        if (kDebugMode) {
          print('LLm: I analysed the Product and ready with result!');
        }
        problemWithAI = false;
        FirebaseDB.insertProductDataIntoFirebaseDB(barcode);
        if (kDebugMode) print('\n System: sending data to firebase....');

        return true;
      } else {
        problemWithAI = true;
        if (kDebugMode) {
          print('something went wrong with ai');
        }
      }
    }
    return false;
  }
}
