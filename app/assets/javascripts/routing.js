$(function(){

    //initialize of gon
    if (typeof gon === "undefined") {
      gon = false
    }

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
    });

});
