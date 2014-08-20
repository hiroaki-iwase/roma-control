$(function(){

    $("#overlayLog").fadeIn('fast');
    $('#logLink').click(function(e){
        e.preventDefault();
    });

    $("[data-toggle=tooltip_navbar]").tooltip({
      placement: 'bottom',
      delay: { show: 200, hide: 50 },
    });

});
