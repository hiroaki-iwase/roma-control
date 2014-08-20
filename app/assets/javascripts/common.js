$(function(){

    $("[data-toggle=tooltip_navbar]").tooltip({
      placement: 'bottom',
      delay: { show: 200, hide: 50 },
    });

    // support past version
    $("#overlayLog").fadeIn('fast');
    $(".restriction-panel").fadeIn('fast');
    $('#logLink').click(function(e){
        e.preventDefault();
    });

});
