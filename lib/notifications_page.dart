import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MarketplacePage extends StatefulWidget {
  @override
  _MarketplacePageState createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  List<Product> products = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
    });
    final response =
        await http.get(Uri.parse('http://localhost:8000/api/products/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        products
            .addAll(data.map((product) => Product.fromJson(product)).toList());
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marketplace'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == products.length - 1) {
                  _fetchProducts(); // Fetch more products when reaching the end
                }
                final product = products[index];
                return ListTile(
                  leading: Image.network(product.image),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price} - ${product.producer}'),
                );
              },
            ),
    );
  }
}

class Product {
  final String image;
  final String name;
  final double price;
  final String producer;

  Product({
    required this.image,
    required this.name,
    required this.price,
    required this.producer,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      price:
          json['price'] != null ? double.parse(json['price'].toString()) : 0.0,
      producer: json['producer'] ?? '',
    );
  }
}
