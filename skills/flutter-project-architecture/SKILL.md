---
name: flutter-project-architecture
description: Architecture chính cho đồ án Flutter E-commerce (User + Admin) - Chưa tích hợp Firebase
metadata:
  category: flutter
  version: 1.1
---

# Flutter E-commerce Project Architecture

## Current Status
- Đã hoàn thành UI User
- Đang phát triển phần Admin
- Database/Firebase sẽ làm sau

## Folder Structure đề xuất (Nên áp dụng)
lib/
├── core/                  # theme, constants, utils, router, extensions
├── features/
│   ├── user/              # (đã có) - Product, Cart, Order, Auth, Profile...
│   └── admin/
│       ├── admin_shell.dart
│       ├── admin_bottom_nav.dart
│       ├── dashboard/
│       ├── product_management/
│       ├── order_management/
│       ├── user_management/
│       └── banner_management/
├── shared/                # widgets, models, components dùng chung
├── data/                  # repositories (sẽ thêm sau)
├── models/
└── main.dart
**Quy tắc bắt buộc:**
- Giữ style, theme, color, button, card... nhất quán giữa User và Admin
- Tách rõ UI - Logic - Data
- Sử dụng Riverpod (khuyến nghị) hoặc Bloc