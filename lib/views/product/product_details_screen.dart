import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_ecommerce_app/constants/app_colors.dart';
import 'package:flutter_ecommerce_app/controllers/product_controller.dart';
import 'package:flutter_ecommerce_app/controllers/cart_controller.dart';
import 'package:flutter_ecommerce_app/widgets/error_view.dart';
import 'package:flutter_ecommerce_app/widgets/custom_button.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();

  int quantity = 1;
  int selectedColorIndex = 0;
  int selectedTabIndex = 0;

  final List<Color> availableColors = const [
    Color(0xFF2C2C2C),
    Color(0xFFFF9E9E),
    Color(0xFFFF8000),
    Color(0xFF009688),
    Color(0xFF8E8E93),
  ];

  @override
  void initState() {
    super.initState();
    // MANDATORY REQUIREMENT: Fetch product details from API using product ID
    productController.fetchProductById(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (productController.isLoadingDetails.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (productController.errorDetails.value.isNotEmpty) {
          return ErrorView(
            errorMessage: productController.errorDetails.value,
            onRetry: () => productController.fetchProductById(widget.productId),
          );
        }

        final product = productController.selectedProduct.value;

        if (product == null) {
          return const Center(
            child: Text('Product unavailable'),
          );
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Product Image Centered
                    Container(
                      height: 260,
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      child: Hero(
                        tag: 'product_img_${product.id}',
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported_outlined, size: 64, color: AppColors.textLight),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // White Details Sheet Container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Price
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const Text(
                                'Seller: Official Store',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Rating Pill
                          if (product.rating != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded, color: Colors.white, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${product.rating!.rate}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '(${product.rating!.count} Reviews)',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 20),

                          // Color Swatches
                          const Text(
                            'Color',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: List.generate(availableColors.length, (index) {
                              final isSelected = selectedColorIndex == index;
                              return GestureDetector(
                                onTap: () => setState(() => selectedColorIndex = index),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: availableColors[index],
                                    child: isSelected
                                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                                        : null,
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 24),

                          // Tab Selector (Description, Specifications, Reviews)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                _buildTabButton('Description', 0),
                                _buildTabButton('Specifications', 1),
                                _buildTabButton('Reviews', 2),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Description Text Content
                          if (selectedTabIndex == 0)
                            Text(
                              product.description,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.6,
                                color: AppColors.textSecondary,
                              ),
                            )
                          else if (selectedTabIndex == 1)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Category: ${product.category}\nProduct ID: ${product.id}\nAuthenticity: 100% Original',
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.8,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Rated ${product.rating?.rate ?? 4.5} stars out of 5 based on customer feedback.',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Container: Quantity + Add to Cart Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Quantity Control
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (quantity > 1) {
                                setState(() => quantity--);
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Icon(Icons.remove, color: Colors.white, size: 18),
                            ),
                          ),
                          Text(
                            '$quantity',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() => quantity++);
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Icon(Icons.add, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Add to Cart Button
                    Expanded(
                      child: CustomButton(
                        text: 'Add to Cart',
                        onPressed: () {
                          cartController.addToCart(product, quantity: quantity);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
