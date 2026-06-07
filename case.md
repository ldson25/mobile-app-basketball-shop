# Danh sách chức năng trong project

## Tổng quan

Project là app bán hàng thời trang/thể thao bằng Flutter, dùng Firebase Authentication, Cloud Firestore, Cloudinary cho ảnh, Gemini AI cho Chatbot và MoMo Sandbox cho thanh toán ví điện tử.

Dữ liệu chính đang được tách theo các collection/subcollection:

- `users`
- `users/{uid}/cart`
- `users/{uid}/addresses`
- `users/{uid}/favorites`
- `users/{uid}/payment_methods`
- `products`
- `products/{productId}/reviews`
- `orders`
- `orders/{orderId}/return_requests`
- `orders/{orderId}/status_history`
- `vouchers`
- `app_config/settings`
- `shipping_rules`
- `banners`
- `admin_logs`

## Chức năng User

### Xác thực tài khoản

- Đăng nhập bằng email/password.
- Đăng ký tài khoản mới.
- Đăng nhập Google.
- Phân quyền user/admin sau khi đăng nhập.
- User chưa đăng nhập khi thêm giỏ hàng hoặc yêu thích sẽ được yêu cầu đăng nhập/đăng ký.

### Trang Home

- Hiển thị banner trang chủ.
- Banner lấy từ Firestore thông qua `banners`.
- Hiển thị danh sách sản phẩm.
- Product card có nút thêm vào giỏ hàng.
- Product card có nút thêm vào yêu thích.
- Giới hạn/tải ảnh sản phẩm từ URL Cloudinary.

### Discover/Search

- Trang tìm kiếm/khám phá sản phẩm.
- Lấy dữ liệu sản phẩm từ Firestore `products`.
- Hỗ trợ hiển thị kết quả theo từ khóa/filter sản phẩm.

### Chi tiết sản phẩm

- Hiển thị ảnh, tên, giá, mô tả, category, size/option, tồn kho.
- Chọn size/option sản phẩm.
- Thêm vào giỏ hàng.
- Thêm vào yêu thích.
- Hiển thị review từ `products/{productId}/reviews`.
- Chỉ cho phép đánh giá sản phẩm khi user có đơn hàng trạng thái `delivered`.
- Các trạng thái khác không hiện nút đánh giá.

### Giỏ hàng

- Hiển thị danh sách sản phẩm trong giỏ.
- Tăng/giảm số lượng.
- Chọn sản phẩm để checkout.
- Xóa sản phẩm khỏi giỏ.
- Tính tổng tiền theo sản phẩm đã chọn.
- Giỏ hàng lưu theo user tại `users/{uid}/cart`.

### Yêu thích

- Hiển thị danh sách sản phẩm yêu thích.
- Thêm/xóa sản phẩm yêu thích.
- Dữ liệu lưu theo user tại `users/{uid}/favorites`.

### Địa chỉ giao hàng

- Hiển thị danh sách địa chỉ.
- Thêm địa chỉ mới.
- Sửa địa chỉ.
- Xóa địa chỉ.
- Chọn địa chỉ mặc định.
- Dữ liệu lưu theo `users/{uid}/addresses`.

### Checkout

- Bước 1: nhập/chọn thông tin giao hàng.
- Bước 2: chọn phương thức thanh toán.
- Bước 3: hoàn tất đặt hàng.
- Tính phí giao hàng theo `shipping_rules`.
- Áp dụng voucher theo code.
- Voucher được lấy từ Firestore `vouchers`.
- Voucher lọc theo tier: `all`, `member`, `vip`.
- Tạo đơn hàng vào `orders`.
- Xóa các item đã checkout khỏi giỏ hàng.

### Thanh toán

- COD.
- Chuyển khoản ngân hàng đang để ở trạng thái cấu hình/làm sau.
- Thẻ ngân hàng đang để ở trạng thái làm sau.
- MoMo Sandbox đã tích hợp tạo payment request.
- MoMo hiển thị bằng WebView thanh toán web trong app.
- Nếu WebView trả `resultCode=0` hoặc `9000` thì tiếp tục tạo đơn hàng.

### Đơn hàng User

- Hiển thị lịch sử đơn hàng.
- Lọc theo trạng thái đơn.
- Xem chi tiết đơn hàng.
- Hiển thị tracking/status timeline.
- Hiển thị thông tin giao hàng.
- Hiển thị tổng tiền, phí ship, voucher, giảm giá.
- Đơn `pending` có thể gửi yêu cầu hủy.
- Đơn `delivered` có thể gửi yêu cầu trả hàng.
- Đơn `delivered` hiện nút `ĐÃ NHẬN HÀNG`.
- Đơn đã hủy/đã trả không cho cập nhật tiếp từ phía admin.

### Hủy/trả hàng

- User gửi yêu cầu hủy đơn.
- User gửi yêu cầu trả hàng.
- Lưu lý do, ghi chú, sản phẩm liên quan vào `orders/{orderId}/return_requests`.
- Cập nhật trạng thái đơn theo logic hủy/trả.

