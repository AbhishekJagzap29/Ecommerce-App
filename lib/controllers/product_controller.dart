import 'package:get/get.dart';
import 'package:flutter_ecommerce_app/models/product_model.dart';
import 'package:flutter_ecommerce_app/services/api_service.dart';

class ProductController extends GetxController {
  final ApiService apiService;
  ProductController({required this.apiService});

  final allProducts = <Product>[].obs;
  final categoryProducts = <Product>[].obs;
  final selectedProduct = Rxn<Product>();

  final isLoadingAll = false.obs;
  final isLoadingCategory = false.obs;
  final isLoadingDetails = false.obs;

  final errorAll = ''.obs;
  final errorCategory = ''.obs;
  final errorDetails = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }

  // Fetch all products for Dashboard "Special For You" section
  Future<void> fetchAllProducts() async {
    try {
      isLoadingAll.value = true;
      errorAll.value = '';
      final products = await apiService.getAllProducts();
      allProducts.assignAll(products);
    } catch (e) {
      errorAll.value = e.toString();
    } finally {
      isLoadingAll.value = false;
    }
  }

  // Fetch products by category for ProductListScreen
  Future<void> fetchProductsByCategory(String category) async {
    try {
      isLoadingCategory.value = true;
      errorCategory.value = '';
      categoryProducts.clear();
      final products = await apiService.getProductsByCategory(category);
      categoryProducts.assignAll(products);
    } catch (e) {
      errorCategory.value = e.toString();
    } finally {
      isLoadingCategory.value = false;
    }
  }

  // Fetch product by ID for ProductDetailsScreen (Requirement #2)
  Future<void> fetchProductById(int id) async {
    try {
      isLoadingDetails.value = true;
      errorDetails.value = '';
      selectedProduct.value = null;
      final product = await apiService.getProductById(id);
      selectedProduct.value = product;
    } catch (e) {
      errorDetails.value = e.toString();
    } finally {
      isLoadingDetails.value = false;
    }
  }
}
