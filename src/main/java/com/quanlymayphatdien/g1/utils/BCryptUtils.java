/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.utils;
import org.mindrot.jbcrypt.BCrypt;
/**
 *
 * @author FPTShop
 */
public class BCryptUtils {

    public static String hash(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    public static boolean verify(String password, String hashed) {
        return BCrypt.checkpw(password, hashed);
    }
}
