$(function(){

    //Modal
    $('#rbalseModal').on('show.bs.modal', function (e) {
      $("#rbalse-hidden-value").attr("value", e.relatedTarget.name);
    })
    
    $('#releaseModal').on('show.bs.modal', function (e) {
      $("#release-hidden-value").attr("value", e.relatedTarget.name);
    })

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

    // Progress Bar(Recover)
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
        var instanceName
        var primaryVnodes
        var secondaryVnodes
        var progressRate
        var host
        var protocol

        protocol = location.protocol;
        host = location.host;
        webApiEndPoint = protocol+"//"+host+"/api/get_routing_info"

        $.ajax({
            url: webApiEndPoint,
            type: 'GET',
            dataType: 'json',
            cache: false,
        }).done(function(data){

            for(i in data){

                instanceName = i;
                primaryVnodes   = parseInt(data[i]["primary_nodes"]);
                secondaryVnodes = parseInt(data[i]["secondary_nodes"]);        

                //set nodes count
                instance = instanceName.match(/\d/g).join("");
                $('#primary-nodes-'+instance).text(primaryVnodes);
                $('#secondary-nodes-'+instance).text(secondaryVnodes);

                //progress bar setting
                if (i == gon.host+"_"+gon.port) {
                    if (typeof denominator === "undefined") {
                      denominator = primaryVnodes + secondaryVnodes;
                    }
                    progressRate = Math.round((1-((primaryVnodes + secondaryVnodes)/denominator)) * 1000) /10
                    $('#extra-progress-bar').css("width",progressRate + "%");
                    $('#extra-bar-rate').text(progressRate+ "% Complete");

                    //Finish Release
                    if (progressRate == 100) {
                        $('#extra-bar-rate').text("Finished!");
                        function redirectClusterPage(){
                            window.location.assign(protocol+"//"+host+"/cluster/index");
                        }
                        setTimeout(redirectClusterPage, 3000);
                    }else{
                        setTimeout(calcProgressRate2, 1000, denominator);
                    }
               }
            }

        }).fail(function(){
          alert("fail to access Gladiator Web API");
        });
    } //End of calcProgressRate2()
 
    if(document.getElementById('extra-process-release')) {
        setTimeout(calcProgressRate2,100);
    }


});
