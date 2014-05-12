class MovimientoSearchPdf < Prawn::Document
  include PdfReport
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper 

  TABLE_HEADER = [["Fec. real", "Fec. Mov.", "Cód. Trx.", "Transacción", "Crédito", "Débito", "Saldo"]]

  def initialize(movimiento_search, view)
    super({size: "A4"})
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
    movimientos = Movimiento.
                    joins(:transaccion, :chofer, :movil).
                    select(%{ movimientos.id AS movimiento_id, 
                              movimientos.updated_at, 
                              movimientos.fecha_movimiento, 
                              movimientos.observacion,
                              movimientos.importe, 
                              transacciones.id AS id_transaccion,
                              transacciones.descripcion AS descripcion_transaccion,
                              transacciones.es_debito AS es_debito,
                              choferes.nombre AS nombre_chofer,
                              moviles.nromovil }).
                    where(%{  movimientos.fecha_movimiento >= ? AND
                              movimientos.fecha_movimiento <= ? AND
                              moviles.nromovil >= ?             AND
                              moviles.nromovil <= ? },
                              movimiento_search.fecha_desde, 
                              movimiento_search.fecha_hasta, 
                              movimiento_search.nromovil_desde, 
                              movimiento_search.nromovil_hasta).
                    order(%{  moviles.nromovil ASC,
                              movimientos.fecha_movimiento ASC, 
                              movimientos.updated_at ASC })
    if movimientos.empty?
      text "- No se han encontrado movimientos para su consulta -", align: :center
    else
      data = []
      nromovil = credito = debito = saldo = 0
      chofer = ""
      movimientos.each do |m|
        if m.es_debito.to_bool
          credito = 0
          debito = m.importe
          saldo = saldo - m.importe
        else
          credito = m.importe
          debito = 0
          saldo = saldo + m.importe
        end
        transaccion = m.descripcion_transaccion
        if not m.observacion.empty?
          transaccion += " - " + m.observacion
        end
        data += [[m.updated_at.strftime('%d/%m/%Y %T'),
                  m.fecha_movimiento.strftime('%d/%m/%Y'),
                  m.id_transaccion,
                  transaccion,
                  number_to_currency(credito),
                  number_to_currency(debito),
                  number_to_currency(saldo)]]
        if nromovil != m.nromovil || chofer != m.nombre_chofer
          print_details(nromovil, chofer, data) if nromovil > 0 and not chofer.empty?
          nromovil = m.nromovil
          chofer = m.nombre_chofer
          saldo = 0
          data = []
        end
      end
      m = movimientos.last
      print_details(m.nromovil, m.nombre_chofer, data)
      # table data, header: true, cell_style: {borders: [], padding: [2,5,2,5]}
    end
  end

  def print_details(nromovil, chofer, data)
    group = [[ {content: "Móvil:", font_style: :bold},    nromovil,
               {content: " Chofer:", font_style: :bold},  chofer]]
    table group do
      self.header = false
      column(0..3).align = :left
      cells.style(borders: [], padding: [2,2,2,2], size: 8)
    end
    move_down 5

    data = TABLE_HEADER + data
    table data do
      self.header = true
      self.column_widths = [80, 45, 40, 195, 60, 60, 60]
      self.position = :center
      column(0..1).align = :center
      column(2).align = :right
      column(4..6).align = :right
      cells.style(borders: [], padding: [2,2,2,2], size: 8)
      row(0).style(align: :center, borders: [:bottom], border_width: 1, font_style: :bold)
    end

    move_down 10
  end
end