$(function(){

    $('table.tablesorter').tablesorter({
      theme: 'default',
      sortList: [[0,0]],
      widthFixed: true,
      widgets: ["filter"], 
      headers: {0: { filter: false }, 3: { filter: false }, 4: { filter: false }, 5: { filter: false, sorter: false }},
      widgetOptions : { 
        filter_reset : 'button.reset-filter',
        filter_cssFilter : 'tablesorter-filter', 
        filter_functions : {
          2 : true
        }
      } 
    });


    function calcProgressRate() {
        var webApiEndPoint
        var totalVnodes
        var shortVnodes
        var barVal

        webApiEndPoint = "http://192.168.223.2:3000/api/get_parameter"

        $.ajax({
          url: webApiEndPoint,
          type: 'GET',
          dataType: 'json',
          cache: false,
        }).done(function(data){
          //console.log(data["routing"]["short_vnodes"]);
          totalVnodes = data["routing"]["vnodes.length"];
          shortVnodes = data["routing"]["short_vnodes"];
          
          barVal = ((totalVnodes - shortVnodes)/totalVnodes)*100;
          barVal = Math.round(barVal * 10) / 10

          $('#extra-progress-bar').css("width",barVal + "%");
          $('#extra-bar-rate').text(barVal+ "% Complete");
          $('#short_vnodes_cnt').text(shortVnodes);

          //if (barVal >= 100.1){
          //  break;
          //}

        }).fail(function(){
          alert("fail to access Gladiator Web API");
        });


        //console.log(barVal);
        setTimeout(calcProgressRate,1000);
    }
 
    if(document.getElementById('extra-process')){
        setTimeout(calcProgressRate,100);
    }

});
