import 'package:faap/Model/analysis_model.dart';
import 'package:faap/Model/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('HarmfulIngredient toJson/fromJson round trip', () {
    final ingredient = HarmfulIngredient(
      ingredientName: 'Sodium Chloride',
      risk: 'Generally safe',
      risk_level: 'safe',
    );

    final json = ingredient.toJson();
    final restored = HarmfulIngredient.fromJson(json);

    expect(restored.ingredientName, equals(ingredient.ingredientName));
    expect(restored.risk, equals(ingredient.risk));
    expect(restored.risk_level, equals(ingredient.risk_level));
  });

  test('Product toJson/fromJson round trip', () {
    final ingredient = HarmfulIngredient(
      ingredientName: 'Sodium Benzoate',
      risk: 'May form benzene in presence of vitamin C',
      risk_level: 'moderate',
    );

    final product = Product(
      riskLevel: 'moderate',
      isFavorite: true,
      title: 'Test Product',
      description: 'A sample product for testing',
      image: null,
      status: 'available',
      harmfulIngredients: [ingredient],
    );

    final json = product.toJson();

    final restored = Product.fromJson(json);

    expect(restored.title, equals(product.title));
    expect(restored.description, equals(product.description));
    expect(restored.riskLevel, equals(product.riskLevel));
    expect(restored.isFavorite, equals(product.isFavorite));
    expect(restored.harmfulIngredients!.length, equals(1));
    expect(
      restored.harmfulIngredients!.first.ingredientName,
      equals(ingredient.ingredientName),
    );
  });
}
