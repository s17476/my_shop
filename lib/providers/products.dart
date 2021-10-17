import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/models/http_exception.dart';
import 'dart:convert';
import 'package:my_shop/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final _productsUrl = Uri.parse(
      'https://flutter-myshop-49e90-default-rtdb.europe-west1.firebasedatabase.app/products.json');

  List<Product> _items = [];

  // var showFavoritesOnly = false;

  List<Product> get items {
    // if (showFavoritesOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    try {
      List<Product> tmpList = [];
      final response = await http.get(_productsUrl);
      if (response.body == 'null') {
        return;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((key, value) {
        tmpList.add(
          Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: value['isFavorite'],
          ),
        );
      });
      _items = tmpList;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

//gets a product object with empty ID
  Future<void> addProduct(Product product) async {
    final jsonProduct = json.encode(
      {
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'isFavorite': product.isFavorite,
      },
    );

    try {
      final response = await http.post(
        _productsUrl,
        body: jsonProduct,
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    final jsonUpdatedProduct = json.encode(
      {
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
      },
    );
    final _productByIdUrl = Uri.parse(
        'https://flutter-myshop-49e90-default-rtdb.europe-west1.firebasedatabase.app/products/${product.id}.json');
    try {
      await http.patch(
        _productByIdUrl,
        body: jsonUpdatedProduct,
      );

      final index = _items.indexWhere((element) => element.id == product.id);
      _items[index] = product;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> deleteProduct(Product product) async {
    final _productByIdUrl = Uri.parse(
        'https://flutter-myshop-49e90-default-rtdb.europe-west1.firebasedatabase.app/products/${product.id}.json');
    Product? existingProduct = product;
    final existingProductIndex =
        _items.indexWhere((element) => element.id == product.id);

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final res = await http.delete(_productByIdUrl);
    if (res.statusCode >= 400) {
      items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException(statusCode: res.statusCode);
    }
    existingProduct = null;
  }
}
