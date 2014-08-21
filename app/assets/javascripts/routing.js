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

    //Table Sorter
    $('table.routing-table')
    .tablesorter({
        theme: 'default',
        widthFixed: true,
        sortList: [[0,0]],
        widgets : [ "uitheme", "filter"],
    })
    .tablesorterPager({
        container: $("#pager"),
        positionFixed: false
    }); 

});
