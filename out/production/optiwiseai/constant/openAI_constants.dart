import 'package:optiwiseai/ProductDetails/product.dart';

class AIConstants {
  static String apiKEY = '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'; //optiwiseAI API KEY
  static String? barcode;
//Generic Name: ${Product.productInfo[barcode]?.genericName}
// size: ${Product.productInfo[barcode]?.size}
// Ingredients list: ${Product.productInfo[barcode]?.ingredients}
//
// Nutrition value: ${Product.productInfo[barcode]?.nutritionValues}

  static  String prompt = '''System: pretend you are an expert dietitian and nutritionist 
  Create a list of bad ingredients by analyzing all the ingredients of the product provided. The name of the ingredients used in the product will be listed in descending order of their composition by weight or volume.
  
Generic Name: ${Product.productInfo[barcode]?.genericName}
size: ${Product.productInfo[barcode]?.size}
Ingredients list: ${Product.productInfo[barcode]?.ingredients}
Nutrition value: Nutrition Data Per: ${Product.productInfo[barcode]?.nutritionDataPer},

${Product.productInfo[barcode]?.nutritionValues
      .toString().replaceAll('  ', ' ').replaceAll('{', '').replaceAll('}', '')}

check all the above information and evaluate the product carefully to provide results.
Do not include any explanations, only provide a  RFC8259 compliant JSON response following this format without deviation.
[{
"choice": "Good or Bad or Unsure"
"bad_ingredients": "List of bad ingredients",
"sugar_levels":{"amount": "total Sugar in string",
"levels" : "High" or "Moderate" or "Low"}
"salt_levels":{"amount": "total Salt in string", 
"levels" : "High" or "Moderate" or "Low"}
"fat_levels":{"amount" : "total Fat in String", 
"levels" : "High" or "Moderate" or "Low"}
"note": "Explain briefly why it will be a good or bad choice to buy based on results."
}]''';

}