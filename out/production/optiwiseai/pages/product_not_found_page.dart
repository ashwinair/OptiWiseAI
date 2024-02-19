import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:optiwiseai/utils/product_utils.dart';

//ProductNotFoundPage: we check in foodfacts API if the barcode scanned by the user exists, if not we take what details we have
//like name , ingredients , nutrition value (which is not that important right now but we can if they want to submit)
// then if only ask user to submit the details we don't have (in most cases it is going to be list of ingredients).
//then we take all that information and provide it to GPT to get the answer, then we take that answer and provide it to user and submit it to firebase
//using multi-threading.


class ProductNotFoundPage extends StatelessWidget {
  const ProductNotFoundPage({super.key});
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFffb8b9),
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
                  ElevatedButton(onPressed:() => ProductUtils.scanProductDetails(),
                      child: const Text('Scan name of the product')
                  ),

                  // ElevatedButton(onPressed: () => ProductUtils.submitToAI(),
                  //     child: const Text('Done')
                  // ),
                ],
              ),
            ),
          ),
        ),
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

