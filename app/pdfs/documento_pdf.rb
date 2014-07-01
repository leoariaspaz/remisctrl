module DocumentoPdf
  def documentos(documentos, title, empty_text)
    if not title.nil?
      move_down 20
      text title, size: 15, style: :bold      
    end
    move_down 5
    if documentos.empty?
      text empty_text, align: :center
      return
    end
    total = documentos.count
    documentos.each_with_index do |d, i|
      if not title.nil?
        text "[#{i + 1} de #{total}] - #{d.tipo_imagen.descripcion}"
        move_down 5        
      end
      image d.imagen.current_path, position: :center, width: 500
      move_down 30
    end
  end

  class DocumentListPdf < Prawn::Document
    include PdfReport
    include DocumentoPdf
    
    def initialize(lista)
      super({size: "A4"})
      documentos(lista, nil, "- No existen documentos relacionados -")
    end
  end
end