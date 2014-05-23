class Documento < ActiveRecord::Base
  after_destroy :remove_id_directory
  
  belongs_to :documentable, polymorphic: true
  belongs_to :tipo_imagen, class_name: 'Relleno', foreign_key: 'tipo_imagen_id'
  
  mount_uploader :imagen, ImagenUploader
  
  validates :tipo_imagen_id, :imagen, presence: true
  validates :tipo_imagen_id, inclusion: { in: :estados_validos,
  						message: 'no es uno de los estados válidos' }
  
private
  def remove_id_directory
		FileUtils.remove_dir("#{Rails.root}/public/#{imagen.store_dir}", :force => true)  	
  end
  
	def estados_validos
		TipoImagen.all_for_validate_inclusion
  end  
end
