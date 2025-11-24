package com.brenex.pjm.util;

public class MaskingUtil {

    public static String maskName(String name){
        if( name ==null || name.isBlank() || name.equals("삭제회원")) return name;

        name = name.trim();
        int len = name.length();

        if (len == 1) return name;
        if (len == 2) return name.charAt(0) + "*";

        //3글자 이상인 경우
        StringBuilder sb = new StringBuilder();
        sb.append(name.charAt(0)); //첫글자
        for(int i=1; i<len-1; i++){
            sb.append('*');
        }
        sb.append(name.charAt(len-1)); //마지막 글자
        return sb.toString();
    }

    public static String maskPhone(String phone){
        if(phone==null || phone.isBlank()) return phone;

        int len = phone.length();

        if(len < 7) return phone;

        String head = phone.substring(0, 3);

        int middleLen = len - 7 ; // 앞 3자리 뒤 4자리 제외한 길이
        String middleRaw = phone.substring(3, 3 + middleLen);
        String middleMasked;

        if(middleLen == 3) {
            middleMasked = String.valueOf(middleRaw.charAt(0)) + "**";
        } else if (middleLen == 4) {
            middleMasked = String.valueOf(middleRaw.charAt(0))  + "**" + middleRaw.charAt(3);
        } else {
            middleMasked = middleRaw;
        }

        String last = phone.substring(len - 4);
        String lastMasked = String.valueOf(last.charAt(0))+ "**" + last.charAt(3);

        return head + "-" + middleMasked + "-" + lastMasked;
    }

    public static String maskPwd (String pwd){
        if(pwd==null || pwd.isBlank()) return pwd;

        return "*****";
    }
}
