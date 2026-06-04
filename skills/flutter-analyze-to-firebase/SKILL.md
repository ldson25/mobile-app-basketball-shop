---
name: flutter-analyze-to-firebase
description: Đọc và phân tích code Flutter hiện tại (đặc biệt UI User) để đề xuất cấu trúc Firestore tối ưu và chi tiết cho dự án E-commerce.
metadata:
  category: firebase
  version: 1.2
---

# Flutter → Firebase Firestore Schema Analysis Skill

## When to use
- Khi cần thiết kế database Firestore từ code UI hiện có
- Khi chuyển từ dữ liệu hardcode sang Firebase
- Khi refactor hoặc mở rộng tính năng

## Mục đích
Đọc toàn bộ code Flutter hiện tại → Phân tích logic, UI và dữ liệu → Đề xuất cấu trúc Firestore **hợp lý, tối ưu, dễ bảo trì và scale**.

## Process Bắt Buộc (Luôn thực hiện theo thứ tự)

1. **Đọc và phân tích code**
   - Đọc toàn bộ thư mục `features/`, `shared/`, và các file Model/Screen liên quan
   - Xác định các dữ liệu đang hardcode hoặc đang được sử dụng trong UI

2. **Xác định các Entities chính** từ code hiện tại

3. **Đề xuất Firestore Schema**
   - Tên Collection và Sub-collection
   - Các Field + Kiểu dữ liệu phù hợp
   - Document ID nên là gì
   - Field Reference (nếu cần)
   - Index gợi ý

4. **Đề xuất cách tối ưu**
   - Denormalization
   - Embedded data hay Sub-collection
   - Best practices cho E-commerce

5. **Đề xuất Security Rules cơ bản**

## Best Practices cho E-commerce
- Sử dụng `FieldValue.serverTimestamp()` cho `createdAt` và `updatedAt`
- Lưu `id` làm Document ID
- Dùng Sub-collection cho: cart, addresses, reviews
- Denormalization cho Order (lưu thông tin sản phẩm vào đơn hàng)
- Thêm field `isActive`, `createdAt`, `updatedAt`
- Trạng thái đơn hàng: pending, confirmed, shipping, delivered, cancelled, returned
- Field `role` trong users ("user" | "admin")

## Output Format (BẮT BUỘC theo đúng mẫu này)

```markdown
### 1. Phân tích từ code hiện tại
- Các màn hình / tính năng chính đã có: ...
- Dữ liệu và entity phát hiện được: ...

### 2. Các Entity chính
- User, Product, Cart, Order, ...

### 3. Đề xuất Firestore Structure

**Collection: users**
- uid (string) ← Document ID
- ...

**Collection: products**
- ...

**Sub-collections:**
- users/{userId}/cart
- ...

### 4. Gợi ý tối ưu & Lưu ý quan trọng

### 5. Security Rules cơ bản (Firestore)