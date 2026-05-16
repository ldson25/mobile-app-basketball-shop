---
name: flutter-admin-shell
description: Tạo Admin Shell với Bottom Navigation để gom các màn Admin lại
---

# Admin Shell & Bottom Navigation Skill

## Task Flow bắt buộc
1. Đọc code UI User để lấy theme, colors, style
2. Tạo `AdminShell` và `AdminBottomNav`
3. Sử dụng `IndexedStack` để giữ state khi chuyển tab
4. Hỗ trợ 4-5 tab phổ biến: Dashboard, Products, Orders, Users, Settings

**Yêu cầu:**
- Bottom Navigation style phải tương đồng với phần User (nếu có)
- Code sạch, dễ bảo trì
- Dễ mở rộng sau này khi thêm Firebase