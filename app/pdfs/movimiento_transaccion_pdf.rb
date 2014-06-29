class MovimientoTransaccionPdf < Prawn::Document
  include PdfReport
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper 

  TABLE_HEADER = [["Cód. Trx.", "Transacción", "Crédito", "Débito"]]

  def initialize(movimiento_search, view)
    super({page_size: "A4", margin: [20, 20, 20, 20]})
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
    @movim_rel = Movimiento.
                    joins(:transaccion, :cuenta).
                    joins(%{INNER JOIN moviles ON moviles.id = cuentas.movil_id 
                            INNER JOIN choferes ON choferes.id = cuentas.chofer_id}).
                    select(%{ SUM(CASE WHEN transacciones.es_debito = #{t} THEN 0 ELSE movimientos.importe END) AS creditos,
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
                              false)
    mov_detalle = @movim_rel.
                    select(%{ cuentas.id AS nrocuenta,
                              moviles.nromovil,
                              choferes.id AS id_chofer,
                              choferes.nombre AS nombre_chofer,
                              transacciones.id AS id_transaccion,
                              transacciones.descripcion AS descripcion_transaccion }).
                    group( %{ cuentas.id,
                              moviles.nromovil,
                              choferes.id,
                              choferes.nombre,
                              transacciones.id,
                              transacciones.descripcion }).
                    order(%{  moviles.nromovil ASC,
                              choferes.nombre ASC,
                              transacciones.id })
    if mov_detalle.empty?
      text "- No se han encontrado movimientos para su consulta -", align: :center
    else
      data = []
      nromovil = chofer_id = 0
      chofer = ""
      nrocuenta = 0
      mov_detalle.each do |m|
        data += detail_row(m)
        # if nromovil != m.nromovil || chofer_id != m.id_chofer
        if nrocuenta != m.nrocuenta
          # if nromovil > 0 and chofer_id > 0
          if nrocuenta > 0            
            print_details(data[0..data.size-2], nromovil, chofer_id)
            data = detail_row(m)
          end
          print_header_group(m.nrocuenta, m.nromovil, m.nombre_chofer)
          nromovil  = m.nromovil
          chofer_id = m.id_chofer
          chofer    = m.nombre_chofer
          nrocuenta = m.nrocuenta
        end
      end
      print_details(data, nromovil, chofer_id)
      print_total_gral
    end
  end

  def detail_row(movimiento)
    cred = number_to_currency(movimiento.creditos)
    deb = number_to_currency(movimiento.debitos)
    transaccion = movimiento.descripcion_transaccion
    [[movimiento.id_transaccion, transaccion, cred, deb]]
  end

  def print_details(data, nromovil, chofer_id)
    totales = @movim_rel.where(%{ moviles.nromovil = ? AND choferes.id = ?}, nromovil, chofer_id).first
    tot_cred = number_to_currency(totales.creditos)
    tot_deb = number_to_currency(totales.debitos)
    data += [["TOTAL", "", tot_cred, tot_deb]]
    data = TABLE_HEADER + data
    table data do
      self.header = true
      self.column_widths = [40, 195, 60, 60]
      self.position = :center
      column(0).align = :center
      column(2..3).align = :right
      cells.style(borders: [], padding: [2,2,2,2], size: 8)
      row(0).style(align: :center, borders: [:bottom], border_width: 1, font_style: :bold)
      row(data.size-2).style(borders: [:bottom], border_width: 0.5)
    end
    move_down 10
  end

  def print_header_group(nrocuenta, nromovil, chofer)
    group = [[ {content: "Cuenta:", font_style: :bold},   format_cuenta(nrocuenta),
               {content: "Móvil:", font_style: :bold},    nromovil,
               {content: " Chofer:", font_style: :bold},  chofer]]
    table group do
      self.header = false
      column(0..3).align = :left
      cells.style(borders: [], padding: [2,2,2,2], size: 8)
    end
    move_down 5
  end

  def print_total_gral
    totales = @movim_rel.first
    tot_cred = number_to_currency(totales.creditos)
    tot_deb = number_to_currency(totales.debitos)
    saldo = number_to_currency(totales.creditos.to_f - totales.debitos.to_f)
    move_down 30
    data = [["TOTAL GENERAL", ""], 
            ["Créditos: ", tot_cred],
            ["Débitos: ", tot_deb],
            ["Saldo a pagar: ", saldo]]
    table data do
      self.header = false
      self.column_widths = [80, 60]
      self.position = :center
      cells.style(borders: [], padding: [2,2,2,2], size: 8)
      column(0).style(align: :left, font_style: :bold)
      row(0).style(borders: [:bottom], border_width: 1)
    end
  end
end