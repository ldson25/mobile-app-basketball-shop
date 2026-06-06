# Danh sach chuc nang trong project

## Tong quan

Project la app ban hang thoi trang/the thao bang Flutter, dung Firebase Authentication, Cloud Firestore, Cloudinary cho anh va MoMo Sandbox cho thanh toan vi dien tu.

Du lieu chinh dang duoc tach theo cac collection/subcollection:

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

## Chuc nang User

### Xac thuc tai khoan

- Dang nhap bang email/password.
- Dang ky tai khoan moi.
- Dang nhap Google.
- Phan quyen user/admin sau khi dang nhap.
- User chua dang nhap khi them gio hang hoac yeu thich se duoc yeu cau dang nhap/dang ky.

### Trang Home

- Hien thi banner trang chu.
- Banner lay tu Firestore thong qua `banners`.
- Hien thi danh sach san pham.
- Product card co nut them vao gio hang.
- Product card co nut them vao yeu thich.
- Gioi han/tai anh san pham tu URL Cloudinary.

### Discover/Search

- Trang tim kiem/kham pha san pham.
- Lay du lieu san pham tu Firestore `products`.
- Ho tro hien thi ket qua theo tu khoa/filter san pham.

### Chi tiet san pham

- Hien thi anh, ten, gia, mo ta, category, size/option, ton kho.
- Chon size/option san pham.
- Them vao gio hang.
- Them vao yeu thich.
- Hien thi review tu `products/{productId}/reviews`.
- Chi cho phep danh gia san pham khi user co don hang trang thai `delivered`.
- Cac trang thai khac khong hien nut danh gia.

### Gio hang

- Hien thi danh sach san pham trong gio.
- Tang/giam so luong.
- Chon san pham de checkout.
- Xoa san pham khoi gio.
- Tinh tong tien theo san pham da chon.
- Gio hang luu theo user tai `users/{uid}/cart`.

### Yeu thich

- Hien thi danh sach san pham yeu thich.
- Them/xoa san pham yeu thich.
- Du lieu luu theo user tai `users/{uid}/favorites`.

### Dia chi giao hang

- Hien thi danh sach dia chi.
- Them dia chi moi.
- Sua dia chi.
- Xoa dia chi.
- Chon dia chi mac dinh.
- Du lieu luu theo `users/{uid}/addresses`.

### Checkout

- Buoc 1: nhap/chon thong tin giao hang.
- Buoc 2: chon phuong thuc thanh toan.
- Buoc 3: hoan tat dat hang.
- Tinh phi giao hang theo `shipping_rules`.
- Ap dung voucher theo code.
- Voucher duoc lay tu Firestore `vouchers`.
- Voucher loc theo tier: `all`, `member`, `vip`.
- Tao don hang vao `orders`.
- Xoa cac item da checkout khoi gio hang.

### Thanh toan

- COD.
- Chuyen khoan ngan hang dang de o trang thai cau hinh/lam sau.
- The ngan hang dang de o trang thai lam sau.
- MoMo Sandbox da tich hop tao payment request.
- MoMo hien thi bang WebView thanh toan web trong app.
- Neu WebView tra `resultCode=0` hoac `9000` thi tiep tuc tao don hang.

### Don hang User

- Hien thi lich su don hang.
- Loc theo trang thai don.
- Xem chi tiet don hang.
- Hien thi tracking/status timeline.
- Hien thi thong tin giao hang.
- Hien thi tong tien, phi ship, voucher, giam gia.
- Don `pending` co the gui yeu cau huy.
- Don `delivered` co the gui yeu cau tra hang.
- Don `delivered` hien nut `DA NHAN HANG`.
- Don da huy/da tra khong cho cap nhat tiep tu phia admin.

### Huy/tra hang

- User gui yeu cau huy don.
- User gui yeu cau tra hang.
- Luu ly do, ghi chu, san pham lien quan vao `orders/{orderId}/return_requests`.
- Cap nhat trang thai don theo logic huy/tra.

### Voucher cua toi

- Trang voucher user trong profile.
- Lay voucher that tu Firestore `vouchers`.
- Chi hien voucher active va phu hop tier user.

### Phuong thuc thanh toan cua user

- Hien thi COD.
- Luu phuong thuc thanh toan theo `users/{uid}/payment_methods`.
- MoMo/the ngan hang dang nam trong huong tich hop/mo rong sau.

### Profile

- Hien thi thong tin user.
- Cap nhat thong tin ca nhan.
- Cap nhat avatar qua Cloudinary neu da cau hinh.
- Truy cap dia chi giao hang.
- Truy cap phuong thuc thanh toan.
- Truy cap voucher cua toi.
- Ho tro light/dark mode thong qua ThemeService.

