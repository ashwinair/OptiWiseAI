//
// import 'dart:io';
// import 'dart:io';
//
// import 'package:google_ml_kit/google_ml_kit.dart';
//
// class ExtractTextFromImage{
//
//   static Future<String> processImage(File imageFile) async{
//     try {
//       final inputImage = InputImage.fromFile(imageFile);
//       final textRecognizer = GoogleMlKit.vision.textRecognizer();
//       final recognizedText = await textRecognizer.processImage(inputImage);
//       String recognizedTextString = '';
//
//       for(TextBlock block in recognizedText.blocks){
//         for(TextLine line in block.lines){
//           recognizedTextString += line.text;
//         }
//         recognizedTextString += '\n';
//
//       }
//       textRecognizer.close();
//       return recognizedTextString;
//     } catch (e){
//       return 'Error processing image: $e';
//     }
//   }
//
// }