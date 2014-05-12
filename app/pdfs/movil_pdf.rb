# basado en 
# https://github.com/ryanb/railscasts-episodes/blob/master/episode-153/revised/store-after/app/pdfs/order_pdf.rb

require "propietario_pdf.rb"
require "chofer_pdf.rb"

class MovilPdf < Prawn::Document
  include PdfReport
  include DocumentoPdf
  include PropietarioDataPdf
  include ChoferDataPdf

  def initialize(movil, view, title, with_associations)
    super({size: "A4"})
    @movil = movil
    @view = view
    @title = title
    header(title)
    movil_data
    documentos(@movil.documentos, "Documentos relacionados", "- No existen documentos relacionados -")
    if with_associations == "1"
      print_propietario(movil.propietario)
      print_chofer(movil.chofer)
    end
    footer(title)
  end

  def movil_data
    text "Móvil", size: 22, style: :bold
    move_down 5
    data = [["Nº Móvil: ", @movil.nromovil]]
    data += [["Marca:", @movil.marca]]
    data += [["Modelo:", @movil.modelo]]
    data += [["Dominio:", @movil.dominio]]
    data += [["Estado:", @movil.estado.descripcion + " desde el " + @view.format_date(@movil.fecha_estado)]]
    data += [["Agencia: ", @movil.agencia.nil?? "<sin agencia asignada>" : @movil.agencia.descripcion]]
    data += [["Propietario:", @movil.propietario.nil?? "<sin propietario asignado>" : @movil.propietario.nombre]]
    data += [["Chofer:", @movil.chofer.nil?? "<sin chofer asignado>" : @movil.chofer.nombre]]
    table data, header: false, cell_style: {borders: [], padding: [2,5,2,5]}
  end  

  def print_propietario(propietario)
    move_down 40    
    text "Propietario", size: 15, style: :bold
    if propietario.nil?
      move_down 5
      text "- El móvil no tiene asignado un propietario -", align: :center      
    else
      propietario_data(@view, propietario, false)
      documentos(propietario.documentos, "Documentos del propietario", 
        "- El propietario no tiene documentos relacionados -")
    end
  end

  def print_chofer(chofer)
    move_down 40
    text "Chofer", size: 15, style: :bold
    if chofer.nil?
      move_down 5
      text "- El móvil no tiene asignado un chofer -", align: :center
    else
      chofer_data(@view, chofer, false)
      documentos(chofer.documentos, "Documentos del chofer", "- El chofer no tiene documentos relacionados -")
    end
  end
end