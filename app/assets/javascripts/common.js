$(function(){

    $("[data-toggle=tooltip_navbar]").tooltip({
      placement: 'bottom',
      delay: { show: 200, hide: 50 },
    });

    // for past version
    $('#log-link').click(function(e){
        e.preventDefault();
    });

});
