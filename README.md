## 🛒 Ecommerce App (Clean Architecture)

This Flutter project follows the **Clean Architecture** pattern, providing a scalable and maintainable structure for feature development.

### 🧱 Architecture Overview

The project is divided into three core layers:

- **Domain Layer**
  - `Product` entity
  - Use cases for:
    - View all products
    - View specific product
    - Create product
    - Update product
    - Delete product
  - Abstract `ProductRepository` interface

- **Data Layer**
  - `ProductModel` for JSON serialization/deserialization
  - `ProductRepositoryImpl` for implementing data access logic

- **Core Layer**
  - Shared utilities such as error handling (e.g., `Failure` classes)

---

### ✅ Features Implemented

- Structured project using Clean Architecture
- Defined and tested all CRUD use cases for `Product`
- Implemented JSON model with `fromJson` and `toJson` methods
- Fully tested `ProductModel` with fixtures
- Cleanly separated domain logic from data implementation

---
