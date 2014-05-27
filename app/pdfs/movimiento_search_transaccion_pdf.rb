class MovimientoSearchMovilPdf < Prawn::Document
  include PdfReport
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper 

  TABLE_HEADER = [["Cód. Trx.", "Transacción", "Crédito", "Débito"]]

  def initialize(movimiento_search, view)
    super({page_size: "A4", left_margin: 20, right_margin: 20})
    @file_name = "Movimientos - Por #{MovimientoSearch::TipoInforme[movimiento_search.tipo_informe.to_sym].downcase}"
    subtitle =  "Del #{format_date(movimiento_search.fecha_desde)} al #{format_date(movimiento_search.fecha_hasta)} - " + 
                "Del móvil #{movimiento_search.nromovil_desde} al #{movimiento_search.nromovil_hasta} - " +
                "Agrupado por #{MovimientoSearch::TipoInforme[movimiento_search.tipo_informe.to_sym].downcase}"
    header("Movimientos", subtitle)
    body(movimiento_search)
    footer("Movimientos")
  end

  def file_name
    "#{@file_name}.pdf"
  end

private
  def body(movimiento_search)
    t = ActiveRecord::Base.connection.quoted_true
    movimientos = Movimiento.
                    joins(:transaccion, :cuenta).
                    joins(%{INNER JOIN moviles ON moviles.id = cuentas.movil_id 
                            INNER JOIN choferes ON choferes.id = cuentas.chofer_id}).                    
                    select(%{ moviles.nromovil,
                              choferes.nombre AS nombre_chofer,
                              transacciones.id AS id_transaccion,
                              transacciones.descripcion AS descripcion_transaccion,
                              movimientos.observacion,
                              SUM(CASE WHEN transacciones.es_debito = #{t} THEN 0 ELSE movimientos.importe END) AS creditos,
                              SUM(CASE WHEN transacciones.es_debito = #{t} THEN movimientos.importe ELSE 0 END) AS debitos }).
                    where(%{  movimientos.fecha_movimiento >= ? AND
                              movimientos.fecha_movimiento <= ? AND
                              moviles.nromovil >= ?             AND
                              moviles.nromovil <= ?             AND
                              movimientos.es_contrasiento = ? },
                              movimiento_search.fecha_desde,
                              movimiento_search.fecha_hasta,
                              movimiento_search.nromovil_desde,
                              movimiento_search.nromovil_hasta,
                              false).
                    group( %{ moviles.nromovil,
                              choferes.nombre,
                              transacciones.id,
                              transacciones.descripcion,
                              movimientos.observacion }).
                    order(%{  moviles.nromovil ASC,
                              choferes.nombre ASC })
    if movimientos.empty?
      text "- No se han encontrado movimientos para su consulta -", align: :center
    else
      data = []
      nromovil = 0
      chofer = ""
      movimientos.each do |m|
        data += detail_row(m)
        if nromovil != m.nromovil || chofer != m.nombre_chofer
          if nromovil > 0 and not chofer.empty?
            print_details(data[0..data.size-2])
            data = detail_row(m)
          end
          print_header_group(m.nromovil, m.nombre_chofer)
          nromovil = m.nromovil
          chofer = m.nombre_chofer
        end
      end
      print_details(data)
    end
  end

  def detail_row(movimiento)
    cred = number_to_currency(movimiento.creditos)
    deb = number_to_currency(movimiento.debitos)
    transaccion = movimiento.descripcion_transaccion
    transaccion += " - " + movimiento.observacion unless movimiento.observacion.empty?
    [[movimiento.id_transaccion,
      transaccion,
      cred, deb]]
  end

  def print_details(data)
    data = TABLE_HEADER + data
    table data do
      self.header = true
      self.column_widths = [40, 195, 60, 60]
      self.position = :center
      column(0).align = :center
      column(2..3).align = :right
      cells.style(borders: [], padding: [2,2,2,2], size: 8)
      row(0).style(align: :center, borders: [:bottom], border_width: 1, font_style: :bold)
    end
    move_down 10
  end

  def print_header_group(nromovil, chofer)
    group = [[ {content: "Móvil:", font_style: :bold},    nromovil,
               {content: " Chofer:", font_style: :bold},  chofer]]
    table group do
      self.header = false
      column(0..3).align = :left
      cells.style(borders: [], padding: [2,2,2,2], size: 8)
    end
    move_down 5    
  end
end