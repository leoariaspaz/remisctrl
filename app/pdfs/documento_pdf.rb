module DocumentoPdf
  def documentos(documentos, title, empty_text)
    move_down 20
    text title, size: 15, style: :bold
    move_down 5
    if documentos.empty?
      text empty_text, align: :center
      return
    end
    total = documentos.count
    documentos.each_with_index do |d, i|
      text "[#{i + 1} de #{total}] - #{d.tipo_imagen.descripcion}"
      move_down 5
      image d.imagen.current_path, position: :center, width: 500
      move_down 30
    end
  end
end