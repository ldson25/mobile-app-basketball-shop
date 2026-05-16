---
name: basketball-firebase-structure
description: Cấu trúc Firestore Database CHI TIẾT và CHÍNH THỨC cho dự án Basketball E-commerce. Bao gồm tất cả collections, sub-collections, fields, kiểu dữ liệu và best practices.
metadata:
  category: firebase
  project: basketball
  version: 1.2
---

# Basketball Firestore Database Structure (Official)

## Project Overview
- Dự án E-commerce chuyên về sản phẩm Basketball (Giày, Áo, Quần, Phụ kiện...)
- Hỗ trợ User & Admin
- Sử dụng Firebase Auth + Firestore
- Áp dụng mạnh Denormalization để tối ưu tốc độ đọc

---

## 1. Collection: users

**Document ID:** `uid` (từ Firebase Auth)

**Fields:**
- `uid` (string)
- `email` (string)
- `fullName` (string)
- `phoneNumber` (string?)
- `avatarUrl` (string?)
- `role` (string) → `"user"` | `"admin"`
- `isEarlyAccess` (boolean)
- `status` (string) → `"active"` | `"blocked"`
- `createdAt` (timestamp)
- `updatedAt` (timestamp)
- `lastLoginAt` (timestamp?)

**Sub-collections:**
- `cart`
- `favorites`
- `addresses`
- `paymentMethods`

---

### Sub-collection: `users/{userId}/cart`

- `cartItemId` (string) ← Document ID = `{productId}_{size}`
- `productId` (string)
- `name` (string) ← **denormalized**
- `imageUrl` (string) ← **denormalized**
- `size` (string)
- `unitPrice` (number)
- `quantity` (number)
- `isChecked` (boolean) ← dùng cho checkbox trong giỏ hàng
- `addedAt` (timestamp)
- `updatedAt` (timestamp)

---

### Sub-collection: `users/{userId}/favorites`

- `productId` (string) ← Document ID
- `name` (string)
- `imageUrl` (string)
- `price` (number)
- `addedAt` (timestamp)

---

### Sub-collection: `users/{userId}/addresses`

- `addressId` (string) ← auto ID
- `label` (string) → `"home"`, `"office"`, hoặc custom
- `recipientName` (string)
- `phoneNumber` (string)
- `country` (string) → default `"VIET NAM"`
- `city` (string)
- `district` (string)
- `ward` (string?)
- `street` (string)
- `fullAddress` (string)
- `isDefault` (boolean)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

### Sub-collection: `users/{userId}/paymentMethods`

- `paymentMethodId` (string) ← auto ID
- `type` (string) → `"cod"` | `"bank_transfer"` | `"e_wallet"` | `"card"`
- `provider` (string?) → `"momo"`, `"zalopay"`, `"vnpay"`, `"visa"`
- `maskedNumber` (string?)
- `cardHolder` (string?)
- `expiryMonth` (number?)
- `expiryYear` (number?)
- `isDefault` (boolean)
- `createdAt` (timestamp)

---

## 2. Collection: categories

- `categoryId` (string) ← ví dụ: `footwear`, `apparel`, `equipment`
- `name` (string)
- `label` (string)
- `iconName` (string)
- `imageUrl` (string)
- `sortOrder` (number)
- `isActive` (boolean)
- `productCount` (number) ← **denormalized**
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

---

## 3. Collection: products

- `productId` (string)
- `name` (string)
- `slug` (string)
- `description` (string)
- `categoryId` (string)
- `categoryName` (string) ← **denormalized**
- `price` (number)
- `currency` (string) → `"VND"` hoặc `"USD"`
- `imageUrls` (array<string>)
- `thumbnailUrl` (string)
- `badge` (string?)
- `tags` (array<string>)
- `sizes` (array<string>)
- `stockQuantity` (number)
- `isNewArrival` (boolean)
- `isMemberExclusive` (boolean)
- `isBestSeller` (boolean)
- `isSignatureSeries` (boolean)
- `isActive` (boolean)
- `ratingAvg` (number)
- `reviewCount` (number)
- `soldCount` (number)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

**Sub-collection:** `products/{productId}/reviews`

---

## 4. Collection: orders (chi tiết)

- `orderId` (string)
- `orderNumber` (string) ← ví dụ: `ORD-10001`
- `userId` (string)
- `customerName` (string) ← denormalized
- `customerEmail` (string) ← denormalized
- `phoneNumber` (string)
- `status` (string)
- `paymentStatus` (string)
- `paymentMethod` (string)
- `trackingNumber` (string?)
- `shippingAddress` (map)
- `items` (array<map>)
- `subtotal` (number)
- `shippingCost` (number)
- `discountTotal` (number)
- `total` (number)
- `note` (string?)
- `createdAt`, `updatedAt`, `cancelledAt`, `deliveredAt` (timestamp)

---

## 5. Các Collection Khác

- `banners`
- `inventoryMovements`
- `adminActivities`

---

## Best Practices & Rules

- Luôn dùng `FieldValue.serverTimestamp()` cho createdAt/updatedAt
- Ưu tiên Denormalization cho tốc độ đọc
- Sub-collection dùng cho dữ liệu cá nhân hóa (cart, favorites, addresses...)
- Document ID nên có ý nghĩa (không hoàn toàn random)
- Thêm `isActive` cho hầu hết các collection

---

**Skill này là nguồn tham chiếu chính thức.**  
Khi implement Model, Repository hay Security Rules, **phải tuân thủ đúng cấu trúc này**.

---