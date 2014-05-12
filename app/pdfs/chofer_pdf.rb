module ChoferDataPdf
  def chofer_data(view, chofer, print_title)
    if print_title
      text "Datos personales", size: 22, style: :bold
      move_down 5
    end
    data = [["Nombre: ", chofer.nombre]]
    data += [["Apodo:", chofer.apodo]]
    data += [["Estado:", chofer.estado.descripcion + " desde el " + view.format_date(chofer.fechaestado)]]
    table data, header: false, cell_style: {borders: [], padding: [2,5,2,5]}
  end
end

class ChoferPdf < Prawn::Document
  include PdfReport
  include DocumentoPdf
  include ChoferDataPdf

  def initialize(chofer, view, title)
    super({size: "A4"})
    header(title)
    chofer_data(view, chofer, true)
    documentos(chofer.documentos, "Documentos relacionados", "- No existen documentos relacionados -")
    footer(title)
  end
end