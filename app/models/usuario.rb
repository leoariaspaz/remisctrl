class Usuario < ActiveRecord::Base
	after_destroy :ensure_not_destroy_admin
	
	has_and_belongs_to_many :roles

	validates :nombre, presence: true, uniqueness: true
	validates :password_confirmation, presence: true		
	validates :password, confirmation: { message: "no coincide con la contraseña ingresada"}
	
	attr_accessor :password_confirmation
	attr_reader 	:password
	
	validate :password_must_be_present	
	
	# password es un atributo virtual
	def password=(password)
		@password = password
		if @password.present?
			generate_salt
			self.hashed_password = self.class.encrypt_password(password, salt)
		end
	end
	
	class << self
		def encrypt_password(password, salt)
			Digest::SHA2.hexdigest(password + "wibble" + salt)
		end
		
		def authenticate(nombre, password)
			if usuario = find_by_nombre_lowercase(nombre)
				if usuario.hashed_password == encrypt_password(password, usuario.salt)
					usuario
				end
			end
		end		
	end
	
protected
	def password_must_be_present
		errors.add(:password, I18n.t("errors.messages.blank")) unless hashed_password.present?
	end
	
	def generate_salt
		self.salt = self.object_id.to_s + rand.to_s
	end
	
	def ensure_not_destroy_admin
		if self.nombre.downcase == "admin"
			raise "No se puede eliminar el usuario administrador"
		end
	end

	def self.find_by_nombre_lowercase(nombre)
		all = Usuario.find :all
		all.select {|u| u.nombre.downcase == nombre.downcase }.first
	end
end
