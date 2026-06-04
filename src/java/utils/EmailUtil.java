package utils;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

public final class EmailUtil {

    // Đường dẫn ghi file email để test local nhanh
    private static final String LOG_FILE_PATH = "C:\\Users\\NGUYENLONG\\Desktop\\LeaveManagement\\email_sent.txt";

    public static boolean sendResetCode(String toEmail, String code) {
        String subject = "Mã xác thực đặt lại mật khẩu - Mini HRM System";
        String content = """
            Xin chào,
            
            Bạn vừa gửi yêu cầu đặt lại mật khẩu cho tài khoản trên hệ thống Mini HRM System.
            Mã xác thực (OTP) của bạn là: %s
            
            Mã xác thực này có hiệu lực trong 5 phút. Vui lòng không chia sẻ mã này cho bất kỳ ai.
            
            Trân trọng,
            Ban Quản Trị Mini HRM System
            """.formatted(code);

        // 1. In ra console của Tomcat server
        System.out.println("==================================================");
        System.out.println("[EMAIL SENT] To: " + toEmail);
        System.out.println("[EMAIL SENT] Subject: " + subject);
        System.out.println("[EMAIL SENT] Code: " + code);
        System.out.println("==================================================");

        // 2. Ghi file txt local tại thư mục gốc dự án để dev dễ copy OTP
        try (FileWriter fw = new FileWriter(LOG_FILE_PATH, false);
             PrintWriter pw = new PrintWriter(fw)) {
            SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            pw.println("=== THƯỜNG TRỰC GỬI EMAIL THỬ NGHIỆM ===");
            pw.println("Thời gian gửi: " + df.format(new Date()));
            pw.println("Người nhận: " + toEmail);
            pw.println("Tiêu đề: " + subject);
            pw.println("Mã OTP: " + code);
            pw.println("----------------------------------------");
            pw.println(content);
            pw.println("========================================");
        } catch (IOException e) {
            System.out.println("Error writing to email_sent.txt: " + e.getMessage());
            // fallback to relative path if absolute path fails
            try (FileWriter fw = new FileWriter("email_sent.txt", false);
                 PrintWriter pw = new PrintWriter(fw)) {
                pw.println("OTP: " + code + " for email " + toEmail);
            } catch (IOException ex) {
                System.out.println("Fallback writing failed: " + ex.getMessage());
            }
        }

        // 3. Nếu bạn muốn cấu hình gửi qua SMTP (Gmail, v.v.), có thể sử dụng thư viện hoặc socket gửi mail tại đây.
        // Hiện tại trả về true để giả lập gửi thành công.
        return true;
    }

    private EmailUtil() {
    }
}
