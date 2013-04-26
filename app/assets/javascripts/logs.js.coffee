jQuery ->
  Morris.Line
    element: 'months_chart'
    data: $('#months_chart').data('months')
    xkey: 'created_at'
    ykeys: ['top_page', 'pdf01', 'pdf02', 'pdf03', 'pdf04', 'pdf05', 'pdf06'],
    labels: ['Top page hit', 'Pdf01 download', 'Pdf02 download', 'Pdf03 download', 'Pdf04 download', 'Pdf05 download', 'Pdf06 download']
