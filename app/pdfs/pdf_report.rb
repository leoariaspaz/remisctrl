# basado en 
# https://github.com/ryanb/railscasts-episodes/blob/master/episode-153/revised/store-after/app/pdfs/order_pdf.rb
module PdfReport
  include ActionView::Helpers::AssetUrlHelper

  def header(title, subtitle = nil)
    img_path = "#{Rails.root}/app/assets/images/taxi.png"
    time = I18n.l Time.now, format: "%d/%m/%Y %H:%M"
    data = [[
              [[{image: img_path, image_width: 32, borders: [], padding: 0, position: :center}],
              [{content: "Remis Ctrl", size: 7, borders: [], padding: 0, align: :center, font_style: :bold}]],
              {content: title, size: 24, align: :center},
              {content: time, size: 7, align: :center, font_style: :italic}
            ]]
    table data do
      self.header = false
      self.cell_style = {borders: []}
      columns(0).width = 40
      columns(1).width = 453
      columns(1).padding_top = 15
      columns(2).width = 47
    end
    if subtitle
      move_down 5
      text subtitle, size: 8, align: :left
    end
    stroke_horizontal_rule
    move_down 15
  end
  
  def footer(title)
    string = "Pág. <page> de <total>"
    options = { at: [bounds.right - 150, 6.5], width: 150, align: :right, size: 8 }
    number_pages string, options    
    repeat(lambda { |pg| pg > 1 }) do
      bounding_box [bounds.left, bounds.top], :width => bounds.width do
        text title, :align => :left, :size => 8
        stroke_horizontal_rule
      end
    end
    repeat :all do
      draw_text title, at: [0, 0], size: 8
      move_cursor_to 10
      stroke_horizontal_rule
    end
  end

  # imprime datos en forma de tabla, sin bordes
  def print_record(data)
    table data, header: false, cell_style: {borders: [], padding: [2,5,2,5]}
  end
end
