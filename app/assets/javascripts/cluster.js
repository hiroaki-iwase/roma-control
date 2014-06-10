$(function(){

    $('table.tablesorter').tablesorter({
      theme: 'default',
      sortList: [[0,0]],
      widthFixed: true,
      widgets: ["filter"], 
      headers: {0: { filter: false }, 3: { filter: false }, 4: { filter: false }, 5: { filter: false },  6: { filter: false, sorter: false }, 7: { filter: false }},
      widgetOptions : { 
        filter_reset : 'button.reset-filter',
        filter_cssFilter : 'tablesorter-filter', 
        filter_functions : {
          2 : true
        }
      } 
    });

//    function calcProgressRate() {
//        var webApiEndPoint
//        var totalVnodes
//        var shortVnodes
//        var progressRate
//        var host
//        var protocol
//
//        protocol = location.protocol;
//        host = location.host;
//        webApiEndPoint = protocol+"//"+host+"/api/get_parameter"
//
//        $.ajax({
//            url: webApiEndPoint,
//            type: 'GET',
//            dataType: 'json',
//            cache: false,
//        }).done(function(data){
//            totalVnodes = data["routing"]["vnodes.length"];
//            shortVnodes = data["routing"]["short_vnodes"];
//            
//            progressRate = Math.round(((totalVnodes - shortVnodes)/totalVnodes)*1000) / 10
//
//            $('#extra-progress-bar').css("width",progressRate + "%");
//            $('#extra-bar-rate').text(progressRate+ "% Complete");
//            $('#short-vnodes-cnt').text(shortVnodes);
//
//            if (progressRate == 100) {
//                $('#extra-bar-rate').text("Finished!");
//                //console.log("Progress bar operation END");
//
//                function redirectClusterPage(){
//                  window.location.assign(protocol+"//"+host+"/cluster/index");
//                }
//                setTimeout(redirectClusterPage, 3000);
//
//            }else{
//                //console.log("loop again");
//                setTimeout(calcProgressRate,1000);
//            }
//        }).fail(function(){
//          alert("fail to access Gladiator Web API");
//        });
//    } //End of calcProgressRate()
// 
//    if(document.getElementById('extra-process')) {
//        setTimeout(calcProgressRate,100);
//    }



    function calcProgressRate2() {
        var webApiEndPoint
        var totalVnodes
        var rd
        var primaryVnodes
        var secondaryVnodes
        var progressRate
        var host
        var protocol
        var target_host
        var target_port

        protocol = location.protocol;
        host = location.host;
        target_host = "192.168.223.2";
        target_port = "10002";
        webApiEndPoint = protocol+"//"+host+"/api/get_parameter/"+target_host+"/"+target_port

        $.ajax({
            url: webApiEndPoint,
            type: 'GET',
            dataType: 'json',
            cache: false,
        }).done(function(data){
            totalVnodes     = parseInt(data["routing"]["vnodes.length"]);
            rd              = parseInt(data["routing"]["redundant"]);
            primaryVnodes   = parseInt(data["routing"]["primary"]);
            secondaryVnodes = parseInt(data["routing"]["secondary"]);
            
            progressRate = Math.round((1-((primaryVnodes + secondaryVnodes)/(totalVnodes * rd))) * 1000) /10
  
            $('#extra-progress-bar').css("width",progressRate + "%");
            $('#extra-bar-rate').text(progressRate+ "% Complete");
            //$('#short-vnodes-cnt').text(shortVnodes);

            if (progressRate == 100) {
                $('#extra-bar-rate').text("Finished!");
                //console.log("Progress bar operation END");

                function redirectClusterPage(){
                  window.location.assign(protocol+"//"+host+"/cluster/index");
                }
                setTimeout(redirectClusterPage, 3000);
            }else{
                //console.log("loop again");
                setTimeout(calcProgressRate2,1000);
            }

        }).fail(function(){
          alert("fail to access Gladiator Web API");
        });
    } //End of calcProgressRate()
 
    if(document.getElementById('extra-process-release')) {
        setTimeout(calcProgressRate2,100);
    }


});
