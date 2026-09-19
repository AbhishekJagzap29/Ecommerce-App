import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_ecommerce_app/constants/app_colors.dart';
import 'package:flutter_ecommerce_app/controllers/product_controller.dart';
import 'package:flutter_ecommerce_app/views/product/product_details_screen.dart';
import 'package:flutter_ecommerce_app/widgets/error_view.dart';
import 'package:flutter_ecommerce_app/widgets/product_card.dart';
import 'package:flutter_ecommerce_app/widgets/skeleton_loader.dart';

class ProductListScreen extends StatefulWidget {
  final String category;

  const ProductListScreen({
    super.key,
    required this.category,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductController productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    productController.fetchProductsByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.category.capitalizeFirst ?? widget.category,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (productController.isLoadingCategory.value) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: ProductSkeletonGrid(itemCount: 6),
          );
        }

        if (productController.errorCategory.value.isNotEmpty) {
          return ErrorView(
            errorMessage: productController.errorCategory.value,
            onRetry: () => productController.fetchProductsByCategory(widget.category),
          );
        }

        final products = productController.categoryProducts;

        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.search_off_rounded,
                    size: 56,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No Products Found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Try exploring another category.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
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
    );
  }
}
