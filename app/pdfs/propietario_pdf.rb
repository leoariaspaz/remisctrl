module PropietarioDataPdf
  def propietario_data(view, propietario, print_title)
    if print_title
      text "Datos personales", size: 22, style: :bold
      move_down 5
    end
    data = [["Nombre: ", propietario.nombre]]
    data += [["Documento: ", "#{propietario.tipo_doc.sintetico} #{propietario.nrodoc}"]]
    data += [["Fecha de alta: ", view.format_date(propietario.fecha_alta)]]
    data += [["Estado: ", propietario.estado.descripcion + " desde el " + view.format_date(propietario.fecha_estado)]]
    table data, header: false, cell_style: {borders: [], padding: [2,5,2,5]}
  end
end

class PropietarioPdf < Prawn::Document
  include PdfReport
  include DocumentoPdf
  include PropietarioDataPdf

  def initialize(propietario, view, title)
    super({size: "A4"})
    header(title)
    propietario_data(view, propietario, true)
    documentos(propietario.documentos, "Documentos relacionados", "- No existen documentos relacionados -")
    footer(title)
  end
end