### Voucher của tôi

- Trang voucher user trong profile.
- Lấy voucher thật từ Firestore `vouchers`.
- Chỉ hiện voucher active và phù hợp tier user.

### Phương thức thanh toán của user

- Hiển thị COD.
- Lưu phương thức thanh toán theo `users/{uid}/payment_methods`.
- MoMo/thẻ ngân hàng đang nằm trong hướng tích hợp/mở rộng sau.

### Profile

- Hiển thị thông tin user.
- Cập nhật thông tin cá nhân.
- Cập nhật avatar qua Cloudinary nếu đã cấu hình.
- Truy cập địa chỉ giao hàng.
- Truy cập phương thức thanh toán.
- Truy cập voucher của tôi.
- Hỗ trợ light/dark mode thông qua ThemeService.

### AI Chatbot (Gemini)

- Tích hợp Google Gemini AI làm trợ lý ảo trực tiếp trong app.
- Hỗ trợ người dùng hỏi đáp về sản phẩm, chính sách cửa hàng, thông tin size giày/quần áo.
- Cung cấp giao diện chat mượt mà, tự động định dạng markdown trả về từ AI.

### Giao diện Light Mode / Dark Mode

- Tích hợp ThemeService quản lý chuyển đổi chế độ Sáng/Tối.
- Toàn bộ app (User và Admin) đều hỗ trợ linh hoạt thay đổi bảng màu (AppColors).
- Có thể tự động theo hệ thống hoặc cài đặt chủ động trong Profile / Admin Settings.
- Lưu trạng thái theme vào shared preferences để khởi tạo lại đúng chế độ mỗi khi mở app.

## Chức năng Admin

### Admin Shell

- Giao diện admin riêng sau khi đăng nhập bằng tài khoản admin.
- Bottom navigation gồm Dashboard, Sản phẩm, Đơn hàng, Khách hàng, Cài đặt.

### Dashboard Admin

- Hiển thị doanh thu hôm nay.
- Hiển thị đơn chờ xử lý.
- Hiển thị sản phẩm sắp hết hàng.
- Hiển thị khách mới.
- Hiển thị việc cần xử lý.
- Hiển thị đơn gần đây/hoạt động mới.
- Dữ liệu lấy từ Firestore `orders`, `products`, `users`.
- Đơn đã hủy/đã trả không tính vào doanh thu.

### Quản lý sản phẩm

- Lấy sản phẩm thật từ Firestore `products`.
- Thêm sản phẩm mới.
- Sửa sản phẩm.
- Xóa sản phẩm.
- Ẩn/hiện sản phẩm.
- Cập nhật tồn kho.
- Quản lý size/option theo loại sản phẩm:
  - Quần áo: S/M/L/XL.
  - Giày: size số 36/37/38...
  - Phụ kiện/bóng rổ: không bắt buộc size, dùng stock mặc định.
- Chọn ảnh từ điện thoại hoặc chụp ảnh trực tiếp.
- Upload ảnh lên Cloudinary.
- Lưu URL ảnh Cloudinary vào Firestore.
- Ghi admin log khi thêm/sửa/ẩn hiện/cập nhật tồn kho sản phẩm.

### Quản lý đơn hàng

- Hiển thị danh sách đơn hàng từ `orders`.
- Tìm kiếm/lọc đơn hàng.
- Xem chi tiết đơn hàng.
- Cập nhật trạng thái đơn hàng.
- Lưu lịch sử trạng thái vào `orders/{orderId}/status_history`.
- Không cho cập nhật đơn đã hủy hoặc đã trả.
- Xem danh sách yêu cầu hủy/trả hàng trong đơn.
- Ghi admin log khi đổi trạng thái đơn.

### Quản lý khách hàng

- Lấy user từ `users`.
- Kết hợp với `orders` để tính thông tin khách.
- Hiển thị tổng đơn.
- Hiển thị tổng chi tiêu.
- Hiển thị lần mua gần nhất.
- Hiển thị role.
- Hiển thị membership/member/vip.
- Đơn đã hủy/đã trả không tính vào chi tiêu hợp lệ.

### Quản lý voucher

- Thêm voucher.
- Sửa voucher.
- Xóa voucher.
- Bật/tắt voucher.
- Cấu hình loại giảm giá:
  - Giảm theo phần trăm.
  - Giảm số tiền cố định.
  - Free shipping.
- Cấu hình giá trị tối thiểu.
- Cấu hình voucher cho `all`, `member`, `vip`.
- Dữ liệu lưu vào `vouchers`.
- User có thể thấy voucher trong trang Voucher của tôi nếu active và đúng tier.

### Admin Settings/App Config

- Lưu cấu hình thật vào `app_config/settings`.
- Bật/tắt maintenance mode.
- Bật/tắt COD.
- Bật/tắt chuyển khoản.
- Bật/tắt ví điện tử.
- Bật/tắt free shipping.
- Bật/tắt light/dark mode tổng thể.
- Ghi admin log khi sửa config.

### Shipping Rules

