$(function(){

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

    //start to check extra process(recover)
    if(document.getElementById('extra-process-recover')) {
        setTimeout(calcRecoverProgressRate,100);
    }

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
                setTimeout(redirectClusterPage(), 3000);
            }else{
                setTimeout(calcRecoverProgressRate,1000);
            }
        }).fail(function(){
          alert("fail to access Gladiator Web API");
        });
    } //End of calcRecoverProgressRate()
 

    //start to check extra process(release)
    if(document.getElementById('extra-process-release')) {
        setTimeout(calcReleaseProgressRate,100);
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
                if (data[instanceName]["status"] != "inactive") {

                    primaryVnodes   = parseInt(data[instanceName]["primary_nodes"]);
                    secondaryVnodes = parseInt(data[instanceName]["secondary_nodes"]);
                    startPrimaryVnodes   = gon.routing_info[instanceName]["primary_nodes"];
                    startSecondaryVnodes = gon.routing_info[instanceName]["secondary_nodes"];
             

                    //set vnodes count
                    //[toDO : use instance variables]
                    if (primaryVnodes < startPrimaryVnodes) {
                      color_primary = "red"
                      icon_primary  = 'arrow-down'
                    }else if (primaryVnodes > startPrimaryVnodes) {
                      color_primary = "blue"
                      icon_primary  = 'arrow-up'
                    }else{
                      color_primary = ""
                      icon_primary  = ''
                    }

                    if (secondaryVnodes < startPrimaryVnodes) {
                      color_secondary = "red"
                      icon_secondary  = 'arrow-down'
                    }else if (secondaryVnodes > startPrimaryVnodes) {
                      color_secondary = "blue"
                      icon_secondary  = 'arrow-up'
                    }else{
                      color_secondary = ""
                      icon_secondary  = ''
                    }

                    instance = instanceName.match(/\d/g).join("");
                    //for primary nodes
                    document.getElementById('primary-nodes-'+instance).style.color = color_primary;
                    document.getElementById('primary-nodes-'+instance).innerHTML = 
                        primaryVnodes+'<span><i class="icon-'+icon_primary+'"></i></span>';
                    //for secondary nodes
                    document.getElementById('secondary-nodes-'+instance).style.color = color_secondary;
                    document.getElementById('secondary-nodes-'+instance).innerHTML = 
                        secondaryVnodes+'<span><i class="icon-'+icon_secondary+'"></i></span>';

                    //progress bar setting
                    if (instanceName == gon.host+"_"+gon.port) {
                        progressRate = Math.round((1-((primaryVnodes + secondaryVnodes)/gon.denominator)) * 1000) /10
                        $('#extra-progress-bar').css("width",progressRate + "%");
                        $('#extra-bar-rate').text(progressRate+ "% Complete");

                        checkFinish(progressRate, "release");
                    }
                }
            }

        }).fail(function(){
          alert("fail to access Gladiator Web API");
        });
    } //End of calcReleaseProgressRate()





    //start to check extra process(join)
    if(document.getElementById('extra-process-join')) {
        setTimeout(calcJoinProgressRate,100);
    }

    // Progress Bar(Join)
    function calcJoinProgressRate() {
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
                if (data[instanceName]["status"] != "inactive") {

                    primaryVnodes   = parseInt(data[instanceName]["primary_nodes"]);
                    secondaryVnodes = parseInt(data[instanceName]["secondary_nodes"]);
                    startPrimaryVnodes   = gon.routing_info[instanceName]["primary_nodes"];
                    startSecondaryVnodes = gon.routing_info[instanceName]["secondary_nodes"];
             
                    //set vnodes count
                    //[toDO : use instance variables]
                    if (primaryVnodes < startPrimaryVnodes) {
                      color_primary = "red"
                      icon_primary  = 'arrow-down'
                    }else if (primaryVnodes > startPrimaryVnodes) {
                      color_primary = "blue"
                      icon_primary  = 'arrow-up'
                    }else{
                      color_primary = ""
                      icon_primary  = ''
                    }

                    if (secondaryVnodes < startSecondaryVnodes) {
                      color_secondary = "red"
                      icon_secondary  = 'arrow-down'
                    }else if (secondaryVnodes > startSecondaryVnodes) {
                      color_secondary = "blue"
                      icon_secondary  = 'arrow-up'
                    }else{
                      color_secondary = ""
                      icon_secondary  = ''
                    }


                    instance = instanceName.match(/\d/g).join("");
                    //for primary nodes
                    document.getElementById('primary-nodes-'+instance).style.color = color_primary;
                    document.getElementById('primary-nodes-'+instance).innerHTML = 
                        primaryVnodes+'<span><i class="icon-'+icon_primary+'"></i></span>';
                    //for secondary nodes
                    document.getElementById('secondary-nodes-'+instance).style.color = color_secondary;
                    document.getElementById('secondary-nodes-'+instance).innerHTML = 
                        secondaryVnodes+'<span><i class="icon-'+icon_secondary+'"></i></span>';
            

                    //progress bar setting
                    //[toDO] consider condition of join end
                    $('#extra-progress-bar').css("width",100 + "%");
                    $('#extra-bar-rate').text("Now executing");

                    if (instanceName == gon.host+"_"+gon.port) {
                        checkFinish(data[instanceName]["status"], "join");
                    }
                }
            }

        }).fail(function(){
          alert("fail to access Gladiator Web API");
        });
    } //End of calcJoinProgressRate()


    function receptiveNodes(instanceName, data) {
        repetitionHost = data[instanceName]["enabled_repetition_host_in_routing"];
        if (!repetitionHost && instanceName.split("_")[0] != gon.host) {
            return false
        }
        return true
    }

    function checkFinish(condition, process) {
        switch (process) {
            case "release":
                if (condition == 100) {
                    $('#extra-bar-rate').text("Finished!");
                    setTimeout(confirmRbalse, 1000);
                }else{
                    setTimeout(calcReleaseProgressRate, 1000);
                }
                break;
            case "join":
                if (condition != "join") {
                    setTimeout(redirectClusterPage(), 3000);
                }else{
                    setTimeout(calcJoinProgressRate, 1000);
                }
                break;
        }
    }

    function redirectClusterPage(protocol, host){
        if(typeof protocol === 'undefined') protocol = location.protocol;
        if(typeof host === 'undefined') host = location.host;
        window.location.assign(protocol+"//"+host+"/cluster/index");
    }

    function confirmRbalse(){
        $('#rbalse-modal-after-release').modal('show')
    }

});
