package nts.utils

import java.security.MessageDigest
import sun.misc.BASE64Encoder

class PasswordCodec {
	 //加密
	static encode = {String str ->
		MessageDigest md = MessageDigest.getInstance('SHA')
		md.update(str.getBytes('UTF-8'))
		return (new BASE64Encoder()).encode(md.digest())
	}
}