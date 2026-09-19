# Flutter E-Commerce Application

A clean, modern, and production-ready E-Commerce mini application built with **Flutter**, **GetX**, and **Fake Store API**.

## Key Features

- ⚡ **Splash Screen**: 3-second automatic timer with smooth logo fade-in transition.
- 🔑 **Login Screen**: Email & Password validation with show/hide password toggle.
- 📦 **Dynamic Categories**: Grid display of product categories fetched live from API (`/products/categories`).
- 🛍️ **Product List Screen**: Dynamically filtered products list by category (`/products/category/{category}`).
- 🔍 **Product Details Screen**: Product info fetched specifically by Product ID (`/products/{id}`).
- 🛒 **Cart Management**: Reactive state management with product ID merging, quantity increment/decrement (`+` / `-`), item removal, subtotal & total bill calculation.
- 💳 **Checkout Placeholder**: Clean order summary bottom container with simulated checkout.
- 🌐 **Error Handling**: Graceful error handling for offline/network issues with retry triggers and snackbar toasts.

---

## Tech Stack & Libraries

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management & Navigation**: [GetX](https://pub.dev/packages/get)
- **HTTP API Service**: [http](https://pub.dev/packages/http)
- **Typography**: [google_fonts](https://pub.dev/packages/google_fonts)
- **Data Source**: [Fake Store API](https://fakestoreapi.com/)

---

## Architecture & Project Structure

This application uses a **GetX-based MVC-style architecture with a decoupled API service layer**:

```
lib/
├── bindings/
│   └── initial_binding.dart       # Centralized GetX dependency injection
├── constants/
│   ├── app_colors.dart            # Primary palette & styling tokens
│   └── app_constants.dart         # Base URLs & endpoint strings
├── controllers/
│   ├── auth_controller.dart       # Form validation & simulated auth
│   ├── category_controller.dart   # Categories state & error handling
│   ├── product_controller.dart    # Product list & product-by-ID fetching
│   └── cart_controller.dart       # Reactive cart items, quantity & total math
├── models/
│   ├── cart_item_model.dart       # Cart item wrapper with quantity
│   └── product_model.dart         # Product schema & JSON parsing
├── services/
│   └── api_service.dart           # Decoupled HTTP API client
├── views/
│   ├── auth/
│   │   └── login_screen.dart      # Validation form & modern input styling
│   ├── cart/
│   │   └── cart_screen.dart       # Cart list, quantity controls & checkout
│   ├── dashboard/
│   │   └── dashboard_screen.dart  # Search, Banner, Categories & Special For You grid
│   ├── product/
│   │   ├── product_details_screen.dart # Detail view fetching data by ID via API
│   │   └── product_list_screen.dart    # Grid displaying products by category
│   ├── splash/
│   │   └── splash_screen.dart     # Fade-in logo + 3s timer navigation
│   └── main_layout.dart           # Bottom navigation wrapper
└── widgets/
    ├── custom_button.dart         # Primary rounded action buttons
    ├── custom_textfield.dart      # Inputs with inline error validation
    ├── error_view.dart            # Network error message & retry component
    └── product_card.dart          # Reusable product grid card component
```

---

## API Integration Endpoints

All data is dynamically fetched from **Fake Store API**:

- **Categories**: `GET https://fakestoreapi.com/products/categories`
- **Products by Category**: `GET https://fakestoreapi.com/products/category/{category}`
- **Product Details by ID**: `GET https://fakestoreapi.com/products/{id}`

---

## How to Run the Project

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run Application**:
   ```bash
   flutter run
   ```

---

## Verification & Testing

- **Static Analysis**:
  ```bash
  flutter analyze
  ```

- **Unit & Widget Tests**:
  ```bash
  flutter test
  ```
