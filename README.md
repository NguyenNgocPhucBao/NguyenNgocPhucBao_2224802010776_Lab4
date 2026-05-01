# 🌦️ Flutter Weather App - Lab 4

## Sinh viên
- **Họ tên:** Nguyen Ngoc Phuc Bao
- **MSSV:** 2224802010776

---

## Mô tả dự án
Ứng dụng dự báo thời tiết toàn diện được xây dựng bằng **Flutter**, tích hợp dữ liệu thời gian thực từ **OpenWeatherMap API**. Dự án tập trung vào kiến trúc sạch, quản lý trạng thái hiệu quả và trải nghiệm người dùng mượt mà.

---

## Tính năng chính

### Dự báo thời tiết thời gian thực
- **Vị trí hiện tại:** Tự động lấy dữ liệu thời tiết dựa trên GPS của thiết bị.
- **Thông tin chi tiết:** Hiển thị nhiệt độ, cảm giác thực tế, độ ẩm, tốc độ gió, áp suất và tầm nhìn.
- **Dự báo 24 giờ:** Danh sách dự báo theo từng giờ trong ngày.
- **Dự báo 5 ngày:** Xem trước tình hình thời tiết với nhiệt độ cao nhất/thấp nhất.

### Tìm kiếm và Cá nhân hóa
- **Tìm kiếm thông minh:** Tìm kiếm thời tiết theo tên thành phố trên toàn thế giới.
- **Yêu thích:** Lưu trữ tối đa 5 thành phố yêu thích để truy cập nhanh.

### Trải nghiệm người dùng (UX)
- **Dynamic UI:** Giao diện thay đổi màu sắc theo điều kiện thời tiết (Nắng, Mưa, Mây, Đêm).
- **Hỗ trợ ngoại tuyến:** Cache dữ liệu để xem khi không có mạng.
- **Pull-to-refresh:** Vuốt để cập nhật dữ liệu mới nhất.
- **Cài đặt:** Tùy chỉnh đơn vị nhiệt độ (Celsius/Fahrenheit).

---

## Hình ảnh ứng dụng

| Sunny | Rainy | Night |
|-------|-------|-------|
| <img width="288" height="623" alt="image" src="https://github.com/user-attachments/assets/6fd4b954-dc49-47d9-85db-33153e07202c" />

 | ![Rainy](./screenshots/rainy.png) | ![Night](./screenshots/night.png) |

| Search | Forecast | Settings |
|--------|----------|----------|
| ![Search](./screenshots/search.png) | ![Forecast](./screenshots/forecast.png) | ![Settings](./screenshots/settings.png) |

| Loading | Error |
|---------|-------|
| ![Loading](./screenshots/loading.png) | ![Error](./screenshots/error.png) |

---

## Cấu hình API Key
1. Đăng ký tại https://openweathermap.org/users/sign_up
2. Copy file `.env.example` → đổi tên thành `.env`
3. Thêm API key vào file `.env`:
