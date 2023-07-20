//import 'package:google_ml_kit/google_ml_kit.dart';

import '../ProductDetails/product_analysis.dart';

class ProductUtils {

  static List<String> highLowOrModerate(String barcode) {
    final List<String> highLowOrModerateValues = [];
    final List<String> levels = ['Salt', 'Sugar', 'Fat'];

    for (String level in levels) {
      if (getLevel(barcode, level) == 'high') {
        highLowOrModerateValues.add("High in $level");
      } else if (getLevel(barcode, level) == 'moderate') {
        highLowOrModerateValues.add("Moderate in $level");
      } else {
        highLowOrModerateValues.add("Low in $level");
      }
    }

    return highLowOrModerateValues;
  }

  static List<String>? badIngredients(String barcode) {
    return cleanString(ProductAnalysis
        .productAnalysisResult[barcode]?.badIngredients);
  }

  static List<String>? cleanString(String? output) {
    var clean = output?.replaceAll('"', '');
    List<String>? ingredientsList = clean?.split(', ');
    return ingredientsList;
  }

  // static String scanIngredinetsText() {
  //
  //  // Create a TextRecognizer object.
  //  final textRecognizer = TextRecognizer();
  //
  //  // Set the hint text.
  //  textRecognizer.hintText = 'Ingredients';
  //
  //  // Scan the image for the text.
  //  final recognizedText = textRecognizer.processImage();
  //
  //  // Find the index of the first occurrence of the text "Ingredients".
  //  final ingredientsStartIndex = recognizedText.indexOf('Ingredients');
  //
  //  // Get the text from the ingredient section.
  //  final ingredientsText = recognizedText.substring(ingredientsStartIndex);
  //
  //  // Print the ingredients.
  //  for (final ingredient in ingredientsText.split(',')) {
  //    print(ingredient);
  //  }
  //
  //
  //  return 'Ashwin';
  // }

  static bool submitToAI() {
    return true;
  }

  static void scanProductDetails() {}

  static String? getLevel(String barcode, String level) {
    String? lvl;
    if(level == 'Salt') {
      lvl = 'saltLvl';
    } else if(level == 'Sugar') {
      lvl = 'sugarLvl';
    } else{
      lvl = 'fatLvl';
    }

    if (lvl == 'saltLvl') {
      return ProductAnalysis
          .productAnalysisResult[barcode]!.saltLvl?['levels']
          .toString()
          .toLowerCase();
    }
    else if (lvl == 'sugarLvl') {
      return ProductAnalysis
          .productAnalysisResult[barcode]!.sugarLvl?['levels']
          .toString()
          .toLowerCase();
    }
    else {
      return ProductAnalysis.productAnalysisResult[barcode]!.fatLvl?['levels']
          .toString()
          .toLowerCase();
    }

  }
}
