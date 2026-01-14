// lib/Repository/product_repository.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Api Services/api_service.dart';
import '../Api Services/response.dart';
import '../Model/analysis_model.dart';
import '../Model/knowledge_base_item.dart';
import '../Model/product.dart';
import '../supabase_config.dart';
import '../Utils/encoding_utils.dart';

class ProductRepository {
  // This field is reserved for API calls (e.g., Gemini/OpenAI) in other
  // methods; keep it here for future use. Suppress unused-field warning.
  // ignore: unused_field
  final ApiService _apiService;

  ProductRepository(this._apiService);

  // Knowledge base map: ingredient name (lowercase) -> KnowledgeBaseItem
  final Map<String, KnowledgeBaseItem> _knowledgeBase = {};
  bool _knowledgeBaseLoaded = false;

  // Load knowledge base from assets/json/knowledge_base.json
  Future<void> initializeKnowledgeBase() async {
    if (_knowledgeBaseLoaded) return;
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/json/knowledge_base.json',
      );
      final List<dynamic> jsonList = jsonDecode(jsonString);
      for (var item in jsonList) {
        final kbItem = KnowledgeBaseItem.fromJson(item);
        for (var name in kbItem.names) {
          _knowledgeBase[name.toLowerCase()] = kbItem;
        }
      }
      _knowledgeBaseLoaded = true;
      print('Knowledge base loaded with \\${_knowledgeBase.length} entries.');
    } catch (e) {
      print('Failed to load knowledge base: \\${e.toString()}');
    }
  }

  // Lookup risk info for an ingredient
  KnowledgeBaseItem? getIngredientInfo(String ingredientName) {
    return _knowledgeBase[ingredientName.toLowerCase()];
  }

  // Example enrichment method: takes a list of ingredient names and returns risk info
  Future<List<Map<String, dynamic>>> enrichIngredientsWithRisk(
    List<String> ingredients,
  ) async {
    await initializeKnowledgeBase();
    return ingredients.map((name) {
      final info = getIngredientInfo(name);
      return {
        'name': name,
        'risk': info?.risk ?? 'Unknown',
        'category': info?.category ?? 'Unknown',
      };
    }).toList();
  }

  //   Future<ApiResponse<Product>> scanProductOpenAi(File imageFile) async {
  //     try {
  //       // Convert image to base64
  //       final bytes = await imageFile.readAsBytes();
  //       final base64Image = base64Encode(bytes);
  //
  //       // Set OpenAI configuration
  //       _apiService.setBaseUrl(_apiService.openAiUrl);
  //       _apiService.setOpenAiToken();
  //
  //       const prompt =
  //           """You are a lead AI for a team of specialized virtual nutritionists. Your task is to analyze the food in the image and provide a comprehensive product review focusing on harmful additives and health risks.
  //
  // IMPORTANT: When analyzing the product, specifically look for and identify these harmful ingredients:
  //
  // FOOD ADDITIVES TO AVOID:
  // - Sodium nitrate/nitrite (processed meats) - cancer risk
  // - Sulfites (preservatives) - breathing difficulties
  // - Azodicarbonamide (bread improver) - asthma
  // - Potassium bromate (bread) - cancer risk
  // - Propyl gallate (fat preservative) - cancer risk
  // - BHA/BHT (preservatives) - tumor growth
  // - Propylene glycol (thickener) - antifreeze component
  // - Butane (chicken nuggets) - carcinogen
  // - MSG, Disodium inosinate/guanylate - nerve damage, headaches
  // - Enriched flour - toxic refined starch
  // - rBGH (dairy) - cancer-causing growth hormone
  // - Trans fats/PHO - heart disease, diabetes
  // - Sodium benzoate - DNA damage, cancer
  // - Brominated vegetable oil - organ damage
  // - Olestra - digestive problems
  // - Carrageenan - ulcers, cancer
  // - Polysorbate 60/80 - cancer, gut inflammation
  // - Aluminum, Titanium dioxide - DNA damage
  // - Chlorine dioxide - tumors, hyperactivity
  //
  // ARTIFICIAL SWEETENERS TO AVOID:
  // - Saccharin - bladder cancer
  // - Aspartame - carcinogen, neurological issues
  // - High fructose corn syrup - obesity, diabetes
  // - Acesulfame potassium - lung/breast tumors
  // - Sucralose - liver/kidney damage
  //
  // ARTIFICIAL COLORS TO AVOID:
  // - Red #40, #2, #3 - cancer, hyperactivity
  // - Blue #1, #2 - chromosome damage, brain tumors
  // - Yellow #5, #6 - kidney tumors
  // - Green #3 - bladder tumors
  // - Caramel coloring (with ammonia) - cancer
  //
  // Your analysis must contain:
  // 1. A clear product title
  // 2. A detailed description identifying specific harmful ingredients found (if any) and their health risks
  // 3. A risk status based on detected harmful ingredients:
  //    - 'Good to Eat' - No harmful additives detected, natural/organic ingredients
  //    - 'Low Risk' - 1-2 mild additives, minimal processing
  //    - 'Moderate Risk' - 3-5 additives or some concerning preservatives
  //    - 'High Risk' - Multiple harmful additives, artificial colors, preservatives, or known carcinogens
  // 4. Expert reviews from TWO nutritionists with invented names and qualifications
  //
  // Focus your analysis on:
  // - Ingredient safety and toxicity
  // - Processing level assessment
  // - Additive identification and health impact
  // - Overall nutritional value vs. health risks
  //
  // Respond ONLY with a valid JSON object. The JSON structure MUST be:
  //
  // {
  //   "product": {
  //     "title": "string",
  //     "description": "string (include specific harmful ingredients found and their health risks)",
  //     "status": "string (Good to Eat/Low Risk/Moderate Risk/High Risk)",
  //     "nutritionists": [
  //       {
  //         "name": "string",
  //         "qualification": "string"
  //       },
  //       {
  //         "name": "string",
  //         "qualification": "string"
  //       }
  //     ]
  //   }
  // }""";
  //
  //       final requestData = {
  //         "model": "gpt-4o-mini",
  //         "messages": [
  //           {
  //             "role": "user",
  //             "content": [
  //               {"type": "text", "text": prompt},
  //               {
  //                 "type": "image_url",
  //                 "image_url": {"url": "data:image/jpeg;base64,$base64Image"},
  //               },
  //             ],
  //           },
  //         ],
  //         "max_tokens": 1000,
  //       };
  //
  //       final response = await _apiService.post(
  //         '/chat/completions',
  //         data: requestData,
  //       );
  //
  //       // Reset base URL after OpenAI call
  //       _apiService.setBaseUrl(_apiService.baseUrl);
  //
  //       if (response.statusCode == 200) {
  //         final responseData = response.data;
  //         final content = responseData['choices'][0]['message']['content'];
  //
  //         // Parse the JSON response from OpenAI
  //         final analysisResult = jsonDecode(content);
  //         final productData = analysisResult['product'];
  //
  //         // Add image path to the product data
  //         productData['image'] = imageFile.path;
  //
  //         final product = Product.fromJson(productData);
  //         return ApiResponse.success(product);
  //       } else {
  //         return ApiResponse.error(
  //           'Failed to analyze product image',
  //           statusCode: response.statusCode,
  //         );
  //       }
  //     } catch (e) {
  //       // Reset base URL in case of error
  //       _apiService.setBaseUrl(_apiService.baseUrl);
  //       return ApiResponse.error('Network error: ${e.toString()}');
  //     }
  //   }

  Future<ApiResponse<Product>> scanProductGemini(File imageFile) async {
    await initializeKnowledgeBase();
    try {
      // 1. Read image file as bytes. Base64 is not needed for the Gemini SDK.
      final Uint8List bytes = await imageFile.readAsBytes();

      // 🔒 IMPORTANT: Never hardcode API keys in a production app.
      // This is for demonstration purposes only. For a real app, use a secure
      // backend proxy or retrieve the key from encrypted storage or environment variables.
      final encodedApiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

      if (encodedApiKey.isEmpty) {
        return ApiResponse.error(
          'API key not found. Please check your .env file.',
        );
      }

      // Decode the base64 encoded API key
      final apiKey = EncodingUtils.decodeFromBase64(encodedApiKey);

      // 2. Initialize the Gemini Model
      final model = GenerativeModel(
        // 'gemini-1.5-flash-latest' is a fast and capable multimodal model
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );

      // 3. Define the full prompt with the knowledge base embedded.
      const prompt = r'''
You are a highly specialized AI assistant with expertise in food science and safety. Your sole function is to analyze the food item(s) in a provided image, identify any potentially harmful substances based on the KNOWLEDGE BASE, and assign both an individual and an overall risk level. You must be precise and adhere strictly to the output format.

---

### 🔒 Critical Mandate: Adhere to the Task
Your sole and exclusive function is to act as a food analyzer. You must not deviate from this task. Do not engage in conversation, offer opinions, or provide additional health advice not present in the knowledge base. Your only output must be the specified JSON object.

---

### Step-by-Step Instructions

1.  **Initial Image Identification:** First, identify the primary subject of the image. Determine if it is **(A) a packaged product with a visible ingredient list**, or **(B) a general food item** like a pizza, burger, or drink.

2.  **Analysis and Compilation:**
    * Based on the identification in Step 1, find all applicable ingredients (either from OCR of a label or by inferring the common ingredients of a general food item).
    * Cross-reference these ingredients against the KNOWLEDGE BASE.
    * For **each** harmful ingredient you identify, you must:
        * **a) Determine its individual `risk_level`** by applying the Risk Hierarchy defined in Step 4.
        * **b) Create a JSON object** for it containing its `ingredientName`, its full `risk` description, and its determined individual `risk_level`.
    * Populate the `ingredientsList` array with these objects. If no harmful ingredients are found, this array must be empty.

3.  **Determine the Overall Risk Level:**
    * Look at all the individual `risk_level`s you assigned in the `ingredientsList`.
    * The overall `risk_level` for the product is the **most severe** level found among its ingredients (e.g., if there is at least one 'High_risk' ingredient, the overall level is 'High_risk').
    * If the `ingredientsList` is empty, the overall `risk_level` is 'Safe'.

4.  **Define the Risk Hierarchy:** Use these rules to assign a `risk_level` to each individual ingredient.
    * **'High_risk':** Assign this if an ingredient is a known **carcinogen**, is explicitly linked to **cancer**, or is associated with **organ, DNA, nerve, or chromosome damage**.
    * **'Moderate_risk':** If not high-risk, assign this if an ingredient is linked to **tumor growth, heart problems, diabetes, endocrine disruption, or autoimmune diseases**.
    * **'Low_risk':** If not high or moderate-risk, assign this if an ingredient is linked to less severe issues like **asthma, hyperactivity, headaches, digestive problems, or breathing difficulties**.

5.  **JSON Output Generation:** Construct the final JSON object according to the mandatory format, including the overall `risk_level`, a brief `description`, and the populated `ingredientsList`.

---

### KNOWLEDGE BASE (JSON)
[
  {
    "id": 1,
    "name": ["Sodium nitrate"],
    "category": "Food Additive",
    "risk": "Added to processed meats to stop bacterial growth. Linked to cancer in humans."
  },
  {
    "id": 2,
    "name": ["Sulfites"],
    "category": "Food Additive",
    "risk": "Used to keep prepared foods fresh. It can cause breathing difficulties in those sensitive to the ingredient."
  },
  {
    "id": 3,
    "name": ["Azodicarbonamide"],
    "category": "Food Additive",
    "risk": "Used in bagels and buns. It can cause asthma."
  },
  {
    "id": 4,
    "name": ["Potassium bromate"],
    "category": "Food Additive",
    "risk": "Added to breads to increase volume. Linked to cancer in humans."
  },
  {
    "id": 5,
    "name": ["Propyl gallate"],
    "category": "Food Additive",
    "risk": "Added to fat-containing products. Linked to cancer in humans."
  },
  {
    "id": 6,
    "name": ["BHA", "BHT"],
    "category": "Food Additive",
    "risk": "A fat preservative, used in foods to extend shelf life. Linked to cancerous tumor growth."
  },
  {
    "id": 7,
    "name": ["Propylene glycol"],
    "category": "Food Additive",
    "risk": "Better known as antifreeze. It thickens dairy products and salad dressing. Deemed 'generally' safe by FDA."
  },
  {
    "id": 8,
    "name": ["Butane"],
    "category": "Food Additive",
    "risk": "Added to chicken nuggets to keep them tasting fresh. A known carcinogen."
  },
  {
    "id": 9,
    "name": ["Monosodium glutamate", "MSG"],
    "category": "Food Additive",
    "risk": "Flavor enhancer that can cause headaches. Linked in animal studies to nerve damage, heart problems and seizures."
  },
  {
    "id": 10,
    "name": ["Disodium inosinate"],
    "category": "Food Additive",
    "risk": "In snack foods. Contains MSG."
  },
  {
    "id": 11,
    "name": ["Disodium guanylate"],
    "category": "Food Additive",
    "risk": "Also used in snack foods, and contains MSG."
  },
  {
    "id": 12,
    "name": ["Enriched flour"],
    "category": "Food Additive",
    "risk": "Used in many snack foods. A refined starch that is made from toxic ingredients."
  },
  {
    "id": 13,
    "name": ["Recombinant Bovine Growth Hormone", "rBGH"],
    "category": "Food Additive",
    "risk": "Geneticially-engineered growth hormone given to cows to boost milk production. It contains high levels of IGF-1, which can cause various types of cancer."
  },
  {
    "id": 14,
    "name": ["Refined vegetable oil", "Soybean oil", "Corn oil", "Safflower oil", "Canola oil", "Peanut oil"],
    "category": "Food Additive",
    "risk": "Used in many packaged foods and snacks. High in omega-6 fats, which are thought to cause heart disease and cancer."
  },
  {
    "id": 15,
    "name": ["Trans fats from Partially Hydrogenated Oils", "PHO"],
    "category": "Food Additive",
    "risk": "Added to enhance flavor, texture and shelf-life food. It can increase bad cholesterol and diabetes."
  },
  {
    "id": 16,
    "name": ["Sodium benzoate"],
    "category": "Food Additive",
    "risk": "Used as a preservative in salad dressing and carbonated beverages. A known carcinogen that can cause cancer and damage human DNA."
  },
  {
    "id": 17,
    "name": ["Brominated vegetable oil"],
    "category": "Food Additive",
    "risk": "Keeps flavor oils in soft drinks suspended. Bromate is a poison and can cause organ damage and birth defects. Not required to be listed on food labels."
  },
  {
    "id": 18,
    "name": ["Propyl gallate"],
    "category": "Food Additive",
    "risk": "Found in meats, popcorn, soup mixes and frozen dinners. Shown to cause cancer in rats. Banned in some countries. Deemed safe by FDA."
  },
  {
    "id": 19,
    "name": ["Olestra"],
    "category": "Food Additive",
    "risk": "Fat-like substance that is unabsorbed by the body. Used in place of natural fats in some snack foods. It can cause digestive problems, and heart problems."
  },
  {
    "id": 20,
    "name": ["Carrageenan"],
    "category": "Food Additive",
    "risk": "Stabilizer and thickening agent used in many packaged foods. It can cause ulcers and cancer."
  },
  {
    "id": 21,
    "name": ["Polysorbate 60"],
    "category": "Food Additive",
    "risk": "A thickener that is used in baked goods. It can cause cancer in laboratory animals."
  },
  {
    "id": 22,
    "name": ["Polysorbate 80", "PS80"],
    "category": "Food Additive",
    "risk": "A synthetic emulsifier in desserts, salad dressing and sauces. It is linked to gut inflammation and increased risk of autoimmune diseases."
  },
  {
    "id": 23,
    "name": ["Camauba wax"],
    "category": "Food Additive",
    "risk": "Used in chewing gums and to glaze certain foods. It can cause cancer and tumors."
  },
  {
    "id": 24,
    "name": ["Magnesium sulphate"],
    "category": "Food Additive",
    "risk": "Added to tofu and other foods and can cause cancer in laboratory animals."
  },
  {
    "id": 25,
    "name": ["Chlorine dioxide"],
    "category": "Food Additive",
    "risk": "Used in bleaching flour. It can cause tumors and hyperactivity in children."
  },
  {
    "id": 26,
    "name": ["Paraben"],
    "category": "Food Additive",
    "risk": "Used to stop mold and yeast forming in foods. It can disrupt hormones in the body and is linked to breast cancer."
  },
  {
    "id": 27,
    "name": ["Sodium carboxymethyl cellulose"],
    "category": "Food Additive",
    "risk": "Used as a thickener in salad dressings. It can cause cancer when consumed in high quantities."
  },
  {
    "id": 28,
    "name": ["Aluminum"],
    "category": "Food Additive",
    "risk": "A preservative in some packaged foods that can cause cancer."
  },
  {
    "id": 29,
    "name": ["Titanium dioxide"],
    "category": "Food Additive",
    "risk": "A chemical element used to smoothen texture and brighten colors in foods and drinks. It can cause potential damages to DNA in humans."
  },
  {
    "id": 30,
    "name": ["Saccharin"],
    "category": "Artificial Sweetener",
    "risk": "Carcinogen found to cause bladder cancer in rats."
  },
  {
    "id": 31,
    "name": ["Aspartame"],
    "category": "Artificial Sweetener",
    "risk": "An excitotoxin that is understood to be a carcinogen. It can cause dizziness, headaches, blurred vision and stomach problems."
  },
  {
    "id": 32,
    "name": ["High fructose corn syrup", "HFCS"],
    "category": "Artificial Sweetener",
    "risk": "Sweetener made into a corn starch from genetically modified corn. It causes obesity, diabetes, heart problems, arthritis and insulin resistance."
  },
  {
    "id": 33,
    "name": ["Xylitol"],
    "category": "Artificial Sweetener",
    "risk": "Added to food as a sugar alcohol. It can cause digestive discomfort like bloating, gas, etc., and increase the risk of cardiovascular health problems."
  },
  {
    "id": 34,
    "name": ["Acesulfame potassium"],
    "category": "Artificial Sweetener",
    "risk": "Used with other artificial sweeteners in diet sodas and ice cream. It is linked to lung and breast tumors in rats."
  },
  {
    "id": 35,
    "name": ["Sucralose"],
    "category": "Artificial Sweetener",
    "risk": "It is artificial sweetener in Splenda. It can cause swelling of liver and kidneys and a shrinkage of the thymus gland."
  },
  {
    "id": 36,
    "name": ["Agave nectar"],
    "category": "Artificial Sweetener",
    "risk": "Sweetener derived from a cactus. It contains high levels of fructose, which causes insulin resistance, liver disease and inflammation of body tissues."
  },
  {
    "id": 37,
    "name": ["Bleached starch"],
    "category": "Artificial Sweetener",
    "risk": "Added to many dairy products. It can cause asthma and skin irritations."
  },
  {
    "id": 38,
    "name": ["Tert butylhydroquinone"],
    "category": "Artificial Sweetener",
    "risk": "Used to preserve fish products. It can cause stomach tumors."
  },
  {
    "id": 39,
    "name": ["Red #40"],
    "category": "Artificial Food Color",
    "risk": "Found in many foods to alter color. A carcinogen that is linked to cancer in some studies. Also, it can cause hyperactivity in children. Banned in some European countries."
  },
  {
    "id": 40,
    "name": ["Blue #1"],
    "category": "Artificial Food Color",
    "risk": "Used in bakery products, candy and soft drinks. It can damage chromosomes and lead to cancer."
  },
  {
    "id": 41,
    "name": ["Blue #2"],
    "category": "Artificial Food Color",
    "risk": "Used in candy and pet food beverages. It can cause brain tumors."
  },
  {
    "id": 42,
    "name": ["Citrus red #1"],
    "category": "Artificial Food Color",
    "risk": "Sprayed on oranges to make them look ripe. It can damage chromosomes and lead to cancer."
  },
  {
    "id": 43,
    "name": ["Citrus red #2"],
    "category": "Artificial Food Color",
    "risk": "Used to color oranges. It can cause cancer if you eat the peel."
  },
  {
    "id": 44,
    "name": ["Green #3"],
    "category": "Artificial Food Color",
    "risk": "Used in candy and beverages. It can cause bladder tumors."
  },
  {
    "id": 45,
    "name": ["Yellow #5", "Yellow Tartrazine", "E102"],
    "category": "Artificial Food Color",
    "risk": "Used in desserts, candy and baked goods. It can cause kidney tumors, according to some studies."
  },
  {
    "id": 46,
    "name": ["Yellow #6", "E110"],
    "category": "Artificial Food Color",
    "risk": "A carcinogen used in sausage, beverages and baked goods. It can cause kidney tumors, according to some studies."
  },
  {
    "id": 47,
    "name": ["Red #2"],
    "category": "Artificial Food Color",
    "risk": "A food coloring that can cause both asthma and cancer."
  },
  {
    "id": 48,
    "name": ["Red #3"],
    "category": "Artificial Food Color",
    "risk": "A carcinogen. that is added to cherry pie filling, ice cream and baked goods. It can cause nerve damage and thyroid cancer."
  },
  {
    "id": 49,
    "name": ["Caramel coloring"],
    "category": "Artificial Food Color",
    "risk": "In soft drinks, sauces, pastries and breads. When made with ammonia, it can cause cancer in mice. Yet, food companies are not required to disclose if this ingredient is made with ammonia."
  },
  {
    "id": 50,
    "name": ["Brown HT"],
    "category": "Artificial Food Color",
    "risk": "Used in many packaged foods. It can cause hyperactivity in children, asthma and cancer."
  },
  {
    "id": 51,
    "name": ["Orange B"],
    "category": "Artificial Food Color",
    "risk": "A food dye that is used in hot dog and sausage casings. It can cause liver problems and challenges for the bile duct."
  },
  {
    "id": 52,
    "name": ["Bixin"],
    "category": "Artificial Food Color",
    "risk": "Food coloring that can cause hyperactivity and asthma in children."
  },
  {
    "id": 53,
    "name": ["Norbixin"],
    "category": "Artificial Food Color",
    "risk": "Food coloring that can cause hyperactivity and asthma in children."
  },
  {
    "id": 54,
    "name": ["Annatto"],
    "category": "Artificial Food Color",
    "risk": "Food coloring that can cause hyperactivity and asthma in children."
  },
  {
    "id": 55,
    "name": ["Caramelized sugar syrup"],
    "category": "Artificial Food Color",
    "risk": "It can contribute to obesity, type 2 diabetes and heart disease. Linked to a potential carcinogen, 4-MEI, and cancer in animal studies."
  },
  {
    "id": 56,
    "name": ["Sodium Benzoate"],
    "category": "Preservative",
    "risk": "A salt of benzoic acid added to extend shelf life of food and drinks products. It can cause hyperactivity in some children."
  },
  {
    "id": 57,
    "name": ["Sodium Nitrate", "Sodium Nitrite"],
    "category": "Preservative",
    "risk": "Added to preserve meat products. Consumption of high quantity can lead to possible heart palpitations, dyspnea and pancreatic cancer."
  },
  {
    "id": 58,
    "name": ["Sodium Sulfite", "E221"],
    "category": "Preservative",
    "risk": "Added to preserve some wine and some dried fruits. Sulfite is linked to asthma, headaches, breathing problems, rashes and cardiac arrest."
  },
  {
    "id": 59,
    "name": ["Sulfur Dioxide", "E220"],
    "category": "Preservative",
    "risk": "Added to food and drinks and labeled as toxic. It can cause bronchial problems, flushing, tingling sensations or anaphylactic shock."
  },
  {
    "id": 60,
    "name": ["Potassium Bisulfite", "KHSO3"],
    "category": "Preservative",
    "risk": "It is a sulfurous acid used to preserve wine, beers, fruits and dehydrated vegetables. It can cause asthma symptoms, weakness, etc."
  },
  {
    "id": 61,
    "name": ["Propyl Paraben"],
    "category": "Preservative",
    "risk": "It is used in many food products and cosmetics. It is reported as an endocrine-disrupting chemical that can decrease sperm counts and testosterone levels, impair fertility in women and breast growth, and can cause cancer."
  },
  {
    "id": 62,
    "name": ["Butylated Hydroxyanisole", "BHA", "Butylated Hydroxytoluene", "BHT", "E320"],
    "category": "Preservative",
    "risk": "Added to maintain flavor and color of foods. It can cause neurological problems, and as oxidants, have the potential to cause cancer."
  },
  {
    "id": 63,
    "name": ["Tertiary butylhydroquinone", "TBHQ"],
    "category": "Preservative",
    "risk": "This synthetic antioxidant is used to preserve shelf life and prevent rancidity in foods. It can cause cellular damage and cancer."
  }
]

---

### Mandatory Output Format
Respond ONLY with a valid JSON object. The JSON structure MUST be:
{
  "title": "string (The name of the product)",
  "description": "string (A one-sentence summary of the findings)",
  "risk_level": "string ('Safe', 'Low_risk', 'Moderate_risk', or 'High_risk')",
  "status: : "string (Safe, Avoid, Caution)",
  "ingredientsList": [
    {
      "ingredientName": "string (Name of the found ingredient)",
      "risk": "string (The corresponding risk from the knowledge base)",
      "risk_level": "string ('High_risk', 'Moderate_risk', or 'Low_risk')"
    }
  ]
}
''';

      // 4. Create the content parts for the API request
      final promptPart = TextPart(prompt);
      final imagePart = DataPart('image/jpeg', bytes);

      // 5. Send the request to Gemini
      final response = await model.generateContent([
        Content.multi([promptPart, imagePart]),
      ]);

      // 6. Process the response
      if (response.text != null) {
        // Clean the response in case the model wraps it in markdown
        final cleanedJson =
            response.text!
                .replaceAll('```json', '')
                .replaceAll('```', '')
                .trim();

        // Decode the JSON string into a Dart Map
        final analysisResult = jsonDecode(cleanedJson);

        // Create a new map with the API response and add the image path
        final Map<String, dynamic> productData = {
          ...analysisResult, // spread the original response
          'image': imageFile.path, // add the image path
        };

        // Convert the Map into your type-safe FoodProductAnalysis object
        final product = Product.fromJson(productData);

        // Enrich ingredients with risk information
        if (analysisResult['ingredientsList'] != null) {
          final List<String> ingredientNames = List<String>.from(
            analysisResult['ingredientsList'].map(
              (ingredient) => ingredient['ingredientName'],
            ),
          );
          final enrichedIngredients = await enrichIngredientsWithRisk(
            ingredientNames,
          );

          // Update the product data with enriched ingredients
          productData['ingredientsList'] = enrichedIngredients;
        }

        return ApiResponse.success(product);
      } else {
        // Handle cases where the API returns no text content
        return ApiResponse.error(
          'Failed to analyze product: No content in response',
        );
      }
    } catch (e) {
      // Handle potential errors from the API, network, or JSON parsing
      return ApiResponse.error('An error occurred: ${e.toString()}');
    }
  }

  // New helper: load bytes from either a URL or a local file path.
  Future<Uint8List> _loadImageBytesFromPath(String pathOrUrl) async {
    // Support file:// prefix
    if (pathOrUrl.startsWith('file://')) {
      pathOrUrl = pathOrUrl.replaceFirst('file://', '');
    }

    // Detect HTTP/HTTPS URLs
    if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://')) {
      final uri = Uri.parse(pathOrUrl);
      final client = HttpClient();
      try {
        final request = await client.getUrl(uri);
        final response = await request.close();
        if (response.statusCode != HttpStatus.ok) {
          throw Exception('Failed to download image: ${response.statusCode}');
        }

        final builder = BytesBuilder();
        await for (final chunk in response) {
          builder.add(chunk);
        }
        return builder.takeBytes();
      } finally {
        client.close(force: true);
      }
    }

    // Treat as a local file path
    final file = File(pathOrUrl);
    if (!await file.exists()) {
      throw Exception('Local image not found at path: $pathOrUrl');
    }
    return await file.readAsBytes();
  }

  // New convenience method: accept a String that may be a URL or a local path
  Future<ApiResponse<FoodProductAnalysis>> scanProductGeminiFromPath(
    String pathOrUrl,
  ) async {
    try {
      final bytes = await _loadImageBytesFromPath(pathOrUrl);

      // Reuse existing logic by creating DataPart and sending to Gemini
      // 🔒 IMPORTANT: Never hardcode API keys in a production app.
      const apiKey = 'AIzaSyBWo3Icp5qEjEOWDhYfqVwSGJtvUM2ytio';

      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);

      const prompt = r'''
+You are a highly specialized AI assistant with expertise in food science and safety. Your sole function is to analyze the food item(s) in a provided image, identify any potentially harmful substances based on the KNOWLEDGE BASE, and assign both an individual and an overall risk level. You must be precise and adhere strictly to the output format.
+
+---
+
+### 🔒 Critical Mandate: Adhere to the Task
+Your sole and exclusive function is to act as a food analyzer. You must not deviate from this task. Do not engage in conversation, offer opinions, or provide additional health advice not present in the knowledge base. Your only output must be the specified JSON object.
+
+---
+
+### Step-by-Step Instructions
+
+1.  **Initial Image Identification:** First, identify the primary subject of the image. Determine if it is **(A) a packaged product with a visible ingredient list**, or **(B) a general food item** like a pizza, burger, or drink.
+
+2.  **Analysis and Compilation:**
+    * Based on the identification in Step 1, find all applicable ingredients (either from OCR of a label or by inferring the common ingredients of a general food item).
+    * Cross-reference these ingredients against the KNOWLEDGE BASE.
+    * For **each** harmful ingredient you identify, you must:
+        * **a) Determine its individual `risk_level`** by applying the Risk Hierarchy defined in Step 4.
+        * **b) Create a JSON object** for it containing its `ingredientName`, its full `risk` description, and its determined individual `risk_level`.
+    * Populate the `ingredientsList` array with these objects. If no harmful ingredients are found, this array must be empty.
+
+3.  **Determine the Overall Risk Level:**
+    * Look at all the individual `risk_level`s you assigned in the `ingredientsList`.
+    * The overall `risk_level` for the product is the **most severe** level found among its ingredients (e.g., if there is at least one 'High_risk' ingredient, the overall level is 'High_risk').
+    * If the `ingredientsList` is empty, the overall `risk_level` is 'Safe'.
+
+4.  **Define the Risk Hierarchy:** Use these rules to assign a `risk_level` to each individual ingredient.
+    * **'High_risk':** Assign this if an ingredient is a known **carcinogen**, is explicitly linked to **cancer**, or is associated with **organ, DNA, nerve, or chromosome damage**.
+    * **'Moderate_risk':** If not high-risk, assign this if an ingredient is linked to **tumor growth, heart problems, diabetes, endocrine disruption, or autoimmune diseases**.
+    * **'Low_risk':** If not high or moderate-risk, assign this if an ingredient is linked to less severe issues like **asthma, hyperactivity, headaches, digestive problems, or breathing difficulties**.
+
+5.  **JSON Output Generation:** Construct the final JSON object according to the mandatory format, including the overall `risk_level`, a brief `description`, and the populated `ingredientsList`.
+
+---
+
+### KNOWLEDGE BASE (JSON)
+[ ... ]
+
+---
+
+### Mandatory Output Format
+Respond ONLY with a valid JSON object. The JSON structure MUST be:
+{
+  "title": "string (The name of the product)",
+  "description": "string (A one-sentence summary of the findings)",
+  "risk_level": "string ('Safe', 'Low_risk', 'Moderate_risk', or 'High_risk')",
+  "ingredientsList": [
+    {
+      "ingredientName": "string (Name of the found ingredient)",
+      "risk": "string (The corresponding risk from the knowledge base)",
+      "risk_level": "string ('High_risk', 'Moderate_risk', or 'Low_risk')"
+    }
+  ]
+}
+''';

      final promptPart = TextPart(prompt);
      final imagePart = DataPart('image/jpeg', bytes);

      final response = await model.generateContent([
        Content.multi([promptPart, imagePart]),
      ]);

      if (response.text != null) {
        final cleanedJson =
            response.text!
                .replaceAll('```json', '')
                .replaceAll('```', '')
                .trim();
        final analysisResult = jsonDecode(cleanedJson);

        final Map<String, dynamic> productData = {
          ...analysisResult,
          'image': pathOrUrl,
        };

        final product = FoodProductAnalysis.fromJson(productData);

        // Enrich ingredients with risk information
        if (analysisResult['ingredientsList'] != null) {
          final List<String> ingredientNames = List<String>.from(
            analysisResult['ingredientsList'].map(
              (ingredient) => ingredient['ingredientName'],
            ),
          );
          final enrichedIngredients = await enrichIngredientsWithRisk(
            ingredientNames,
          );

          // Update the product data with enriched ingredients
          productData['ingredientsList'] = enrichedIngredients;
        }

        return ApiResponse.success(product);
      } else {
        return ApiResponse.error(
          'Failed to analyze product: No content in response',
        );
      }
    } catch (e) {
      return ApiResponse.error('An error occurred: ${e.toString()}');
    }
  }

  // Supabase: get all products for a given user email
  Future<ApiResponse<List<Product>>> getAllProducts(String email) async {
    try {
      if (email.isEmpty) {
        return ApiResponse.error('Email is required');
      }

      // Get the current authenticated user's ID
      final userId = SupabaseConfig.client.auth.currentUser?.id;

      if (userId == null) {
        return ApiResponse.error('User not authenticated');
      }

      // Get all products for this user
      final productsResponse = await SupabaseConfig.client
          .from('products')
          .select()
          .eq('owner', userId)
          .order('created_at', ascending: false);

      final products =
          (productsResponse as List)
              .map<Product>(
                (p) => Product.fromJson(Map<String, dynamic>.from(p)),
              )
              .toList();

      return ApiResponse.success(products);
    } catch (e) {
      return ApiResponse.error('Failed to fetch products: $e');
    }
  }

  // Upload image to Supabase Storage and return public URL
  Future<String?> uploadImageToStorage(File imageFile, String userId) async {
    try {
      // Generate a unique filename using timestamp and user ID
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileExtension = imageFile.path.split('.').last;
      final fileName = '$userId/$timestamp.$fileExtension';

      // Upload the file to Supabase Storage bucket 'productimages'
      final bytes = await imageFile.readAsBytes();
      await SupabaseConfig.client.storage
          .from('productimages')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(
              contentType: 'image/$fileExtension',
              upsert: false,
            ),
          );

      // Get the public URL of the uploaded image
      final publicUrl = SupabaseConfig.client.storage
          .from('productimages')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
  }

  // Delete image from Supabase Storage
  Future<bool> deleteImageFromStorage(String imageUrl) async {
    try {
      // Extract the file path from the public URL
      // URL format: https://.../storage/v1/object/public/productimages/userId/timestamp.ext
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      // Find 'productimages' in the path and get everything after it
      final bucketIndex = pathSegments.indexOf('productimages');
      if (bucketIndex == -1 || bucketIndex == pathSegments.length - 1) {
        return false;
      }

      final filePath = pathSegments.sublist(bucketIndex + 1).join('/');

      // Delete the file from storage
      await SupabaseConfig.client.storage.from('productimages').remove([
        filePath,
      ]);

      return true;
    } catch (e) {
      print('Failed to delete image: $e');
      return false;
    }
  }

  // Supabase: add a product for a user
  Future<ApiResponse<Product>> setProduct(String email, Product product) async {
    try {
      if (email.isEmpty) return ApiResponse.error('Email is required');

      // Get the current authenticated user's ID
      final userId = SupabaseConfig.client.auth.currentUser?.id;

      if (userId == null) {
        return ApiResponse.error('User not authenticated');
      }

      // Upload image to Supabase Storage if image is a local file path
      String? imageUrl = product.image;
      if (product.image != null &&
          !product.image!.startsWith('http://') &&
          !product.image!.startsWith('https://')) {
        // It's a local file path, upload it
        final imageFile = File(product.image!);
        if (await imageFile.exists()) {
          imageUrl = await uploadImageToStorage(imageFile, userId);
          if (imageUrl == null) {
            return ApiResponse.error('Failed to upload image');
          }
        }
      }

      // Insert the product
      final productData = product.toJson();
      // Map the Product model fields to the Supabase table columns
      final insertData = {
        'owner': userId,
        'title': productData['title'],
        'description': productData['description'],
        'image': imageUrl, // Store the Supabase Storage URL
        'status': productData['status'],
        'risk_level': productData['risk_level'],
        'is_favorite': productData['is_favorite'] ?? false,
        'ingredients_list': productData['ingredientsList'], // JSONB field
      };

      final response =
          await SupabaseConfig.client
              .from('products')
              .insert(insertData)
              .select();

      if (response.isNotEmpty) {
        final createdProduct = Product.fromJson(response[0]);
        return ApiResponse.success(createdProduct);
      }

      return ApiResponse.error('Failed to create product');
    } catch (e) {
      return ApiResponse.error('Failed to save product: $e');
    }
  }

  // Supabase: delete a product and its image
  Future<ApiResponse<void>> deleteProduct(
    String productId,
    String? imageUrl,
  ) async {
    try {
      // Delete the product from database
      await SupabaseConfig.client.from('products').delete().eq('id', productId);

      // Delete the image from storage if it exists and is a Supabase URL
      if (imageUrl != null && imageUrl.contains('productimages')) {
        await deleteImageFromStorage(imageUrl);
      }

      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error('Failed to delete product: $e');
    }
  }

  // Supabase: update product favorite status
  Future<ApiResponse<void>> updateProductFavorite(
    String productId,
    bool isFavorite,
  ) async {
    try {
      print(
        '🔄 Updating favorite status for product $productId to $isFavorite',
      );

      final response =
          await SupabaseConfig.client
              .from('products')
              .update({'is_favorite': isFavorite})
              .eq('id', productId)
              .select();

      print('✅ Favorite update successful: $response');
      return ApiResponse.success(null);
    } catch (e) {
      print('❌ Failed to update favorite: $e');
      return ApiResponse.error('Failed to update favorite: $e');
    }
  }
}