- Quản lý quy tắc giao hàng trong `shipping_rules`.
- Sửa phí ship.
- Sửa ngưỡng miễn phí.
- Bật/tắt rule giao hàng.
- Checkout đọc rule này để tính phí giao hàng.

### Banner Management

- Lấy banner từ `banners`.
- Seed banner mặc định.
- Sửa thông tin banner.
- Bật/tắt banner.
- Home user hiển thị banner active.
- Ghi admin log khi sửa banner.

### Admin Activity Logs

- Lưu log vào `admin_logs`.
- Ghi lại các hành động admin:
  - Thêm/sửa/ẩn hiện sản phẩm.
  - Cập nhật tồn kho.
  - Đổi trạng thái đơn.
  - Sửa voucher.
  - Sửa config.
  - Sửa banner/shipping rule.
- Admin có thể xem log trong settings.

## Tích hợp dịch vụ

### Firebase Authentication

- Đăng nhập email/password.
- Đăng ký tài khoản.
- Đăng nhập Google.
- Lấy role user/admin từ Firestore.

### Cloud Firestore

- Lưu user, product, order, voucher, banner, config, shipping rule, admin log.
- Lưu subcollection theo user: cart, favorites, addresses, payment methods.
- Lưu subcollection theo order: return requests, status history.
- Lưu subcollection theo product: reviews.

### Cloudinary

- Upload ảnh sản phẩm từ admin.
- Upload avatar user nếu cấu hình Cloudinary hợp lệ.
- Firestore chỉ lưu URL ảnh.

### MoMo Sandbox

- Tạo payment request qua endpoint sandbox.
- Ký request bằng HMAC SHA256.
- Dùng `payUrl` để hiển thị trang thanh toán web bằng WebView.
- Theo dõi redirect/resultCode trong WebView.

### Google Gemini AI

- Tích hợp Gemini API để xử lý ngôn ngữ tự nhiên.
- Tạo prompt context cho chatbot để trả lời dưới tư cách nhân viên chăm sóc khách hàng.

---

## Phân công công việc (Task Assignment)

Dự án được phân bổ khối lượng công việc cụ thể cho từng thành viên trong nhóm nhằm đảm bảo tiến độ và chất lượng đồ án:

### Lương Duy Sơn

**Trách nhiệm chung:** Xây dựng hệ thống Backend (Firebase/Firestore), luồng dữ liệu quản trị (Admin) và thanh toán.
- Xây dựng luồng Xác thực tài khoản (Firebase Auth) và phân quyền hệ thống User/Admin.
- Thiết kế cấu trúc cơ sở dữ liệu Cloud Firestore schemas (Users, Products, Orders, Vouchers, Logs...).
- Phát triển toàn bộ module Admin Shell: Quản lý sản phẩm, Quản lý đơn hàng, Quản lý khách hàng và Voucher.
- Tích hợp và xử lý API thanh toán điện tử thông qua MoMo Sandbox.
- Cấu hình hệ thống App Setting, quản lý quy tắc Ship và Banner quảng cáo động.
- Thiết kế và phát triển tính năng quản lý lịch sử đơn hàng (Status Timeline), thông báo tiến độ giao hàng cho User.

### Phước

**Trách nhiệm chung:** Xây dựng trải nghiệm mua sắm (User Flow), xử lý logic frontend phức tạp và tích hợp công nghệ AI/Media.
- Thiết kế và phát triển luồng mua hàng: hệ thống Giỏ hàng, Wishlist và quy trình Checkout (tính phí ship, apply voucher, tạo đơn).
- Xây dựng các trang Home, Discover/Search, Chi tiết sản phẩm dành cho người dùng cuối.
- Xây dựng UI/UX toàn bộ module Profile người dùng, quản lý Địa chỉ giao hàng và Phương thức thanh toán.
- Tích hợp hệ thống kết nối API với Cloudinary để xử lý và quản lý ảnh sản phẩm/avatar.
- Tích hợp và tinh chỉnh hệ thống AI Chatbot (Google Gemini) để làm trợ lý ảo tư vấn trực tiếp trong app.
- Xây dựng logic chuyển đổi linh hoạt Dark Mode / Light Mode bằng ThemeService và đồng bộ UI/UX toàn app.

### Tâm Đắc

**Trách nhiệm chung:** Hỗ trợ thiết kế UI cơ bản, chuẩn bị tài liệu báo cáo, thuyết trình và kiểm thử phần mềm.
- Đảm nhận thiết kế slide báo cáo (PPTX) và chuẩn bị tài liệu, kịch bản thuyết trình bảo vệ đồ án.
- Thiết kế các UI mockups cơ bản và hỗ trợ tìm, fix các lỗi hiển thị UI (overflow, responsive) trên nhiều màn hình.
- Test toàn bộ các luồng chức năng của app, báo lỗi (QA) để hai dev chính sửa chữa.
- Chuẩn bị hình ảnh sản phẩm, thiết lập bộ dữ liệu mẫu (mock data) trên Firebase để phục vụ quá trình demo.
