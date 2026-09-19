import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_ecommerce_app/models/cart_item_model.dart';
import 'package:flutter_ecommerce_app/models/product_model.dart';
import 'package:flutter_ecommerce_app/constants/app_colors.dart';
import 'package:flutter_ecommerce_app/views/cart/cart_screen.dart';

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;

  double get subtotal {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get total => subtotal;

  int get totalItemsCount {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  bool isInCart(int productId) {
    return cartItems.any((item) => item.product.id == productId);
  }

  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = cartItems.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      // Product ID already in cart: increment quantity
      cartItems[existingIndex].quantity += quantity;
      cartItems.refresh();
    } else {
      // Add new CartItem
      cartItems.add(CartItem(product: product, quantity: quantity));
    }

    if (Get.context != null) {
      Get.snackbar(
        '✓ Product added to cart',
        '${product.title} was added to your cart.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        mainButton: TextButton(
          onPressed: () => Get.to(() => const CartScreen()),
          child: const Text(
            'View Cart',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  void incrementQuantity(int productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh();
    }
  }

  void decrementQuantity(int productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        cartItems.refresh();
      } else {
        removeFromCart(productId);
      }
    }
  }

  void removeFromCart(int productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      final removedTitle = cartItems[index].product.title;
      cartItems.removeAt(index);
      
      if (Get.context != null) {
        Get.snackbar(
          'Item Removed',
          '$removedTitle removed from cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.textPrimary,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    }
  }

  void clearCart() {
    cartItems.clear();
  }
}
