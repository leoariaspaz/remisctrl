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
                    joins(:transaccion, :cuenta).
                    joins(%{INNER JOIN moviles ON moviles.id = cuentas.movil_id 
                            INNER JOIN choferes ON choferes.id = cuentas.chofer_id}).                    
                    select(%{ movimientos.id AS movimiento_id, 
                              movimientos.updated_at, 
                              movimientos.fecha_movimiento, 
                              movimientos.observacion,
                              movimientos.importe, 
                              movimientos.es_contrasiento,
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
    if not movimiento_search.mostrar_contrasientos
      movimientos = movimientos.where(['movimientos.es_contrasiento = ?', false])
    end
    if movimientos.empty?
      text "- No se han encontrado movimientos para su consulta -", align: :center
    else
      data = []
      nromovil = @credito = @debito = @saldo = 0
      chofer = ""
      movimientos.each do |m|
        data += build_row(m)
        if nromovil != m.nromovil || chofer != m.nombre_chofer
          if nromovil > 0 and not chofer.empty?
            # data.delete_at(data.size-1)
            print_details(data[0..data.size-2])
            @saldo = 0
            data = build_row(m)
          end
          print_header_group(m.nromovil, m.nombre_chofer)
          nromovil = m.nromovil
          chofer = m.nombre_chofer
        end
      end
      print_details(data)
    end
  end

  def build_row(movimiento)
    if movimiento.es_debito.to_bool
      @credito = 0
      @debito = movimiento.importe
      @saldo = @saldo - movimiento.importe
    else
      @credito = movimiento.importe
      @debito = 0
      @saldo = @saldo + movimiento.importe
    end
    cred = number_to_currency(@credito)
    deb = number_to_currency(@debito)      
    if movimiento.es_contrasiento
      if movimiento.es_debito.to_bool
        @saldo = @saldo + @debito
        deb = {content: "(c) #{deb}", font_style: :italic}
      else
        @saldo = @saldo - @credito
        cred = {content: "(c) #{cred}", font_style: :italic}
      end
    end
    sdo = number_to_currency(@saldo)
    transaccion = movimiento.descripcion_transaccion
    transaccion += " - " + movimiento.observacion unless movimiento.observacion.empty?
    [[movimiento.updated_at.strftime('%d/%m/%Y %T'),
      movimiento.fecha_movimiento.strftime('%d/%m/%Y'),
      movimiento.id_transaccion,
      transaccion,
      cred, deb, sdo]]
  end

  def print_details(data)
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