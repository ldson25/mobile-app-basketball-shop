---
name: flutter-ui-consistency
description: Giữ UI nhất quán giữa phần User và Admin
---

# UI Consistency Skill

**Bắt buộc phải tuân thủ khi làm bất kỳ màn Admin nào:**
- Đọc kỹ toàn bộ code UI User trước khi bắt đầu
- Sử dụng chung `Theme.of(context)`, ColorScheme, TextTheme
- Dùng lại widgets từ thư mục `shared/widgets/` càng nhiều càng tốt
- Giữ cùng naming convention, spacing, border radius, shadow, icon size
- Hỗ trợ dark mode giống phần User
- Style của Button, Card, TextField, AppBar phải giống hệt

**Mục tiêu**: Admin phải trông như là cùng một app với phần User.
