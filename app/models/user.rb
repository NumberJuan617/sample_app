class User < ActiveRecord::Base
    attr_accessor :remember_token
	before_save { self.email = email.downcase }#Ensuring email uniqueness by downcasing the email attribute.


	validates :name,  presence: true, length: { maximum: 50 }	#ensures that the user name cannot be blank or empty spaces
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i	#email format
	validates :email, presence: true, length: { maximum: 255 }, 
							format: { with: VALID_EMAIL_REGEX },   #validate with email format
							 uniqueness: { case_sensitive: false }

	has_secure_password	#allows for saving securely hashed passwords
  validates :password, length: { minimum: 6 }, allow_blank: true
	# Returns the hash digest of the given string.
  	def User.digest(string)
	    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
	                                                  BCrypt::Engine.cost
	    BCrypt::Password.create(string, cost: cost)
  	end

	def User.new_token
		SecureRandom.urlsafe_base64
	end

	def remember
		self.remember_token = User.new_token
    	update_attribute(:remember_digest, User.digest(remember_token))

	end

	def authenticated?(remember_token)
	  return false if remember_digest.nil?

  	  BCrypt::Password.new(remember_digest).is_password?(remember_token)
  	end

  	def forget
    update_attribute(:remember_digest, nil)
  	end

end
