// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:optiwiseai/pages/product_info_page.dart';
// import 'package:sizer/sizer.dart';
// import 'package:typewritertext/typewritertext.dart';
//
// import '../Database/firebase_db.dart';
// import '../OpenAI/open_ai_api.dart';
// import '../OpenFoodFactsAPI/fetch_api.dart';
// import '../ProductDetails/product.dart';
// import '../ProductDetails/product_analysis.dart';
// import '../constant/openAI_constants.dart';
// import '../utils/find_and_analysis.dart';
//
// class BarcodeScannerLoadingScreen extends StatefulWidget {
//
//   final String barcode;
//
//   const BarcodeScannerLoadingScreen({super.key, required this.barcode});
//
//
//   @override
//   BarcodeScannerLoadingScreenState createState() =>
//       BarcodeScannerLoadingScreenState();
// }
//
// class BarcodeScannerLoadingScreenState
//     extends State<BarcodeScannerLoadingScreen> {
//
//   late Future<bool> _value;
//
//   late String barcodeScanRes;
//   late bool productFoundInFirebaseDB;
//   late bool productFoundInOpenFoodFactsDB;
//   late bool analysisDoneByLLM;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//       return Scaffold(
//         backgroundColor: Colors.white,
//         body: Padding(
//           padding: const EdgeInsets.all(5.0),
//           child: SizedBox(
//             height: 100.h,
//             width: 100.w,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                Center(
//                         child: Column(
//                           children: [
//                             SizedBox(
//                                 width: 60.w,
//                                 height: 60.w,
//                                 child: Lottie.asset(
//                                     'assets/BarcodeScanner.json')
//                             ),
//                             const Padding(padding: EdgeInsets.only(
//                                 bottom: 5.0)),
//
//                             Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Column(
//                                 children: [
//                                   TypeWriterText(
//                                     play: true,
//                                     maintainSize: false,
//                                     alignment: Alignment.topCenter,
//                                     text: Text(
//                                         barcodeScanRes,style: TextStyle(fontSize: 12.sp),),
//                                     duration: const Duration(milliseconds: 60),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: SizedBox(
//                                       child: Center(
//                                         child: TypeWriterText(
//                                           maintainSize: false,
//                                           play: true,
//                                           repeat: true,
//                                           text: Text(
//                                           '${(Product.productInfo[barcodeScanRes] != null)
//                                               ? Product.productInfo[barcodeScanRes]
//                                               ?.productName : 'Analyzing....'}'
//                                 ),
//                                 duration: const Duration(milliseconds:5),
//                               ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//
//                           ],
//                         ),
//                 ),
//               ],
//
//             ),
//           ),
//         ),
//       );
//
//   }
//    showAlertDialog(BuildContext context) {
//      Navigator.push(
//        context,
//        MaterialPageRoute(
//          builder: (context) =>
//              ProductPage(
//                  barcode: barcodeScanRes),
//        ),
//      );
//    }
//  Future<bool> _valueFound() async {
//     barcodeScanRes = widget.barcode;
//    if (kDebugMode) {
//      print('checking in current session....');
//    }
//
//       if(Product.productInfo[barcodeScanRes] != null) {
//         if (kDebugMode) {
//           print('found!!');
//         }
//         return true;
//       } // if user is searching for a product that he searched in current session..
//       if (kDebugMode) {
//         print('Not found!');
//         print('checking in firebase....');
//       }
//
//       //check if data related to scanned barcode is already present in the database
//       //if present then pull it and store it in Map
//       productFoundInFirebaseDB =
//           await FirebaseDB.getFirebaseDB(barcodeScanRes);
//
//
//
//       if (productFoundInFirebaseDB) {
//         Product.productInfo[FirebaseDB.barcodeID] = Product(
//            FirebaseDB.productName,
//            FirebaseDB.genericName,
//            FirebaseDB.size,
//            FirebaseDB.ingredients,
//            FirebaseDB.imgURL,
//            FirebaseDB.nutritionValues,
//            FirebaseDB.nutritionDataPer,
//          );
//         ProductAnalysis.productAnalysisResult[FirebaseDB.barcodeID] = ProductAnalysis(
//                FirebaseDB.choice,
//                FirebaseDB.badIngredients,
//                FirebaseDB.note,
//                FirebaseDB.fatLevels,
//                FirebaseDB.totalFat,
//                FirebaseDB.saltLevels,
//                FirebaseDB.totalSalt,
//                FirebaseDB.sugarLevels,
//                FirebaseDB.totalSugar,
//              );
//           if (kDebugMode) {
//          print('Found!');
//        }
//         return true;
//       }
//
//       if (kDebugMode) {
//         print('Not found!');
//         print('checking in Open FOOD Facts ....');
//       }
//       //else fetch the data from Open Food Facts API and give it to LLM to generate response....
//       productFoundInOpenFoodFactsDB = await FetchAPI.fetch(barcodeScanRes);
//       print(productFoundInOpenFoodFactsDB);
//       if(productFoundInOpenFoodFactsDB == false) {
//         if (kDebugMode) {
//           print('something wrong with Open Food facts');
//            print('Not Found ');
//         }
//       }
//       if (kDebugMode) {
//         print('Found!, sending data to LLM');
//       }
//       AIConstants.barcode = barcodeScanRes;
//       analysisDoneByLLM = await OpenAIAPI.generateJSONAnsWithAI();
//       if(analysisDoneByLLM) {
//         FirebaseDB.insertProductDataIntoFirebaseDB(barcodeScanRes);
//         if (kDebugMode) {
//           print('LLm: I analysed the Product and ready with result!');
//           print('\n System: sending data to firebase....');
//         }
//         return true;
//       } else {
//             if (kDebugMode) {
//               print('something went wrong with ai');
//             }
//       }
//   return false;
// }
// }
//
