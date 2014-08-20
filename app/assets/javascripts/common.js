$(function(){

    $("[data-toggle=tooltip_navbar]").tooltip({
      placement: 'bottom',
      delay: { show: 200, hide: 50 },
    });

    // support past version
    $('#logLink').click(function(e){
        e.preventDefault();
    });

});
