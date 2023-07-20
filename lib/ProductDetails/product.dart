

class Product { // General Details about the product
  final String? productName;
  final String? genericName;
  final String? size;
  final String? ingredients;
  final String? imgURL;
  final Map<String, dynamic>? nutritionValues;
  final String? nutritionDataPer;

  Product(
       this.productName,this.genericName, this.size, this.ingredients,
       this.imgURL, this.nutritionValues, this.nutritionDataPer,
      );

  //barcode number, product name, ingredients, nutriments
static Map<String?, Product> productInfo = {};


}

