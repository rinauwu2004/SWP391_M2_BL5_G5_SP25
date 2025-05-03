/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vn.edu.fpt.util;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/**
 *
 * @author Rinaaaa
 */
public class PasswordEncryption {
    /**
     * Hashes a password and returns the hash and salt as a String array.
     *
     * @param password The password to hash
     * @return A String array where index 0 is the hash and index 1 is the salt
     */
    public static String[] hashPassword(String password) {
        byte[] salt = generateSalt();
        String saltString = encodePassword(salt);
        String hashString = null;

        try {
            hashString = passwordEncyption(password, salt);
        } catch (Exception ex) {
            Logger.getLogger(PasswordEncryption.class.getName()).log(Level.SEVERE, null, ex);
        }

        return new String[] { hashString, saltString };
    }
    public static String passwordEncyption(String password, byte[] passwordSalt) throws Exception {
        try {
            byte[] salt = passwordSalt;
            int iterations = 10000;
            int keyLength = 256;

            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, keyLength);

            SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
            byte[] hash = factory.generateSecret(spec).getEncoded();
            return encodePassword(hash);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException ex) {
            Logger.getLogger(PasswordEncryption.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    public static boolean checkPassword(String inputPassword, String storedHashBase64, String storedSaltBase64) throws Exception {
        byte[] salt = decodePassword(storedSaltBase64);
        byte[] storedHash = decodePassword(storedHashBase64);

        PBEKeySpec spec = new PBEKeySpec(inputPassword.toCharArray(), salt, 10000, 256);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] inputHash = factory.generateSecret(spec).getEncoded();

        return java.util.Arrays.equals(inputHash, storedHash);
    }
    
    public static byte[] generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[16];
        random.nextBytes(salt);
        return salt;
    }
    
    public static String encodePassword(byte[] input) {
        return Base64.getEncoder().encodeToString(input);
    }
    
    public static byte[] decodePassword(String input) {
        return Base64.getDecoder().decode(input);
    }
}
