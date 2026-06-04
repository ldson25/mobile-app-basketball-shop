---
name: basketball-firebase-implementation
description: Skill CHI TIẾT để tạo Model (freezed), Repository, Riverpod Notifier, Security Rules theo cấu trúc Firestore của dự án Basketball E-commerce.
metadata:
  category: firebase
  project: basketball
  version: 1.3
---

# Basketball Firebase Implementation Skill (Chi Tiết)

## Project Context
- Dự án E-commerce Basketball (bán giày, áo, quần, phụ kiện bóng rổ)
- Sử dụng Firebase Auth + Firestore
- Áp dụng mạnh Denormalization
- Phân quyền User & Admin
- Phải tuân thủ **basketball-firebase-structure**

## When to use this skill
- Khi đã có cấu trúc Firestore
- Khi cần tạo Model, Repository, Provider
- Khi implement tính năng mới
- Khi refactor code Firebase

## Process Bắt Buộc (Luôn thực hiện theo thứ tự)

1. **Tạo Model Dart (`freezed`)**
2. **Tạo Repository**
3. **Tạo Riverpod Notifier / Provider**
4. **Cung cấp Security Rules** (nếu yêu cầu)

## Best Practices (Bắt Buộc Tuân Thủ)

- Sử dụng `freezed` + `json_annotation`
- Model phải có:
  - `fromJson` / `toJson`
  - `fromFirestore` / `toFirestore`
  - `copyWith`
- Repository phải:
  - Xử lý lỗi (`FirebaseException`, `Exception`)
  - Trả về `Either` hoặc dùng `AsyncValue`
  - Sử dụng `FieldValue.serverTimestamp()`
- Riverpod dùng `AsyncNotifierProvider`
- Đặt file theo cấu trúc:
  - `lib/models/`
  - `lib/data/repositories/`
  - `lib/features/*/providers/`

## Ưu Tiên Implement (Thứ Tự Khuyến Nghị)

1. Product + Review
2. User + Cart + Favorites + Addresses
3. Category
4. Order
5. Banner
6. InventoryMovement & AdminActivity

---



