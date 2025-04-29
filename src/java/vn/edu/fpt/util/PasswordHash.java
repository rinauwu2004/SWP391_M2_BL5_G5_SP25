package vn.edu.fpt.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility class for hashing passwords and verifying password hashes
 */
public class PasswordHash {
    private static final Logger LOGGER = Logger.getLogger(PasswordHash.class.getName());
    
    /**
     * Generate a random salt for password hashing
     * @return Base64 encoded salt string
     */
    public static String generateSalt() {
        try {
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[16];
            random.nextBytes(salt);
            return Base64.getEncoder().encodeToString(salt);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error generating salt", e);
            // Fallback to a simple but consistent salt if there's an error
            return "DefaultSalt123456789=";
        }
    }
    
    /**
     * Hash a password with SHA-256 and salt
     * @param password Plain text password
     * @param salt Salt string (Base64 encoded)
     * @return Hashed password
     */
    public static String hashPassword(String password, String salt) {
        try {
            // Validate inputs
            if (password == null || salt == null) {
                LOGGER.warning("Null password or salt provided to hashPassword");
                return null;
            }
            
            // Ensure salt is valid Base64
            String validSalt = ensureValidBase64(salt);
            
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(Base64.getDecoder().decode(validSalt));
            byte[] hashedPassword = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hashedPassword);
        } catch (NoSuchAlgorithmException e) {
            LOGGER.log(Level.SEVERE, "SHA-256 algorithm not available", e);
            return null;
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.SEVERE, "Error decoding Base64 salt: " + salt, e);
            return null;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error hashing password", e);
            return null;
        }
    }
    
    /**
     * Verify if a password matches the stored hash
     * @param password Plain text password to check
     * @param storedHash Stored hash to compare against
     * @param storedSalt Stored salt used for hashing
     * @return true if password matches, false otherwise
     */
    public static boolean verifyPassword(String password, String storedHash, String storedSalt) {
        try {
            // Validate inputs
            if (password == null || storedHash == null || storedSalt == null) {
                LOGGER.warning("Null input provided to verifyPassword");
                return false;
            }
            
            String newHash = hashPassword(password, storedSalt);
            return newHash != null && newHash.equals(storedHash);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error verifying password", e);
            return false;
        }
    }
    
    /**
     * Ensures a string is valid Base64 by padding if necessary
     * @param input Base64 string to validate
     * @return Valid Base64 string
     */
    private static String ensureValidBase64(String input) {
        try {
            // Check if the string is already valid
            Base64.getDecoder().decode(input);
            return input;
        } catch (IllegalArgumentException e) {
            // Add proper padding if needed
            switch (input.length() % 4) {
                case 2:
                    return input + "==";
                case 3:
                    return input + "=";
                default:
                    // If it's not a simple padding issue, return a default
                    LOGGER.warning("Invalid Base64 string cannot be fixed with simple padding: " + input);
                    return "DefaultSalt123456789="; // Safe default
            }
        }
    }
    
    /**
     * Utility method to generate a new hash for a password
     * @param password The password to hash
     * @return Object array containing [hash, salt]
     */
    public static String[] generatePasswordHash(String password) {
        String salt = generateSalt();
        String hash = hashPassword(password, salt);
        return new String[]{hash, salt};
    }
    
    /**
     * Main method to generate password hash and salt for testing
     * @param args command line arguments
     */
    public static void main(String[] args) {
        String password = "123";
        
        System.out.println("Password Hash Generator");
        System.out.println("======================");
        
        // Option to provide password or use default
        System.out.print("Enter password (or press Enter to use 'password123'): ");
        
       
        
        // Generate and display results
        String salt = generateSalt();
        String hash = hashPassword(password, salt);
        
        System.out.println("\nResults:");
        System.out.println("-----------------------");
        System.out.println("Password: " + password);
        System.out.println("Salt: " + salt);
        System.out.println("Hash: " + hash);
        System.out.println("-----------------------");
        
        // SQL insert example
        System.out.println("\nExample SQL Insert:");
        System.out.println("INSERT INTO [User] (username, password_hash, password_salt, ...) VALUES");
        System.out.println("('testuser', '" + hash + "', '" + salt + "', ...);");
        
        // Verify the password
        System.out.println("\nVerifying password: " + verifyPassword(password, hash, salt));
        
        // Show multiple generations for the same password
        System.out.println("\nMultiple generations for the same password:");
        for (int i = 0; i < 3; i++) {
            String newSalt = generateSalt();
            String newHash = hashPassword(password, newSalt);
            System.out.println("Salt " + (i+1) + ": " + newSalt);
            System.out.println("Hash " + (i+1) + ": " + newHash);
            System.out.println();
        }
    }
}
