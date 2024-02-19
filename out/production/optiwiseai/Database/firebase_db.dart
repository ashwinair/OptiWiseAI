import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:optiwiseai/ProductDetails/product.dart';
import 'package:optiwiseai/ProductDetails/product_analysis.dart';

import '../firebase_options.dart';

class FirebaseDB {
  static String? barcodeID;
  static String? productName;
  static String? genericName;
  static String? ingredients;
  static String? nutritionDataPer;
  static String? nutritionValues;
  static String? size;
  static String? imgURL;
  static String? choice;
  static String? badIngredients;
  static String? fatLevels;
  static String? totalFat;
  static String? saltLevels;
  static String? totalSalt;
  static String? sugarLevels;
  static String? totalSugar;
  static String? note;

  static initializeFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  static Future<bool> getFirebaseDB(String? barcode) async {
    var snapshot = await FirebaseFirestore.instance
        .collection("products")
        .doc(barcode)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data();
      barcodeID = data?['barcode_id'];
      productName = data?['product_name'];
      genericName = data?['generic_name'];
      ingredients = data?['ingredients'];
      nutritionValues = data?['nutrition_values'];
      nutritionDataPer = data?['nutrition_data_per'];
      size = data?['size'];
      imgURL = data?['img_url'];
      choice = data?['choice'];
      badIngredients = data?['bad_ingredients'];
      fatLevels = data?['fat_levels'];
      totalFat = data?['total_fat'];
      saltLevels = data?['salt_levels'];
      totalSalt = data?['total_salt'];
      sugarLevels = data?['sugar_levels'];
      totalSugar = data?['total_sugar'];
      note = data?['note'];
      return true;
    } else {
      return false;
    }
  }

  static void insertProductDataIntoFirebaseDB(String? barcode) async {
    String? productName = Product.productInfo[barcode]?.productName;
    String? genericName = Product.productInfo[barcode]?.genericName;
    String? ingredients = Product.productInfo[barcode]?.ingredients;
    String? nutritionDataPer = Product.productInfo[barcode]?.nutritionDataPer;
    String? nutritionValues = Product.productInfo[barcode]?.nutritionValues
        .toString()
        .replaceAll('{', '')
        .replaceAll('}', '');
    String? size = Product.productInfo[barcode]?.size;
    String? imgURL = Product.productInfo[barcode]?.imgURL;

    String? choice = ProductAnalysis.productAnalysisResult[barcode]?.choice;
    String? badIngredients = ProductAnalysis
        .productAnalysisResult[barcode]?.badIngredients
        .toString();
    String? fatLevels =
        ProductAnalysis.productAnalysisResult[barcode]!.fatLevels;
    String? totalFat = ProductAnalysis.productAnalysisResult[barcode]!.totalFat;
    String? saltLevels =
        ProductAnalysis.productAnalysisResult[barcode]!.saltLevels;
    String? totalSalt =
        ProductAnalysis.productAnalysisResult[barcode]!.totalSalt;
    String? sugarLevels =
        ProductAnalysis.productAnalysisResult[barcode]!.sugarLevels;
    String? totalSugar =
        ProductAnalysis.productAnalysisResult[barcode]!.totalSugar;
    String? note = ProductAnalysis.productAnalysisResult[barcode]?.note;

    Map<String, String?> data = {
      'barcode_id': barcode,
      'product_name': productName,
      'generic_name': genericName,
      'ingredients': ingredients,
      'nutrition_data_per': nutritionDataPer,
      'nutrition_values': nutritionValues,
      'size': size,
      'img_url': imgURL,
      'choice': choice,
      'bad_ingredients': badIngredients,
      'note': note,
      'fat_levels': fatLevels,
      'total_fat': totalFat,
      'salt_levels': saltLevels,
      'total_salt': totalSalt,
      'sugar_levels': sugarLevels,
      'total_sugar': totalSugar,
    };

    // Write the data to the database in the background.
    await _writeDataToFirestoreInBackground('products/$barcode', data);
  }

  static Future<void> _writeDataToFirestoreInBackground(
      String path, Map<String, dynamic> data) async {
    // Get a reference to the Cloud Firestore database.
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;

    // Get a reference to the path where the data will be written.
    final DocumentReference reference = fireStore.doc(path);

    // Write the data to the database in the background.
    await reference.set(data);

    print('Updated Firebase!');
  }
}
