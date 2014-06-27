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
        //calcRecoverProgressRate();
        calcProgressRate('recover');
    }

    // Progress Bar(Recover)
    //function calcRecoverProgressRate() {
    //    var webApiEndPoint
    //    var instanceName
    //    var primaryVnodes
    //    var secondaryVnodes
    //    var shortVnodes
    //    var progressRate
    //    var host
    //    var protocol

    //    protocol = location.protocol;
    //    host = location.host;
    //    webApiEndPoint = protocol+"//"+host+"/api/get_routing_info"

    //    $.ajax({
    //        url: webApiEndPoint,
    //        type: 'GET',
    //        dataType: 'json',
    //        cache: false,
    //    }).done(function(data){

    //        for(instanceName in data){
    //            if (data[instanceName]["status"] != "inactive") {

    //                primaryVnodes   = parseInt(data[instanceName]["primary_nodes"]);
    //                secondaryVnodes = parseInt(data[instanceName]["secondary_nodes"]);
    //                startPrimaryVnodes   = gon.routing_info[instanceName]["primary_nodes"];
    //                startSecondaryVnodes = gon.routing_info[instanceName]["secondary_nodes"];
    //                shortVnodes = data[instanceName]["short_vnodes"];

    //                //set vnodes count
    //                //[toDO : use instance variables]
    //                if (primaryVnodes < startPrimaryVnodes) {
    //                    color_primary = "red"
    //                    icon_primary  = 'arrow-down'
    //                }else if (primaryVnodes > startPrimaryVnodes) {
    //                    color_primary = "blue"
    //                    icon_primary  = 'arrow-up'
    //                }else{
    //                    color_primary = ""
    //                    icon_primary  = ''
    //                }

    //                if (secondaryVnodes < startSecondaryVnodes) {
    //                    color_secondary = "red"
    //                    icon_secondary  = 'arrow-down'
    //                }else if (secondaryVnodes > startSecondaryVnodes) {
    //                    color_secondary = "blue"
    //                    icon_secondary  = 'arrow-up'
    //                }else{
    //                    color_secondary = ""
    //                    icon_secondary  = ''
    //                }

    //                instance = instanceName.match(/\d/g).join("");
    //                //for primary nodes
    //                $('#primary-nodes-'+instance).css("color", color_primary)
    //                $('#primary-nodes-'+instance).html(primaryVnodes+'<span><i class="icon-'+icon_primary+'"></i></span>')
    //                //for secondary nodes
    //                $('#secondary-nodes-'+instance).css("color", color_secondary)
    //                $('#secondary-nodes-'+instance).html(secondaryVnodes+'<span><i class="icon-'+icon_secondary+'"></i></span>')

    //                if (instanceName == gon.host+"_"+gon.port) {
    //                    //short vnodes count
    //                    $('#short-vnodes-cnt').text(shortVnodes);

    //                    //progressBarSet(data[instanceName], process);
    //                    progressBarSet(data[instanceName], 'recover');

    //                    //checkFinish(data[instanceName], process);
    //                    checkFinish(data[instanceName], 'recover');
    //                }
    //            }
    //        }
    //    }).fail(function(){
    //      alert("fail to access Gladiator Web API");
    //    });
    //} //End of calcRecoverProgressRate()
 

    //start to check extra process(release)
    if(document.getElementById('extra-process-release')) {
        calcProgressRate('release');
    }

    //start to check extra process(join)
    if(document.getElementById('extra-process-join')) {
        calcProgressRate('join');
    }

    function calcProgressRate(process) {
        var webApiEndPoint
        var instanceName
        var primaryVnodes
        var secondaryVnodes
        var shortVnodes
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
                    shortVnodes = data[instanceName]["short_vnodes"]; //[toDO] checnge to location

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
                    $('#primary-nodes-'+instance).css("color", color_primary)
                    $('#primary-nodes-'+instance).html(primaryVnodes+'<span><i class="icon-'+icon_primary+'"></i></span>')
                    //for secondary nodes
                    $('#secondary-nodes-'+instance).css("color", color_secondary)
                    $('#secondary-nodes-'+instance).html(secondaryVnodes+'<span><i class="icon-'+icon_secondary+'"></i></span>')

                    if (instanceName == gon.host+"_"+gon.port) {
                        //short vnodes count
                        $('#short-vnodes-cnt').text(shortVnodes);

                        progressBarSet(data[instanceName], process);
                        checkFinish(data[instanceName], process);
                    }
                }
            }

        }).fail(function(){
          alert("fail to access Gladiator Web API");
        });
    } //End of calcProgressRate(process)

    function progressBarSet(data, process) {
        switch (process) {
            case "release":
                primaryVnodes   = parseInt(data["primary_nodes"]);
                secondaryVnodes = parseInt(data["secondary_nodes"]);
                progressRate = Math.round((1-((primaryVnodes + secondaryVnodes)/gon.denominator)) * 1000) /10
                $('#extra-progress-bar').css("width",progressRate + "%");
                $('#extra-bar-rate').text(progressRate+ "% Complete");
                break;

            case "join":
                $('#extra-progress-bar').css("width",100 + "%");
                $('#extra-bar-rate').text("Now executing");
                break;

            case "recover":
                shortVnodes = data["short_vnodes"];
                progressRate = Math.round(((gon.denominator - shortVnodes)/gon.denominator)*1000) / 10 //[toDO] use rational?
                $('#extra-progress-bar').css("width",progressRate + "%");
                $('#extra-bar-rate').text(progressRate+ "% Complete");
                break;
        }
    }

    function checkFinish(data, process) {
        switch (process) {
            case "release":
                primaryVnodes   = parseInt(data["primary_nodes"]);
                secondaryVnodes = parseInt(data["secondary_nodes"]);
                progressRate = Math.round((1-((primaryVnodes + secondaryVnodes)/gon.denominator)) * 1000) /10
                if (progressRate == 100) {
                    $('#extra-bar-rate').text("Finished!");
                    setTimeout(function() { confirmRbalse() }, 1000);
                }else{
                    setTimeout(function() { calcProgressRate(process) }, 1000);
                }
                break;

            case "join":
                if (data["status"] != "join") {
                    setTimeout(function() { redirectClusterPage() }, 3000);
                }else{
                    setTimeout(function() { calcProgressRate(process) }, 1000);
                }
                break;

            case "recover":
                shortVnodes = data["short_vnodes"];
                progressRate = Math.round(((gon.denominator - shortVnodes)/gon.denominator)*1000) / 10
                if (progressRate == 100) {
                    $('#extra-bar-rate').text("Finished!");
                    //[toDO] sleep
                    setTimeout(function() { redirectClusterPage() }, 3000);
                }else{
                    //setTimeout(function() { calcRecoverProgressRate() }, 1000);
                    setTimeout(function() { calcProgressRate(process) }, 1000);
                }
                break;
        }
    }

    function confirmRbalse(){
        $('#rbalse-modal-after-release').modal('show')
    }

    function redirectClusterPage(protocol, host){
        if(typeof protocol === 'undefined') protocol = location.protocol;
        if(typeof host === 'undefined') host = location.host;
        window.location.assign(protocol+"//"+host+"/cluster/index");
    }

});
