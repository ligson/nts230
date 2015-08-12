package nts.user.domain

class UserInfo {
	String login
	String password
	String firstName
	String lastName
	String email

	static constraints={
		login(unique:true,length:3..15)
		password(matches:/[\w\d]+/,length:3..12)
		email(email:true)
		firstName(blank:false)
		lastName(blank:false)
	}

}
