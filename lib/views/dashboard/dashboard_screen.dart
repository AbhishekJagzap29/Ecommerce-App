import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_ecommerce_app/constants/app_colors.dart';
import 'package:flutter_ecommerce_app/controllers/category_controller.dart';
import 'package:flutter_ecommerce_app/controllers/product_controller.dart';
import 'package:flutter_ecommerce_app/controllers/cart_controller.dart';
import 'package:flutter_ecommerce_app/views/product/product_list_screen.dart';
import 'package:flutter_ecommerce_app/views/product/product_details_screen.dart';
import 'package:flutter_ecommerce_app/views/cart/cart_screen.dart';
import 'package:flutter_ecommerce_app/widgets/error_view.dart';
import 'package:flutter_ecommerce_app/widgets/product_card.dart';
import 'package:flutter_ecommerce_app/widgets/skeleton_loader.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return Icons.headphones_rounded;
      case 'jewelery':
        return Icons.diamond_outlined;
      case "men's clothing":
        return Icons.checkroom_rounded;
      case "women's clothing":
        return Icons.woman_rounded;
      default:
        return Icons.category_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();
    final productController = Get.find<ProductController>();
    final cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Grid icon + Reactive Cart Badge (Matching UI recommendation)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.grid_view_rounded, color: AppColors.textPrimary, size: 22),
                  ),
                  
                  // Cart Icon Badge Button
                  GestureDetector(
                    onTap: () => Get.to(() => const CartScreen()),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Obx(
                        () => Badge(
                          isLabelVisible: cartController.totalItemsCount > 0,
                          label: Text('${cartController.totalItemsCount}'),
                          backgroundColor: AppColors.primary,
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            color: AppColors.textPrimary,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search Bar Field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.textLight),
                    suffixIcon: Icon(Icons.tune_rounded, color: AppColors.primary),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Promotional Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EAE1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Super Sale\nDiscount\nUp to 50%',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Shop Now',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: 110,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 90,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Categories Header & Refresh
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => categoryController.fetchCategories(),
                    child: const Text(
                      'Refresh',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Categories Section with Skeleton Loading State
              Obx(() {
                if (categoryController.isLoading.value) {
                  return const CategorySkeletonGrid();
                }

                if (categoryController.errorMessage.value.isNotEmpty) {
                  return ErrorView(
                    errorMessage: categoryController.errorMessage.value,
                    onRetry: () => categoryController.fetchCategories(),
                  );
                }

                final categories = categoryController.categories;
                if (categories.isEmpty) {
                  return const Center(
                    child: Text('No categories found.'),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return InkWell(
                      onTap: () {
                        Get.to(() => ProductListScreen(category: cat));
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _getCategoryIcon(cat),
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                cat.capitalizeFirst ?? cat,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),

              const SizedBox(height: 28),

              // Special For You Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Special For You',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => productController.fetchAllProducts(),
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // All Products Grid View with Skeleton Loading State
              Obx(() {
                if (productController.isLoadingAll.value) {
                  return const ProductSkeletonGrid();
                }

                if (productController.errorAll.value.isNotEmpty) {
                  return ErrorView(
                    errorMessage: productController.errorAll.value,
                    onRetry: () => productController.fetchAllProducts(),
                  );
                }

                final products = productController.allProducts;
                if (products.isEmpty) {
                  return const Center(
                    child: Text('No products available.'),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Get.to(() => ProductDetailsScreen(productId: product.id));
                      },
                    );
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
