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
        var progressRate
        var host
        var protocol

        protocol = location.protocol;
        host = location.host;
        webApiEndPoint = protocol+"//"+host+"/api/get_parameter"

        $.ajax({
            url: webApiEndPoint,
            type: 'GET',
            dataType: 'json',
            cache: false,
        }).done(function(data){
            totalVnodes = data["routing"]["vnodes.length"];
            shortVnodes = data["routing"]["short_vnodes"];
            
            progressRate = Math.round(((totalVnodes - shortVnodes)/totalVnodes)*1000) / 10

            $('#extra-progress-bar').css("width",progressRate + "%");
            $('#extra-bar-rate').text(progressRate+ "% Complete");
            $('#short_vnodes_cnt').text(shortVnodes);

            if (progressRate == 100) {
                $('#extra-bar-rate').text("Finished!");
                //console.log("Progress bar operation END");

                function redirectClusterPage(){
                  window.location.assign(protocol+"//"+host+"/cluster/index");
                }
                setTimeout(redirectClusterPage, 3000);

            }else{
                //console.log("loop again");
                setTimeout(calcProgressRate,1000);
            }
        }).fail(function(){
          alert("fail to access Gladiator Web API");
        });
    } //End of calcProgressRate()
 
    if(document.getElementById('extra-process')) {
        setTimeout(calcProgressRate,100);
    }

});
