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
  static String? size;
  static String? ingredients;
  static String? imgURL;
  static Map<String, dynamic>? nutritionValues;
  static String? nutritionDataPer;
  static String? choice;
  static String? badIngredients;
  static String? note;
  static Map<String, dynamic>? saltLvl;
  static Map<String, dynamic>? sugarLvl;
  static Map<String, dynamic>? fatLvl;

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
      Map<String, dynamic> data = snapshot.data()!;
      barcodeID = data['barcode_id'];
      productName = data['product_name'];
      genericName = data['generic_name'];
      badIngredients = data['bad_ingredients'];
      ingredients = data['ingredients'];
      imgURL = data['img_url'];
      note = data['note'];
      nutritionValues = data['nutrition_values'];


      return true;
    } else {
      return false;
    }
  }


static void insertProductDataIntoFirebaseDB(String barcode) async{

    String? productName = Product.productInfo[barcode]?.productName;
    String? genericName = Product.productInfo[barcode]?.genericName;
    String? ingredients = Product.productInfo[barcode]?.ingredients;
    String? nutritionDataPer = Product.productInfo[barcode]?.nutritionDataPer;
    String? nutritionValues =  Product.productInfo[barcode]?.nutritionValues
        .toString().replaceAll('{', '').replaceAll('}', '');
    String? size =  Product.productInfo[barcode]?.size;
     String? imgURL = Product.productInfo[barcode]?.imgURL;

    String? choice = ProductAnalysis.productAnalysisResult[barcode]?.choice;
    String? badIngredients = ProductAnalysis.productAnalysisResult[barcode]?.badIngredients.toString();
    String? fatLevels = ProductAnalysis.productAnalysisResult[barcode]!.fatLvl?["levels"];
    String? totalFat = ProductAnalysis.productAnalysisResult[barcode]!.fatLvl?["amount"];
    String? saltLevels = ProductAnalysis.productAnalysisResult[barcode]!.saltLvl?["levels"];
    String? totalSalt = ProductAnalysis.productAnalysisResult[barcode]!.saltLvl?["amount"];
    String? sugarLevels = ProductAnalysis.productAnalysisResult[barcode]!.sugarLvl?["levels"];
    String? totalSugar = ProductAnalysis.productAnalysisResult[barcode]!.sugarLvl?["amount"];
    String? note = ProductAnalysis.productAnalysisResult[barcode]?.note;


    Map<String, String?> data = {
      'barcode_id': barcode,
      'product_name': productName,
      'generic_name' : genericName,
      'ingredients' : ingredients,
      'nutrition_data_per' : nutritionDataPer,
      'nutrition_values' : nutritionValues,
      'size' : size,
      'img_url' : imgURL,
      'choice' : choice,
      'bad_ingredients' : badIngredients,
      'note' : note,
      'fat_levels': fatLevels,
      'total_fat': totalFat,
      'salt_levels': saltLevels,
      'total_salt': totalSalt,
      'sugar_levels': sugarLevels,
      'total_sugar': totalSugar,
  };

  // Write the data to the database in the background.
  await _writeDataToFirestoreInBackground('products/$barcode', data);

  // [{
// I/flutter (20998): "choice": "Bad",
// I/flutter (20998): "bad_ingredients": ["Sugar", "Invert sugar", "Liquid glucose", "Cocoa solids", "Malt extract", "Thickening agent (415)", "Preservative (202)", "Salt"],
// I/flutter (20998): "sugar_levels":{"amount": "High","levels" : ["High"]},
// I/flutter (20998): "salt_levels":{"amount": "Moderate", "levels" : ["Moderate"]},
// I/flutter (20998): "fat_levels":{"amount" : "Low", "levels" : ["Low"]},
// I/flutter (20998): "note": "This product contains high levels of sugar, which can contribute to weight gain and increase the risk of chronic diseases such as diabetes and heart disease. It also contains moderate levels of salt, which can lead to high blood pressure. The low fat content is a positive aspect, but it does not outweigh the negative effects of the high sugar and salt content. It is not a good choice for a healthy diet."
// I/flutter (20998): }]




}


static Future<void> _writeDataToFirestoreInBackground(String path, Map<String, dynamic> data) async {
  // Get a reference to the Cloud Firestore database.
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  // Get a reference to the path where the data will be written.
  final DocumentReference reference = fireStore.doc(path);

  // Write the data to the database in the background.
  await reference.set(data);

  print('Updated Firebase!');
}


}
// rules_version = '2';
// service cloud.firestore {
// match /databases/{database}/documents {
//  match /{document=**} {
//   allow read, write: if request.auth != null;
//   }
//  }
// }
