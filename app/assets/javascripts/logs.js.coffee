jQuery ->
  Morris.Bar
    element: 'total_chart'
    data: $('#total_chart').data('months')
    xkey: 'created_at'
    ykeys: ['top_page', 'pdf'],
    labels: ['Unique top page hit', 'Unique total pdf download'],

  Morris.Line
    element: 'pdf_chart'
    data: $('#pdf_chart').data('months')
    xkey: 'created_at'
    ykeys: $('#pdf_chart').data('pdfs'),
    labels: $('#pdf_chart').data('pdfs'),
