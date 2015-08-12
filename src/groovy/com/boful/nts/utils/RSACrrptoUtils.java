package com.boful.nts.utils;

import javax.crypto.Cipher;
import java.io.ByteArrayOutputStream;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Signature;

/**
 * Created by lvy6 on 14-4-30.
 */
public class RSACrrptoUtils {
    /**
     * RSA最大加密明文大小
     */
    private static final int MAX_ENCRYPT_BLOCK = 234;
    /**
     * RSA最大解密文本大小
     */
    private static final int MAX_DECRYPT_BLOCK = 256;
    /**
     * 加密
     * @param publicKey
     * @param buffer
     * @return
     */
    public static byte[] encrypt(PublicKey publicKey, byte[] buffer) {
        try {
            Cipher cipher = Cipher.getInstance("RSA");
            cipher.init(Cipher.ENCRYPT_MODE, publicKey);
            int inputLen = buffer.length;
            int offSet = 0;
            byte[] cache;
            int i = 0;
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            // 对数据分段加密
            while (inputLen - offSet > 0) {
                if (inputLen - offSet > MAX_ENCRYPT_BLOCK) {
                    //cipher.update(buffer, offSet, MAX_ENCRYPT_BLOCK);
                    cache = cipher.doFinal(buffer, offSet, MAX_ENCRYPT_BLOCK);
                } else {
                    cache = cipher.doFinal(buffer, offSet, inputLen - offSet);
                }
                out.write(cache, 0, cache.length);
                i++;
                offSet = i * MAX_ENCRYPT_BLOCK;
            }
            return out.toByteArray();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;

    }
    /**
     * 解密
     * @param privateKey
     * @param buffer
     * @return
     */
    public static byte[] decrypt(PrivateKey privateKey, byte[] buffer) {
        try {
            Cipher cipher = Cipher.getInstance("RSA");
            cipher.init(Cipher.DECRYPT_MODE, privateKey);
            int inputLen = buffer.length;
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            int offSet = 0;
            byte[] cache;
            int i = 0;
            // 对数据分段解密
            while (inputLen - offSet > 0) {
                if (inputLen - offSet > MAX_DECRYPT_BLOCK) {
                    cache = cipher.doFinal(buffer, offSet, MAX_DECRYPT_BLOCK);
                } else {
                    cache = cipher.doFinal(buffer, offSet, inputLen - offSet);
                }
                out.write(cache, 0, cache.length);
                i++;
                offSet = i * MAX_DECRYPT_BLOCK;
            }
            byte[] decryptedData = out.toByteArray();
            out.close();
            return decryptedData;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    /**
     * 签名
     * @param privateKey
     * @param buffer
     * @return
     */
    public static byte[] sign(PrivateKey privateKey, byte[] buffer) {
        try {
            Signature signature = Signature.getInstance("SHA1withRSA");
            signature.initSign(privateKey);
            signature.update(buffer);
            return signature.sign();
        } catch (Exception e) {
        }
        return null;
    }

    public static boolean verify(PublicKey publicKey,byte[] signData, byte[] buffer) {
        try {
            Signature signature = Signature.getInstance("SHA1withRSA");
            signature.initVerify(publicKey);
            signature.update(buffer);
            return signature.verify(signData);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
