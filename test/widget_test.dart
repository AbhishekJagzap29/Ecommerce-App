import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce_app/models/product_model.dart';
import 'package:flutter_ecommerce_app/controllers/cart_controller.dart';
import 'package:flutter_ecommerce_app/controllers/auth_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('E-Commerce App Unit Tests', () {
    late CartController cartController;
    late AuthController authController;

    final sampleProduct = Product(
      id: 1,
      title: 'Test Product',
      price: 29.99,
      description: 'A sample test product description',
      category: 'electronics',
      image: 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
    );

    setUp(() {
      cartController = CartController();
      authController = AuthController();
    });

    test('Initial Cart should be empty', () {
      expect(cartController.cartItems.length, 0);
      expect(cartController.subtotal, 0.0);
      expect(cartController.totalItemsCount, 0);
    });

    testWidgets('Adding product to cart increases total count and calculates subtotal', (WidgetTester tester) async {
      cartController.addToCart(sampleProduct, quantity: 2);

      expect(cartController.cartItems.length, 1);
      expect(cartController.totalItemsCount, 2);
      expect(cartController.subtotal, closeTo(59.98, 0.01));
      expect(cartController.isInCart(1), true);
    });

    testWidgets('Adding same product ID again increments existing item quantity', (WidgetTester tester) async {
      cartController.addToCart(sampleProduct, quantity: 1);
      cartController.addToCart(sampleProduct, quantity: 2);

      expect(cartController.cartItems.length, 1);
      expect(cartController.cartItems.first.quantity, 3);
      expect(cartController.totalItemsCount, 3);
    });

    testWidgets('Decrementing item quantity works and removes when quantity reaches 0', (WidgetTester tester) async {
      cartController.addToCart(sampleProduct, quantity: 2);
      
      cartController.decrementQuantity(sampleProduct.id);
      expect(cartController.cartItems.first.quantity, 1);

      cartController.decrementQuantity(sampleProduct.id);
      expect(cartController.cartItems.length, 0);
    });

    test('AuthController email & password validation', () {
      authController.emailController.text = 'invalidemail';
      authController.passwordController.text = '123';
      
      expect(authController.validate(), false);
      expect(authController.emailError.value.isNotEmpty, true);
      expect(authController.passwordError.value.isNotEmpty, true);

      authController.emailController.text = 'user@example.com';
      authController.passwordController.text = 'secret123';

      expect(authController.validate(), true);
      expect(authController.emailError.value.isEmpty, true);
      expect(authController.passwordError.value.isEmpty, true);
    });
  });
}
