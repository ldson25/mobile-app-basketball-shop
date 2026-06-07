# 🏀 Kinetic Mobile App

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" />
  <img alt="Dart" src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" />
  <img alt="Firebase" src="https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase" />
  <img alt="Riverpod" src="https://img.shields.io/badge/riverpod-%23000000.svg?style=for-the-badge&logo=dart&logoColor=white" />
</p>

Một **ứng dụng di động E-commerce** (Thương mại điện tử) toàn diện, được xây dựng bằng Flutter và Firebase, chuyên thiết kế dành cho các cửa hàng bán lẻ đồ thể thao và bóng rổ. 

Dự án này bao gồm cả **Giao diện Người dùng (User Interface)** phong phú dành cho khách hàng và **Bảng điều khiển Quản trị (Admin Dashboard)** mạnh mẽ để quản lý cửa hàng. Ứng dụng được tích hợp sâu với **Cloudinary** để lưu trữ hình ảnh và **MoMo Sandbox** để xử lý thanh toán ví điện tử.

---

## ✨ Tính Năng Nổi Bật

### 🛒 Dành Cho Người Dùng (Khách Hàng)
- **Xác thực tài khoản:** Đăng nhập bằng Email/Password hoặc Đăng nhập qua Google (Google Sign-in).
- **Khám phá sản phẩm:** Tìm kiếm, lọc và xem thông tin chi tiết của sản phẩm bao gồm kích thước (sizes), tùy chọn (variants), số lượng tồn kho theo thời gian thực và đánh giá (reviews).
- **Giỏ hàng & Yêu thích:** Quản lý sản phẩm trong giỏ hàng, điều chỉnh số lượng và lưu các sản phẩm yêu thích.
- **Hệ thống thanh toán thông minh:** Áp dụng mã giảm giá (voucher), tính toán phí giao hàng tự động dựa trên các quy tắc thiết lập sẵn, và lựa chọn địa chỉ giao hàng linh hoạt.
- **Thanh toán:** Tích hợp thanh toán qua **Ví điện tử MoMo** (Môi trường Sandbox) thông qua WebView, song song với hình thức thanh toán khi nhận hàng (COD).
- **Quản lý đơn hàng:** Theo dõi trạng thái đơn hàng (timeline), xem lịch sử mua hàng, và gửi yêu cầu hủy đơn hoặc trả hàng.
- **Hồ sơ cá nhân:** Quản lý nhiều địa chỉ giao hàng, phương thức thanh toán, ví voucher cá nhân và chuyển đổi giao diện Sáng/Tối (Light/Dark mode).

### 🛡️ Dành Cho Quản Trị Viên (Admin)
- **Bảng điều khiển (Dashboard):** Tổng quan doanh thu theo ngày, các đơn hàng đang chờ xử lý, cảnh báo sản phẩm sắp hết hàng và lượng khách hàng mới.
- **Quản lý sản phẩm:** Đầy đủ các thao tác Thêm/Sửa/Xóa/Ẩn (CRUD), theo dõi kho hàng, quản lý biến thể (kích thước/tùy chọn) và tải ảnh trực tiếp lên nền tảng Cloudinary.
- **Quản lý đơn hàng:** Cập nhật trạng thái đơn hàng, xử lý các yêu cầu hủy/trả hàng và xem chi tiết lịch sử từng đơn.
- **Quản lý khách hàng:** Theo dõi tổng chi tiêu, tổng số đơn hàng của từng khách và xếp hạng thành viên (Member/VIP).
- **Voucher & Khuyến mãi:** Tạo và quản lý mã giảm giá (giảm theo % hoặc số tiền cố định, miễn phí vận chuyển) áp dụng theo từng hạng thành viên.
- **Cấu hình ứng dụng:** Bật/tắt chế độ bảo trì, quản lý phương thức thanh toán, thiết lập luật giao hàng (shipping rules), và quản lý banner hiển thị ở trang chủ.
- **Nhật ký hoạt động (Activity Logs):** Ghi lại toàn bộ thao tác của quản trị viên để dễ dàng đối soát và theo dõi.

---

## 🛠️ Công Nghệ Sử Dụng

- **Frontend:** [Flutter](https://flutter.dev/), Dart
- **Quản lý trạng thái (State Management):** [Riverpod](https://riverpod.dev/), Provider
- **Backend & Database:** Firebase (Authentication, Cloud Firestore)
- **Lưu trữ đa phương tiện:** Cloudinary API
- **Cổng thanh toán:** MoMo E-wallet Sandbox
- **Tích hợp khác:** Google Maps Flutter, Google Generative AI (Gemini), Webview

---

## 📁 Cấu Trúc Thư Mục

Dự án được tổ chức theo kiến trúc ưu tiên tính năng (feature-first architecture):

```text
lib/
 ├── core/          # Tiện ích cốt lõi, cấu hình theme, hằng số (constants)
 ├── features/      # Các module chức năng (Auth, Cart, Home, Profile,...)
 ├── models/        # Các model dữ liệu
 ├── services/      # Các dịch vụ bên ngoài (Firebase, Cloudinary, MoMo)
 ├── shared/        # Các component dùng chung và helper
 └── widgets/       # Các UI widget dùng chung trên toàn ứng dụng
```

---

## 🚀 Hướng Dẫn Cài Đặt

### Yêu cầu trước khi cài đặt
- Flutter SDK (`^3.11.4` hoặc mới hơn)
- Android Studio / VS Code
- Một dự án Firebase đã bật Authentication và Firestore
- Tài khoản Cloudinary (để tải ảnh lên)
- Tài khoản MoMo Developer (để tích hợp thanh toán)

### Cài đặt chi tiết

1. **Clone repository**
   ```bash
   git clone https://github.com/yourusername/mobile-app-basketball-shop.git
   cd mobile-app-basketball-shop
   ```

2. **Cài đặt các gói phụ thuộc (Dependencies)**
   ```bash
   flutter pub get
   ```

3. **Cấu hình Firebase**
   - Kết nối ứng dụng với dự án Firebase của bạn bằng FlutterFire CLI: `flutterfire configure`.
   - Đảm bảo các file `google-services.json` (dành cho Android) và `GoogleService-Info.plist` (dành cho iOS) đã được tạo và đặt đúng vị trí.

4. **Chạy ứng dụng**
   ```bash
   flutter run
   ```

---

## 📸 Ảnh Chụp Màn Hình

*(Mẹo: Hãy thay thế các link ảnh mẫu dưới đây bằng ảnh chụp màn hình ứng dụng thực tế của bạn để repository trông ấn tượng hơn!)*

<p align="center">
  <img src="https://via.placeholder.com/250x500.png?text=Home+Screen" width="22%" />
  <img src="https://via.placeholder.com/250x500.png?text=Product+Details" width="22%" />
  <img src="https://via.placeholder.com/250x500.png?text=Cart+%26+Checkout" width="22%" />
  <img src="https://via.placeholder.com/250x500.png?text=Admin+Dashboard" width="22%" />
</p>

---

