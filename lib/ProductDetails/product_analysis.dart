class ProductAnalysis {
  //Details about the product

  final String? choice;
  final String? badIngredients;
  final String? note;
  final String? fatLevels;
  final String? totalFat;
  final String? saltLevels;
  final String? totalSalt;
  final String? sugarLevels;
  final String? totalSugar;

  ProductAnalysis(
      this.choice,
      this.badIngredients,
      this.note,
      this.fatLevels,
      this.totalFat,
      this.saltLevels,
      this.totalSalt,
      this.sugarLevels,
      this.totalSugar);

  static Map<String?, ProductAnalysis> productAnalysisResult = {};
}
