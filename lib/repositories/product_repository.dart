import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../configuration.dart';
import '../utils/token.dart';

class ProductRepository {
  Future<List<Carousel>?> fetchProductCarousel() async {
    final url = Uri.http(Configuration.baseUrlConnect, '/product/get_list_carousels');

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final carouselsData = body["data"]["carouselList"] as List<dynamic>?;
      List<Carousel>? carousels = carouselsData?.map((crl) => Carousel.fromJson(crl)).toList();
      return carousels;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<List<Product>?> fetchPopularProducts() async {
    final url = Uri.http(Configuration.baseUrlConnect, '/product/get_popular_products');

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final popularProductsData = body["data"] as List<dynamic>?;
      List<Product>? popularProducts = popularProductsData?.map((p) => Product.fromJson(p)).toList();
      return popularProducts;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<ProductDetail?> fetchDetailProduct({required String productId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/product/get_product/$productId');

    var token = await Token.getToken();

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final productDetail = ProductDetail.fromJson(body['data']);
      return productDetail;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<List<RelateProduct>?> fetchRelateProducts({required String productId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/product/get_relate_products', {'product_id': productId});

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final relateProductsData = body["data"] as List<dynamic>?;
      List<RelateProduct>? relateProducts = relateProductsData?.map((p) => RelateProduct.fromJson(p)).toList();
      return relateProducts;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<List<String>?> fetchCharacteristics({required String productId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/product/get_list_characteristics', {'product_id': productId});

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final characteristicsData = body["data"] as List<dynamic>?;
      final characteristics = characteristicsData?.map((item) => item.toString()).toList();
      return characteristics;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

}