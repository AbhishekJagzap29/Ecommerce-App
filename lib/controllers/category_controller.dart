import 'package:get/get.dart';
import 'package:flutter_ecommerce_app/services/api_service.dart';

class CategoryController extends GetxController {
  final ApiService apiService;
  CategoryController({required this.apiService});

  final categories = <String>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedCategories = await apiService.getCategories();
      categories.assignAll(fetchedCategories);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
