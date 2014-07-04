$(function(){

    //Modal
    $('.close-modal').click(function () {
      $('#downloadModal').modal('hide');
    })

    //Format Error Popup
    if (gon.format_error) {
      alert("Unexpected format type was sent");
    }

});
