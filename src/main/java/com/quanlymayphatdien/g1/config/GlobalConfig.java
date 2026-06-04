package com.quanlymayphatdien.g1.config;

public class GlobalConfig {
    
    public static final String REGEX_USERNAME = "^[a-zA-Z0-9_]+$";
    
    public static final String REGEX_PASSWORD = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$";
    
    public static final String REGEX_EMAIL = 
        "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    
    public static final String REGEX_PHONE = "^0[0-9]{9,10}$";
    
    public static final String TEST = "TEST";
}
