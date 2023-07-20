import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:optiwiseai/pages/product_page_new.dart';

import 'Database/firebase_db.dart';
import 'OpenFoodFactsAPI/fetch_api.dart';
import 'ProductDetails/product.dart';
import 'ProductDetails/product_analysis.dart';
import 'constant/openAI_constants.dart';
import 'package:optiwiseai/OpenAI/open_ai_api.dart';
import 'package:sizer/sizer.dart';
void main() async {
  //await FirebaseDB.initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String _scanBarcode = 'Unknown';

  bool isProductAvailable = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  late String barcodeScanRes;
  late bool productFoundInFirebaseDB;
  late bool productFoundInOpenFoodFactsDB;
  late bool analysisDoneByLLM;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    bool dataFound = false;
    barcodeScanRes = '8901071706834';
    // Platform messages may fail, so we use a try/catch PlatformException.
    //try {
    //   barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
    //       '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    //   if (kDebugMode) {
    //     print(barcodeScanRes);
    //   }
      print('checking in current session....');

      if(Product.productInfo[barcodeScanRes] != null) {
        print('found!!');
        return;
      } // if user is searching for a product that he searched in current session..
      print('Not found!');

      print('checking in firebase....');

      //check if data related to scanned barcode is already present in the database
      //if present then pull it and store it in Map
      productFoundInFirebaseDB =
          await FirebaseDB.getFirebaseDB(barcodeScanRes);
      // if(productFoundInFirebaseDB == false) {
        if (kDebugMode) {
          print('Not found!');
        }
      // }
       print('Found!');

      if (productFoundInFirebaseDB) {
        Product.productInfo[FirebaseDB.barcodeID] = Product(
            FirebaseDB.productName,
            FirebaseDB.genericName,
            FirebaseDB.size,
            FirebaseDB.ingredients,
            FirebaseDB.imgURL,
            FirebaseDB.nutritionValues,
            FirebaseDB.nutritionDataPer,
        );
        ProductAnalysis.productAnalysisResult[FirebaseDB.barcodeID] = ProductAnalysis(
            FirebaseDB.choice,
            FirebaseDB.badIngredients,
            FirebaseDB.note,
            FirebaseDB.saltLvl,
            FirebaseDB.sugarLvl,
            FirebaseDB.fatLvl,
        );

        return;
      }

      if (kDebugMode) {
        print('checking in Open FOOD Facts ....');
      }
      //else fetch the data from Open Food Facts API and give it to LLM to generate response....
      productFoundInOpenFoodFactsDB = await FetchAPI.fetch(barcodeScanRes);
      if(productFoundInOpenFoodFactsDB == false) {
        if (kDebugMode) {
          print('something wrong with Open Food facts');
           print('Not Found ');
        }
      }
      if (kDebugMode) {
        print('Found!, sending data to LLM');
      }
      AIConstants.barcode = barcodeScanRes;
      analysisDoneByLLM = await OpenAIAPI.generateJSONAnsWithAI();
      if(analysisDoneByLLM) {
        if (kDebugMode) {
          print('LLm: I analysed the Product and ready with result!');
        }
        FirebaseDB.insertProductDataIntoFirebaseDB(barcodeScanRes);
        if (kDebugMode) {
          print('\n System: sending data to firebase....');
        }
        return;
      } else {
            if (kDebugMode) {
              print('something worn with ai');
            }
      }

    // } on PlatformException {
    //   barcodeScanRes = 'Failed to get platform version.';
    // }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType)
    {
      return MaterialApp(
          home: Scaffold(appBar: AppBar(title: const Text('Barcode scan')),
              body: Builder(builder: (BuildContext context) {
                return Container(
                    alignment: Alignment.center,
                    child: Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: () async {
                                await scanBarcodeNormal();
                                if (context.mounted) {
                                  if (kDebugMode) {
                                    print(
                                        'product found: ${FetchAPI
                                            .productNotFound}');
                                  }
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => ProductPage(
                                  //         barcode: barcodeScanRes),
                                  //   ),
                                  // );
                                } else {
                                  showAlertDialog(context);
                                }
                              },
                              child: const Text('Start barcode scan')),
                          ElevatedButton(
                              onPressed: () => FetchAPI.fetch('8906005500090'),
                              child: const Text('Fetch')),
                          ElevatedButton(
                              onPressed: () => OpenAIAPI.cleanData(),
                              child: const Text('OPENAI')),
                          ElevatedButton(
                              onPressed: () {
                                //await scanBarcodeNormal();
                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const ProductPage(
                                          barcode: '8906005500090'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Product page')),
                          Text('Scan result : $_scanBarcode\n',
                              style: const TextStyle(fontSize: 20))
                        ]));
              })));
    }
    );
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = ElevatedButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Ayy New Product Found!!"),
      content: const Text(
          "Use ingredient scanner and scan this product's ingredients-list directly. :)"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
