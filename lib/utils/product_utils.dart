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
      } else if (getLevel(barcode, level) == 'low') {
        highLowOrModerateValues.add("Low in $level");
      }
    }

    return highLowOrModerateValues;
  }

  static List<String>? badIngredients(String barcode) {
    return cleanString(
        ProductAnalysis.productAnalysisResult[barcode]?.badIngredients);
  }

  static List<String>? cleanString(String? output) {
    var clean = output?.replaceAll('"', '');
    List<String>? ingredientsList = clean?.split(', ');
    return ingredientsList;
  }

  static void scanProductDetails() {}

  static String? getLevel(String barcode, String level) {
    String? lvl;
    if (level == 'Salt') {
      lvl = 'saltLvl';
    } else if (level == 'Sugar') {
      lvl = 'sugarLvl';
    } else if (level == 'Fat') {
      lvl = 'fatLvl';
    }

    if (lvl == 'saltLvl') {
      return ProductAnalysis.productAnalysisResult[barcode]!.saltLevels
          ?.toLowerCase();
    } else if (lvl == 'sugarLvl') {
      return ProductAnalysis.productAnalysisResult[barcode]!.sugarLevels
          ?.toLowerCase();
    } else if (lvl == 'fatLvl') {
      return ProductAnalysis.productAnalysisResult[barcode]!.fatLevels
          ?.toLowerCase();
    }
    return null;
  }
}
