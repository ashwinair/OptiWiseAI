import 'package:optiwiseai/ProductDetails/product.dart';

class AIConstants {
  static String apiKEY = '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'; //optiwiseAI API KEY
  static String? barcode;



  static  String prompt = '''System: pretend you are an expert dietitian and nutritionist, specializing in providing guidance for individuals with diabetes.
Create a list of bad ingredients by analyzing all the ingredients of the product provided. The name of the ingredients used in the product will be listed in descending order of their composition by weight or volume.

Generic Name: ${Product.productInfo[barcode]?.genericName}
Size: ${Product.productInfo[barcode]?.size}
Ingredients List: ${Product.productInfo[barcode]?.ingredients}
Nutrition Value: Nutrition Data Per: ${Product.productInfo[barcode]?.nutritionDataPer},

${Product.productInfo[barcode]?.nutritionValues
  .toString().replaceAll('  ', ' ').replaceAll('{', '').replaceAll('}', '')}

Please thoroughly evaluate the product's ingredients and nutritional data with a focus on their impact on blood sugar levels. Do not include any explanations, only provide an RFC8259 compliant JSON response following this format without deviation.
[{
"choice": "Good or Bad or Unsure"
"bad_ingredients": "List of bad ingredients",
"sugar_levels":{"amount": "total Sugar in string",
"levels" : "High" or "Moderate" or "Low"}
"salt_levels":{"amount": "total Salt in string",
"levels" : "High" or "Moderate" or "Low"}
"fat_levels":{"amount" : "total Fat in String",
"levels" : "High" or "Moderate" or "Low"}
"note": "write a short note on nutritional quality specifically for diabetic individuals."
}]''';

}