## Chuc nang Admin

### Admin Shell

- Giao dien admin rieng sau khi dang nhap bang tai khoan admin.
- Bottom navigation gom Dashboard, San pham, Don hang, Khach hang, Cai dat.

### Dashboard Admin

- Hien thi doanh thu hom nay.
- Hien thi don cho xu ly.
- Hien thi san pham sap het hang.
- Hien thi khach moi.
- Hien thi viec can xu ly.
- Hien thi don gan day/hoat dong moi.
- Du lieu lay tu Firestore `orders`, `products`, `users`.
- Don da huy/da tra khong tinh vao doanh thu.

### Quan ly san pham

- Lay san pham that tu Firestore `products`.
- Them san pham moi.
- Sua san pham.
- Xoa san pham.
- An/hien san pham.
- Cap nhat ton kho.
- Quan ly size/option theo loai san pham:
  - Quan ao: S/M/L/XL.
  - Giay: size so 36/37/38...
  - Phu kien/bong ro: khong bat buoc size, dung stock mac dinh.
- Chon anh tu dien thoai hoac chup anh truc tiep.
- Upload anh len Cloudinary.
- Luu URL anh Cloudinary vao Firestore.
- Ghi admin log khi them/sua/an hien/cap nhat ton kho san pham.

### Quan ly don hang

- Hien thi danh sach don hang tu `orders`.
- Tim kiem/loc don hang.
- Xem chi tiet don hang.
- Cap nhat trang thai don hang.
- Luu lich su trang thai vao `orders/{orderId}/status_history`.
- Khong cho cap nhat don da huy hoac da tra.
- Xem danh sach yeu cau huy/tra hang trong don.
- Ghi admin log khi doi trang thai don.

### Quan ly khach hang

- Lay user tu `users`.
- Ket hop voi `orders` de tinh thong tin khach.
- Hien thi tong don.
- Hien thi tong chi tieu.
- Hien thi lan mua gan nhat.
- Hien thi role.
- Hien thi membership/member/vip.
- Don da huy/da tra khong tinh vao chi tieu hop le.

### Quan ly voucher

- Them voucher.
- Sua voucher.
- Xoa voucher.
- Bat/tat voucher.
- Cau hinh loai giam gia:
  - Giam theo phan tram.
  - Giam so tien co dinh.
  - Free shipping.
- Cau hinh gia tri toi thieu.
- Cau hinh voucher cho `all`, `member`, `vip`.
- Du lieu luu vao `vouchers`.
- User co the thay voucher trong trang Voucher cua toi neu active va dung tier.

### Admin Settings/App Config

- Luu cau hinh that vao `app_config/settings`.
- Bat/tat maintenance mode.
- Bat/tat COD.
- Bat/tat chuyen khoan.
- Bat/tat vi dien tu.
- Bat/tat free shipping.
- Bat/tat light/dark mode tong the.
- Ghi admin log khi sua config.

### Shipping Rules

- Quan ly quy tac giao hang trong `shipping_rules`.
- Sua phi ship.
- Sua nguong mien phi.
- Bat/tat rule giao hang.
- Checkout doc rule nay de tinh phi giao hang.

### Banner Management

- Lay banner tu `banners`.
- Seed banner mac dinh.
- Sua thong tin banner.
- Bat/tat banner.
- Home user hien thi banner active.
- Ghi admin log khi sua banner.

### Admin Activity Logs

- Luu log vao `admin_logs`.
- Ghi lai cac hanh dong admin:
  - Them/sua/an hien san pham.
  - Cap nhat ton kho.
  - Doi trang thai don.
  - Sua voucher.
  - Sua config.
  - Sua banner/shipping rule.
- Admin co the xem log trong settings.

## Tich hop dich vu

### Firebase Authentication

- Dang nhap email/password.
- Dang ky tai khoan.
- Dang nhap Google.
- Lay role user/admin tu Firestore.

### Cloud Firestore

- Luu user, product, order, voucher, banner, config, shipping rule, admin log.
- Luu subcollection theo user: cart, favorites, addresses, payment methods.
- Luu subcollection theo order: return requests, status history.
- Luu subcollection theo product: reviews.

### Cloudinary

- Upload anh san pham tu admin.
- Upload avatar user neu cau hinh Cloudinary hop le.
- Firestore chi luu URL anh.

### MoMo Sandbox

- Tao payment request qua endpoint sandbox.
- Ky request bang HMAC SHA256.
- Dung `payUrl` de hien thi trang thanh toan web bang WebView.
- Theo doi redirect/resultCode trong WebView.

## Ghi chu test hien tai

