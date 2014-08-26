$(function() {
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



    //$("#logs-button").click(function() {
    //    $(this).html("<img alt='Ajax loader' src='/assets/ajax-loader.gif' ></img> gathering log data");
    //    $(this).css({"background-color":"#222222"});
    //    $(this).attr('disabled', true);

    //    $.ajax({
    //      url: 'http://localhost:8080/AplExample/family',
    //      type:'GET',
    //      dataType: 'jsonp',
    //      timeout:10000,
    //      success: function(data) {

    //      },
    //      error: function(data) {
    //          alert("ng");
    //      },
    //      complete : function(data) {
    //          $("#loading").empty();
    //          $("#loading").html("<p>通信終了</p>");
    //      }
    //});

})
