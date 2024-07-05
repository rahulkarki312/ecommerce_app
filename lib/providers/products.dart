import 'dart:convert';
import 'package:ecommerce_app/providers/userfilter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exceptions.dart';
import 'userReview.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  // var _showFavoritesOnly = false;
  final String authToken;
  final String userId;
  final String username;

  Products(this.authToken, this.userId, this.username, this._items);

  List<ReviewDetails> _reviews = [];

  Map<String, String> brandsAndLogos = {
    'All': '',
    'Nike': 'assets/icons/Name=Nike, Color=Grey.svg',
    'Adidas': 'assets/icons/Name=Adidas, Color=Grey.svg',
    'Jordan': 'assets/icons/Name=Jordan, Color=Grey.svg',
    'Puma': 'assets/icons/Name=Puma, Color=Grey.svg',
    'Vans': 'assets/icons/Name=Vans, Color=Grey.svg'
  };

  List<Product> getFilteredItems(UserFilter filterProvider) {
    List<Product> filteredItems = [..._items];

    //filter by brand
    if (filterProvider.selectedBrand != 'All') {
      filteredItems = _items
          .where((productItem) =>
              productItem.brand == filterProvider.selectedBrand)
          .toList();
    }

    //filter by price range
    if (filterProvider.priceLow != 200 || filterProvider.priceHigh != 700) {
      filteredItems = filteredItems
          .where((productItem) =>
              productItem.price >= filterProvider.priceLow &&
              productItem.price <= filterProvider.priceHigh)
          .toList();
    }

    //filter by most recent
    if (filterProvider.sortByOption == 'Most Recent') {
      filteredItems.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    } else if (filterProvider.sortByOption == 'Lowest Price') {
      filteredItems.sort((a, b) => a.price.compareTo(b.price));
    } else if (filterProvider.sortByOption == 'Highest Review') {}

    //filter by gender
    if (filterProvider.selectedGender == 'Unisex') {
      filteredItems =
          filteredItems.where((product) => product.gender == 'Unisex').toList();
    } else if (filterProvider.selectedGender == 'Man') {
      filteredItems =
          filteredItems.where((product) => product.gender == 'Man').toList();
    } else if (filterProvider.selectedGender == 'Woman') {
      filteredItems =
          filteredItems.where((product) => product.gender == 'Woman').toList();
    }

    //filter by colors
    if (filterProvider.pickedColor != null) {
      filteredItems = filteredItems
          .where((product) =>
              product.colorImages.keys.contains(filterProvider.pickedColor))
          .toList();
    }

    return filteredItems;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String? id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
      'https://my-project-e0439-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString',
    );

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      url = Uri.parse(
        'https://my-project-e0439-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken',
      );
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];

      for (var prodId in extractedData.keys) {
        final prodData = extractedData[prodId];

        // Fetch reviews for the product
        final reviewsUrl = Uri.parse(
          'https://my-project-e0439-default-rtdb.firebaseio.com/products/$prodId/reviews.json?auth=$authToken',
        );
        final reviewResponse = await http.get(reviewsUrl);
        final fetchedReviews =
            json.decode(reviewResponse.body) as Map<String, dynamic>?;

        final List<ReviewDetails> reviews = [];

        if (fetchedReviews != null) {
          fetchedReviews.forEach((reviewId, review) {
            final rating = double.parse(review['rating'].toString());
            reviews.add(ReviewDetails(
              id: reviewId,
              userId: review['userId'],
              username: review['username'],
              review: review['review'],
              rating: rating,
              date: DateTime.parse(review['date']),
            ));
          });
        }

        // Use the calculateAverageRating function to get the average rating
        final avgReview =
            reviews.isNotEmpty ? await fetchAverageRating(prodId) : 0.0;

        final product = Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
          isMan: prodData['isMan'] ?? false,
          discount: prodData['discount'] == null ? 0.0 : (prodData['discount']),
          category: prodData['category'] ?? '',
          reviews: reviews,
          colorImages: prodData['colorImages'] != null
              ? Map<String, String>.from(prodData['colorImages'])
              : {},
          gender: prodData['gender'] ?? 'Unisex',
          sizes: prodData['sizes'] != null
              ? List<String>.from(prodData['sizes'])
              : [],
          brand: prodData['brand'] ?? '',
          dateAdded: DateTime.parse(prodData['dateAdded']),
          avgReview: avgReview,
        );

        loadedProducts.add(product);
      }

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<double> fetchAverageRating(String id) async {
    final url = Uri.parse(
      'https://us-central1-my-project-e0439.cloudfunctions.net/calculateAverageRating?productId=$id',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('review: $data');
      final averageRating = data['roundedAverageRating'];

      // Check if averageRating is an int, convert to double if necessary
      if (averageRating is int) {
        return averageRating.toDouble();
      } else if (averageRating is double) {
        return averageRating;
      } else {
        return 0.0;
      }
    } else {
      print('Failed to fetch average rating');
      return 0.0;
    }
  }

  Future<void> addReview(String review, double rating, String itemId) async {
    final itemIndex = _items.indexWhere((item) => item.id == itemId);

    final selectedProduct = findById(itemId);
    try {
      if (itemIndex >= 0) {
        final postUrl = Uri.parse(
            'https://my-project-e0439-default-rtdb.firebaseio.com/products/$itemId/reviews.json?auth=$authToken');

        final response = await http.post(postUrl,
            body: json.encode({
              'userId': userId,
              'username': username,
              'review': review,
              'rating': rating,
              'date': DateTime.now().toString()
            }));

        final double updatedAvgReview =
            await fetchAverageRating(selectedProduct.id);

        print('calculated avg review after adding: $updatedAvgReview');
        selectedProduct.avgReview = updatedAvgReview;

        selectedProduct.reviews.add(ReviewDetails(
            id: json.decode(response.body)['name'],
            userId: userId,
            username: username,
            review: review,
            rating: rating,
            date: DateTime.now()));

        notifyListeners();
      } else {
        print('...');
      }
    } catch (error) {
      throw error;
    }
  }

  Future removeReview(String reviewId, String itemId) async {
    // final itemIndex = _items.indexWhere((hotel) => hotel.id == itemId);
    final hotel = findById(itemId);
    final url = Uri.parse(
        'https://my-project-e0439-default-rtdb.firebaseio.com/products/$itemId/reviews/$reviewId.json?auth=$authToken');

    final existingReviewIndex =
        hotel.reviews.indexWhere((review) => review.id == reviewId);
    var existingreview = hotel.reviews[existingReviewIndex];
    // _reviews.removeAt()
    hotel.reviews.removeAt(existingReviewIndex);
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      hotel.reviews.insert(existingReviewIndex, existingreview);
      notifyListeners();
      throw HttpException("Could not delete review");
    }
  }

  List<ReviewDetails> get reviews {
    return _reviews;
  }

  Future<List<Product>> getProductsFuture() async {
    return _items;
  }
}
