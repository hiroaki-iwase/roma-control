$(function(){

    //Debug
    //$('#primary-nodes-192168223210002').innerHTML('<span id="short-vnodes-caution"><i class="icon-warning-sign"></i></span>');
    //aaa = "999999"
    //document.getElementById('primary-nodes-192168223210002').innerHTML =
    //    '<span id="short-vnodes-caution">\
    //     <i class="icon-warning-sign"></i>\
    //     '+aaa+'\
    //     </span>';

    //Modal
    $('#rbalse-modal').on('show.bs.modal', function (e) {
      $("#rbalse-hidden-value").attr("value", e.relatedTarget.name);
    })

    $('#rbalse-modal-after-release').on('show.bs.modal', function (e) {
      $("#rbalse-hidden-value-after-release").attr("value", gon.host+"_"+gon.port);
    })

    $('#release-modal').on('show.bs.modal', function (e) {
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
    function calcRecoverProgressRate() {
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
                setTimeout(calcRecoverProgressRate,1000);
            }
        }).fail(function(){
          alert("fail to access Gladiator Web API");
        });
    } //End of calcRecoverProgressRate()
 
    if(document.getElementById('extra-process')) {
        setTimeout(calcRecoverProgressRate,100);
    }

    // Progress Bar(Release)
    function calcReleaseProgressRate() {
        var webApiEndPoint
        var instanceName
        var primaryVnodes
        var secondaryVnodes
        var repetitionHost
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

            for(instanceName in data){

                primaryVnodes   = parseInt(data[instanceName]["primary_nodes"]);
                secondaryVnodes = parseInt(data[instanceName]["secondary_nodes"]);
             
                if (receptiveNodes(instanceName, data)) {

                    //set nodes count
                    instance = instanceName.match(/\d/g).join("");
                    if (instanceName == gon.host+"_"+gon.port) {
                      color = "red"
                      icon  = 'arrow-down'
                    }else{
                      color = "blue"
                      icon  = 'arrow-up'
                    }
                    document.getElementById('primary-nodes-'+instance).style.color = color;
                    document.getElementById('primary-nodes-'+instance).innerHTML = 
                        primaryVnodes+'<span><i class="icon-'+icon+'"></i></span>';

                    document.getElementById('secondary-nodes-'+instance).style.color = color;
                    document.getElementById('secondary-nodes-'+instance).innerHTML = 
                        secondaryVnodes+'<span><i class="icon-'+icon+'"></i></span>';

                    //progress bar setting
                    if (instanceName == gon.host+"_"+gon.port) {
                        if (typeof denominator === "undefined") {
                          denominator = primaryVnodes + secondaryVnodes;
                        }
                        progressRate = Math.round((1-((primaryVnodes + secondaryVnodes)/denominator)) * 1000) /10
                        $('#extra-progress-bar').css("width",progressRate + "%");
                        $('#extra-bar-rate').text(progressRate+ "% Complete");

                        checkFinish(progressRate, denominator);
                    }
                }
            }

        }).fail(function(){
          alert("fail to access Gladiator Web API");
        });
    } //End of calcReleaseProgressRate()

    function receptiveNodes(instanceName, data) {
        repetitionHost = data[instanceName]["enabled_repetition_host_in_routing"];
        if (!repetitionHost && instanceName.split("_")[0] != gon.host) {
            return false
        }
        return true
    }

    function checkFinish(progressRate, denominator) {
        if (progressRate == 100) {
            $('#extra-bar-rate').text("Finished!");
            function confirmRbalse(){
              $('#rbalse-modal-after-release').modal('show')
            }
            setTimeout(confirmRbalse, 1000);
        }else{
            setTimeout(calcReleaseProgressRate, 1000, denominator);
        }
    }

    if(document.getElementById('extra-process-release')) {
        setTimeout(calcReleaseProgressRate,100);
    }

});
