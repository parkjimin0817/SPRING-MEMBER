package com.brenex.pjm.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class FormatUtil {

    public static String formatDate(LocalDateTime date){
        if(date == null) return "-";
        return date.format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
    }

    public static String formatPhone(String phone){
        if(phone == null || phone.isBlank()) return "";

        if (phone != null) {
            // 숫자만 남기기 (혹시 공백이나 특수문자 포함된 경우 대비)
            phone = phone.replaceAll("[^0-9]", "");

            // 11자리 휴대폰 번호라면 (010-1234-5678)
            if (phone.length() == 11) {
                phone = phone.replaceFirst("(\\d{3})(\\d{4})(\\d{4})", "$1-$2-$3");
            }
            // 10자리 (구번호: 011-123-4567 같은)
            else if (phone.length() == 10) {
                phone = phone.replaceFirst("(\\d{3})(\\d{3})(\\d{4})", "$1-$2-$3");
            }
        }

        return phone;
    }

    public static String removeHyphen(String phone) {
        if(phone == null || phone.isBlank()) return "";
        //숫자만 남기기
        return phone.replaceAll("[^0-9]", "");
    }
}
