import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marcos_malaga_app/features/cart/data/datasources/local_cart_datasource.dart';
import 'package:marcos_malaga_app/features/cart/data/models/cart_model.dart';
import 'package:marcos_malaga_app/features/cart/data/models/cart_item_model.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_model.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_design_model.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_size_model.dart';

void main() {
  late SharedPreferences prefs;
  late LocalCartDatasource datasource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    datasource = LocalCartDatasource(prefs: prefs);
  });

  group('LocalCartDatasource', () {
    final tProduct = ProductModel(
      id: 'prod1',
      name: 'Dress',
      basePrice: 50.0,
      description: 'Nice dress',
      designs: [],
      categoryIds: [],
      isVisible: true,
      createdAt: DateTime.now(),
    );
    
    final tDesign = ProductDesignModel(
      id: 'des1',
      name: 'Red',
      imageUrls: [],
      sizes: [],
    );
    
    final tSize = ProductSizeModel(
      size: 'M',
      stock: 10,
    );

    final tCartItem = CartItemModel(
      id: 'item1',
      product: tProduct.toEntity(),
      selectedDesign: tDesign.toEntity(),
      selectedSize: tSize.toEntity(),
      quantity: 2,
    );
    
    final tCart = CartModel(items: [tCartItem]);

    test('getCart should return empty CartModel when no data exists', () async {
      final result = await datasource.getCart();
      expect(result.items, isEmpty);
    });

    test('saveCart should write data to SharedPreferences', () async {
      await datasource.saveCart(tCart);
      
      final storedString = prefs.getString('CART_DATA');
      expect(storedString, isNotNull);
      
      final jsonMap = jsonDecode(storedString!);
      final cartFromJson = CartModel.fromJson(jsonMap);
      
      expect(cartFromJson.items.length, 1);
      expect(cartFromJson.items.first.id, 'item1');
    });

    test('getCart should return populated CartModel when data exists', () async {
      final jsonString = jsonEncode(tCart.toJson());
      prefs.setString('CART_DATA', jsonString);
      
      final result = await datasource.getCart();
      expect(result.items.length, 1);
      expect(result.items.first.id, 'item1');
    });
  });
}
