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
        $(this).html("<img alt='Ajax loader' src='/assets/ajax-loader.gif' ></img> gathering log data");
        $(this).css({"background-color":"#222222"});
        $(this).attr('disabled', true);
    });



    //    protocol = location.protocol;
    //    host = location.host;
    //    webApiEndPoint = protocol+"//"+host+"/api/get_all_logs"

    //    $.ajax({
    //        url: webApiEndPoint,
    //        type: 'GET',
    //        dataType: 'json',
    //        timeout:10000,
    //        cache: false,
    //    }).done(function(data){
    //        $('#logs-button').attr('disabled', false);
    //        $('#logs-button').text("Update Log");
    //        $('#logs-button').css({"background-color":"orange"});

    //        $('.test').text(typeof data['192.168.223.2_10001']);

    //        console.log(data);
    //    }).fail(function(){
    //        $('#logs-button').text("Retry");
    //        $('#logs-button').css({"background-color":"red"});
    //        alert("fail to access Gladiator Web API");
    //    });

})
