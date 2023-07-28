import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:optiwiseai/pages/product_info_page.dart';
import 'package:sizer/sizer.dart';
import 'Database/firebase_db.dart';

void main() async {
  await FirebaseDB.initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  late String barcodeScanRes;

   //  Platform messages are asynchronous, so we initialize in an async method.
     Future<void> scanBarcodeNormal() async {
       //Platform messages may fail, so we use a try/catch PlatformException.
       try {
         barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
             '#ff6666', 'Cancel', true, ScanMode.BARCODE);
         if (kDebugMode) {
           print(barcodeScanRes);
         }

       } on PlatformException {
         barcodeScanRes = 'Failed to get platform version.';
       }
       // If the widget was removed from the tree while the asynchronous platform
       // message was in flight, we want to discard the reply rather than calling
       // setState to update our non-existent appearance.
       if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder:
        (BuildContext context, Orientation orientation, DeviceType deviceType) {
      return MaterialApp(
          home: Scaffold(
            backgroundColor: const Color(0xFF141414),
              body: Builder(builder: (BuildContext context) {
                return Container(
                  width: 100.w,
                    height: 100.h,
                    alignment: Alignment.center,
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('OptiWise.AI',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                            fontFamily: 'Epilogue',  color: Colors.white,
                                    fontSize: 20.sp, fontWeight: FontWeight.bold,),
                            ),
                            const Padding(padding: EdgeInsets.only(bottom: 30.0)),
                            Text("[ know whats inside your food product ]",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                              fontFamily: 'Epilogue',  color: Colors.white54,
                                      fontSize: 10.sp, fontWeight: FontWeight.bold),
                            ),
                             Padding(padding: EdgeInsets.only(bottom: 50.w)),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                  padding: const EdgeInsets.all(5.0),
                                  backgroundColor: const Color(0xFFfff250),
                                ),
                                onPressed: () async{
                                await scanBarcodeNormal();
                                if (context.mounted && int.parse(barcodeScanRes) > 0 ) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductPage(
                                            barcode:  barcodeScanRes),),
                                  );
                                }
                                },
                                child: Text('scan barcode',style: TextStyle(
                                    fontFamily: 'Epilogue', color:  const Color(0xFF141414),
                                      fontSize: 20.sp, fontWeight: FontWeight.bold),)),
                          ]),
                    ));
              })));
    });
  }
}

