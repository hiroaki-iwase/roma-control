$(function() {

    if (gon) {
        //Tabs
        jQuery.each(gon.routing_list, function() {
          $("#"+this+"-tabs").click(function(){
            $("#tabs li").removeClass("active");
            $(this).parent().addClass("active");
            $("#tabs .panel").hide();
            $(this.hash).fadeIn();
            return false;
          });
        });
        $("#"+gon.routing_list[0]+"-tabs:eq(0)").trigger('click');
  
        //Table sorter
        $('table.log-table').tablesorter({
            theme: 'default',
            sortList: [[0,0]],
            widthFixed: true,
            widgets: ["filter"], 
            headers: {0: { filter: false }},
            widgetOptions : { 
              filter_reset : 'button.reset-filter',
              filter_cssFilter : 'tablesorter-filter', 
              filter_functions : {
                1 : true
              }
            } 
        });
    }

    $("#logs-button").click(function() {
        $("#logs-button").html("<img alt='Ajax loader' src='/assets/ajax-loader.gif'> gathering log data");
        $("#logs-button").css({"background-color":"#222222", "border-color":"#222222"});
        $("#logs-button").attr('disabled', true);
    });

})
