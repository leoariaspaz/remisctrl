class MovimientoSearchUtilidadPdf < Prawn::Document
  include PdfReport
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper 

  TABLE_HEADER = [["Móvil", "Chofer", "Ingresos", "Egresos", "Utilidad", "Utilidad(%)"]]

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
                    select(%{ choferes.nombre AS nombre_chofer,
                              moviles.nromovil,
                              SUM(CASE WHEN transacciones.es_debito = #{t} THEN 0 ELSE movimientos.importe END) AS ingresos,
                              SUM(CASE WHEN transacciones.es_debito = #{t} THEN movimientos.importe ELSE 0 END) AS egresos }).
                    where(%{  movimientos.fecha_movimiento >= ? AND
                              movimientos.fecha_movimiento <= ? AND
                              moviles.nromovil >= ?             AND
                              moviles.nromovil <= ? },
                              movimiento_search.fecha_desde, 
                              movimiento_search.fecha_hasta, 
                              movimiento_search.nromovil_desde, 
                              movimiento_search.nromovil_hasta).
                    group( %{ choferes.nombre,
                              moviles.nromovil }).
                    order(%{  moviles.nromovil ASC })
    if not movimiento_search.mostrar_contrasientos.to_bool
      movimientos = movimientos.where(['movimientos.es_contrasiento = ?', false])
    end
    if movimientos.empty?
      text "- No se han encontrado movimientos para su consulta -", align: :center
    else
      data = []
      movimientos.each {|m| data += detail_row(m) }
      print_details(data)
    end
  end

  def detail_row(movimiento)
    [[movimiento.nromovil, 
      movimiento.nombre_chofer, 
      number_to_currency(movimiento.ingresos), 
      number_to_currency(movimiento.egresos),
      number_to_currency(movimiento.ingresos - movimiento.egresos),
      number_to_percentage(((movimiento.ingresos - movimiento.egresos) / movimiento.ingresos) * 100)]]
  end

  def print_details(data)
    data = TABLE_HEADER + data
    table data do
      self.header = true
      self.column_widths = [50, 100, 70, 70, 70, 50]
      self.position = :center
      column(0).align = :center
      column(1).align = :left
      column(2..5).align = :right
      cells.style(borders: [], padding: [2,2,2,2], size: 8)
      row(0).style(align: :center, borders: [:bottom], border_width: 1, font_style: :bold)
    end
    move_down 10
  end
end