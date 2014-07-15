$(function(){

    //Modal
    $('.close-modal').click(function () {
      $('#download-modal').modal('hide');
    })

    //Format Error Popup
    if (gon.format_error) {
      alert("Unexpected format type was sent");
    }

    //Table sorter
    $('table.routing-table').tablesorter({
        theme: 'default',
        sortList: [[0,0]],
        widthFixed: true,
        widgets: ["filter"], 
        headers: {0: { filter: false }, 3: { filter: false }, 4: { filter: false }, 5: { filter: false },  6: { filter: false, sorter: false }, 7: { filter: false }},
        widgetOptions : { 
          filter_reset : 'button.reset-filter',
          filter_cssFilter : 'tablesorter-filter', 
          filter_functions : {
            2 : true
          }
        } 
    });

});
