PDFKit.configure do |config|
  config.default_options = {
    :page_size => 'letter',
    :margin_top => '0.3in',
    :margin_right => '0.3in',
    :margin_bottom => '0.3in',
    :margin_left => '0.3in',
    :encoding => 'utf-8',
    :header_right => "FECHA DE CREACION: [date] [time]     ",
    :footer_right => "PAGINA [page] DE [toPage]     "
  }
end
