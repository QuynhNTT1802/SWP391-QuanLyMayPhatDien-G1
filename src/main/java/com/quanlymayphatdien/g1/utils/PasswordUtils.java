/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.utils;
import org.mindrot.jbcrypt.BCrypt;
/**
 *
 * @author Aadmin
 */
public class PasswordUtils {
    public static String hash(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }
    
    public static boolean verify(String plainPassword, String stored) {
        if (stored == null) return false;
        if (stored.startsWith("$2a$")) {
            return BCrypt.checkpw(plainPassword, stored);
        }
        return stored.equals(plainPassword);
    }
    
    public static boolean isHashed(String stored) {
        return stored != null && stored.startsWith("$2a$");
    }
}
