$(function(){


$("#button-showmodal").click(function(){
    $("#testModal").modal();
    var target = document.getElementById('button-showmodal').title;
    //$("#send-command").attr("action","indexx");
    //$("#hidden-value").attr("value","192.168.223.2_10002");

});




$('#releaseModal').on('show.bs.modal', function (e) {
  //alert("aaa");
  //alert(e.relatedTarget);
  //alert(e.relatedTarget.type);
  alert(e.relatedTarget.name);
  // do something...
})





$("#rbalse-button").click(function(){
alert("aaa");
//    $("#rbalseModal").modal();
//    var target = document.getElementById('rbalse-button').title;
//    //$("#send-command").attr("action","indexx");
//    $("#rbalse-hidden-value").attr("value",target);
});



    //Table sorter
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

    // Progress Bar(Recover )
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
            $('#short-vnodes-cnt').text(shortVnodes);

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



    // Progress Bar(Release)
    function calcProgressRate2() {
        var webApiEndPoint
        var primaryVnodes
        var secondaryVnodes
        var progressRate
        var host
        var protocol
        var target_host
        var target_port

        protocol = location.protocol;
        host = location.host;
        webApiEndPoint = protocol+"//"+host+"/api/get_parameter/"+gon.host+"/"+gon.port

        $.ajax({
            url: webApiEndPoint,
            type: 'GET',
            dataType: 'json',
            cache: false,
        }).done(function(data){
            primaryVnodes   = parseInt(data["routing"]["primary"]);
            secondaryVnodes = parseInt(data["routing"]["secondary"]);
            if (typeof denominator === "undefined") {
              denominator = primaryVnodes + secondaryVnodes;
            }
            
            progressRate = Math.round((1-((primaryVnodes + secondaryVnodes)/denominator)) * 1000) /10
            console.log("denominator is"+denominator);

            //set parogress bar setting  
            $('#extra-progress-bar').css("width",progressRate + "%");
            $('#extra-bar-rate').text(progressRate+ "% Complete");



            //set nodes count
            $('#primary-nodes-cnt').text(primaryVnodes);
            $('#secondary-nodes-cnt').text(secondaryVnodes);

            if (progressRate == 100) {
                $('#extra-bar-rate').text("Finished!");
                //console.log("Progress bar operation END");

                function redirectClusterPage(){
                  window.location.assign(protocol+"//"+host+"/cluster/index");
                }
                setTimeout(redirectClusterPage, 3000);
            }else{
                setTimeout(calcProgressRate2, 1000, denominator);
            }

        }).fail(function(){
          alert("fail to access Gladiator Web API");
        });
    } //End of calcProgressRate2()
 
    if(document.getElementById('extra-process-release')) {
        setTimeout(calcProgressRate2,100);
    }


});
