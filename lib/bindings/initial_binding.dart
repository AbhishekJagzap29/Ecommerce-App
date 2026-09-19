import 'package:get/get.dart';
import 'package:flutter_ecommerce_app/services/api_service.dart';
import 'package:flutter_ecommerce_app/controllers/auth_controller.dart';
import 'package:flutter_ecommerce_app/controllers/category_controller.dart';
import 'package:flutter_ecommerce_app/controllers/product_controller.dart';
import 'package:flutter_ecommerce_app/controllers/cart_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // 1. ApiService Singleton
    final apiService = ApiService();
    Get.put<ApiService>(apiService, permanent: true);

    // 2. AuthController
    Get.put<AuthController>(AuthController(), permanent: true);

    // 3. CategoryController
    Get.put<CategoryController>(
      CategoryController(apiService: Get.find<ApiService>()),
      permanent: true,
    );

    // 4. ProductController
    Get.put<ProductController>(
      ProductController(apiService: Get.find<ApiService>()),
      permanent: true,
    );

    // 5. CartController
    Get.put<CartController>(CartController(), permanent: true);
  }
}
