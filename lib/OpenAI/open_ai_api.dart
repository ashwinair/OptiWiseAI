import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart';
import 'package:optiwiseai/ProductDetails/product_analysis.dart';
import 'package:optiwiseai/constant/openAI_constants.dart';

import '../OpenFoodFactsAPI/fetch_api.dart';
import '../ProductDetails/product.dart';

class OpenAIAPI {
  static var aiResult;

  static Future<bool> generateJSONAnsWithAI() async {
    try {
      if (kDebugMode) {
              print('LLm: analyzing.....');
            }
      OpenAI.apiKey = AIConstants.apiKEY;
      OpenAIChatCompletionModel response = await OpenAI.instance.chat.create(
        temperature: 0.2,
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: AIConstants.prompt,
            role: OpenAIChatMessageRole.system,
          ),
        ],
      );
      if (kDebugMode) {
              print('LLm: Done.');
            }
      aiResult = jsonDecode(response.choices.first.message.content);
      ProductAnalysis.productAnalysisResult[AIConstants.barcode] =
          ProductAnalysis(
        aiResult[0]["choice"],
        aiResult[0]['bad_ingredients'].toString().replaceAll('[','').replaceAll(']', ''),
        aiResult[0]['note'],
        aiResult[0]['salt_levels'],
        aiResult[0]['sugar_levels'],
        aiResult[0]['fat_levels'],
      );

      if (kDebugMode) {
        print(response.choices.first.message.content);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }

    return true;
  }

  static Future<void> cleanData() async {
    String res = '''[{
 "choice": "Bad",
 "bad_ingredients": ["Sugar", "Salt", "Acidity Regulator - 260", "Stabilizers - 1422 415", "Preservative - 211"],
 "sugar_levels":{"amount": "4.8g","levels" : "High"},
 "salt_levels":{"amount": "136mg", "levels" : "Moderate"},
 "fat_levels":{"amount" : "0.02g", "levels" : "Low"},
 "note": "This tomato sauce contains high levels of sugar and moderate levels of salt. It also contains several additives such as acidity regulator, stabilizers, and preservatives, which are not ideal for a healthy diet."
 }]''';

    //await FetchAPI.fetch('8906005500090');
    var jsonRes = jsonDecode(res);
    //List<String> sugarLevels;
    //sugarLevels = jsonRes[0]['bad_ingredients'];

    if (kDebugMode) {
      print(jsonRes[0]['bad_ingredients'].toString());
      //print("sugarLevels: $sugarLevels");
    }
  }
}

//todo: Analyze verbose
//response.choices.first.message.content will provide only the json response
// [OpenAI] api key set to ****oIATziCMQD
// [OpenAI] accessing endpoint: /chat/completions
// [OpenAI] starting request to https://api.openai.com/v1/chat/completions
// [{
// "choice": "Bad",
// "bad_ingredients": ["Sugar", "Salt", "Acidity Regulator - 260", "Stabilizers - 1422 415", "Preservative - 211"],
// "sugar_levels":{"amount": "4.8g","levels" : "High"},
// "salt_levels":{"amount": "136mg", "levels" : "Moderate"},
// "fat_levels":{"amount" : "0.02g", "levels" : "Low"},
// "note": "This tomato sauce contains high levels of sugar and moderate levels of salt. It also contains several additives such as acidity regulator, stabilizers, and preservatives, which are not ideal for a healthy diet."
// }]
// [OpenAI] request to https://api.openai.com/v1/chat/completions finished with status code 200
// [OpenAI] starting decoding response body
// [OpenAI] response body decoded successfully
// [OpenAI] request finished successfully
