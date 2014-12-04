class User < ActiveRecord::Base
	before_save { self.email = email.downcase }#Ensuring email uniqueness by downcasing the email attribute.


	validates :name,  presence: true, length: { maximum: 50 }	#ensures that the user name cannot be blank or empty spaces
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i	#email format
	validates :email, presence: true, length: { maximum: 255 }, 
							format: { with: VALID_EMAIL_REGEX },   #validate with email format
							 uniqueness: { case_sensitive: false }

	has_secure_password	#allows for saving securely hashed passwords
	validates :password, length: { minimum: 6 }
end
