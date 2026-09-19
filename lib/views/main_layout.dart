import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_ecommerce_app/constants/app_colors.dart';
import 'package:flutter_ecommerce_app/controllers/cart_controller.dart';
import 'package:flutter_ecommerce_app/views/dashboard/dashboard_screen.dart';
import 'package:flutter_ecommerce_app/views/cart/cart_screen.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;
  const MainLayout({super.key, this.initialIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentIndex;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const CartScreen(),
    const _PlaceholderView(title: 'Wishlist', icon: Icons.favorite_border_rounded),
    const _PlaceholderView(title: 'Profile', icon: Icons.person_outline_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textLight,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Obx(
                () => Badge(
                  isLabelVisible: cartController.totalItemsCount > 0,
                  label: Text('${cartController.totalItemsCount}'),
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
              ),
              activeIcon: Obx(
                () => Badge(
                  isLabelVisible: cartController.totalItemsCount > 0,
                  label: Text('${cartController.totalItemsCount}'),
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.shopping_cart_rounded),
                ),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              activeIcon: Icon(Icons.favorite_rounded),
              label: 'Wishlist',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderView extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderView({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text(
              '$title Screen',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coming Soon',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
