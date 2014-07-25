$(function(){

    $('.get-value-btn').click(function () {
        var key = $('.getKeyName').val();

        //if (key.size == null) {
        //  $('.get-result').html(
        //    "<font color='red'>Expt Time should be digit & over 0</font>"
        //  );
        //  return;
        //}
        getValue(key);
    })

    $('.set-value-btn').click(function () {
        var key = $('.setKeyName').val();
        var value = $('.setValueName').val();
        var expt = Number($('.setExptName').val());
        //if ( key.size == null | value.size == null | expt == null ) {
        //  $('.set-result').html(
        //    "<font color='red'>Expt Time should be digit & over 0</font>"
        //  );
        //  return;
        //}
        //if ( isNaN (expt) || expt < 0 ) {
        //    $('.set-result').html(
        //      "<font color='red'>Expt Time should be digit & over 0</font>"
        //    );
        //}else{
          //console.log(typeof expt);
          setValue(key, value, expt);
        //}
    })
    

    $('.snapshot-btn').click(function () {
        var port = Number($('.snapPort').val());
        //if ( !port ) {
        //    $('.snap-command').html(
        //        "<font color='red'>Port No. should be digit & over 0</font>"
        //    );
        //    return;
        //}
        //if ( isNaN (port) || port < 0 ) {
        //    $('.snap-command').html(
        //      "<font color='red'>Port No. should be digit & over 0</font>"
        //    );
        //} else {
            $('.snap-command').css("background-color", "black");
            $('.snap-command').html(
              "$ cd ${ROMA directory}/ruby/server<br>"
              + "$ bin/cpdb " + port
            );
        //}
    })

    function setValue(key, value, expt) {
        var protocol = location.protocol;
        var host = location.host;
        var webApiEndPoint = protocol+"//"+host+"/api/set_value";

        $.ajax({
            url: webApiEndPoint,
            type: 'POST',
            data: {
                "key": key,
                "value": value,
                "expt": expt
            },
            dataType: 'text',
            cache: false,
        }).done(function(data){
            $('.set-result').text(data);
        }).fail(function(error){
            alert("fail to access Gladiator Web API");
        });
    }

    function getValue(value) {
        var protocol = location.protocol;
        var host = location.host;
        var webApiEndPoint = protocol+"//"+host+"/api/get_value";

        $.ajax({
            url: webApiEndPoint+"/"+value,
            type: 'GET',
            dataType: 'text',
            cache: false,
        }).done(function(data){
            $('.get-result').text(data);
        }).fail(function(){
            alert("fail to access Gladiator Web API");
        });
    }

    //start to check snapshot
    if(document.getElementById('snapshotProgress')) {
        console.log(gon.snapshoting);
        //calcProgressRate('recover');
        snapshotStatusCheck(gon.snapshoting);
    }

    function snapshotStatusCheck(instance) {
        console.log("statusCheck called");
        var host = instance.split('_')[0]
        var port = instance.split('_')[1]
        var webApiEndPoint

        webApiEndPoint = location.protocol+"//"+location.host+"/api/get_parameter";

        $.ajax({
            url: webApiEndPoint+"/"+host+"/"+port,
            type: 'GET',
            dataType: 'json',
            cache: false,
        }).done(function(data){
            console.log("success API access");
            console.log(data['storages[roma]']['storage.safecopy_stats']);
            console.log(typeof data['storages[roma]']['storage.safecopy_stats']);
            eachStatus = data['storages[roma]']['storage.safecopy_stats'].replace(/\[|\]/g, "").split(', ');
            console.log(eachStatus);
            console.log(typeof eachStatus);
            console.log(data['stats']['run_snapshot']);
       
            jQuery.each(eachStatus, function(index, value){
               
        //        if (data[instanceName]["status"] != "inactive") {

        //            primaryVnodes   = parseInt(data[instanceName]["primary_nodes"]);
        //            secondaryVnodes = parseInt(data[instanceName]["secondary_nodes"]);
        //            startPrimaryVnodes   = gon.routing_info[instanceName]["primary_nodes"];
        //            startSecondaryVnodes = gon.routing_info[instanceName]["secondary_nodes"];

        //            //set vnodes count
        //            //[toDO : use instance variables]
        //            if (primaryVnodes < startPrimaryVnodes) {
        //                color_primary = "red"
        //                icon_primary  = 'arrow-down'
        //            }else if (primaryVnodes > startPrimaryVnodes) {
        //                color_primary = "blue"
        //                icon_primary  = 'arrow-up'
        //            }else{
        //                color_primary = ""
        //                icon_primary  = ''
        //            }

        //            if (secondaryVnodes < startSecondaryVnodes) {
        //                color_secondary = "red"
        //                icon_secondary  = 'arrow-down'
        //            }else if (secondaryVnodes > startSecondaryVnodes) {
        //                color_secondary = "blue"
        //                icon_secondary  = 'arrow-up'
        //            }else{
        //                color_secondary = ""
        //                icon_secondary  = ''
        //            }

        //            instance = instanceName.match(/\d/g).join("");
        //            //for primary nodes
        //            $('#primary-nodes-'+instance).css("color", color_primary)
                      $('#snapshotStatus'+index).text(value)
        //            //for secondary nodes
        //            $('#secondary-nodes-'+instance).css("color", color_secondary)
        //            $('#secondary-nodes-'+instance).html(secondaryVnodes+'<span><i class="icon-'+icon_secondary+'"></i></span>')

        //            if (instanceName == gon.host+"_"+gon.port) {
        //                $('#short-vnodes-cnt').text(data[instanceName]["short_vnodes"]);

        //                progressBarSet(data[instanceName], process);
                        // check run_status
        //            }
        //        }

            }); 
            //checkFinish(data['stats']['run_snapshot']);
            checkFinish(data);
        }).fail(function(){
          alert("fail to access Gladiator Web API");
        });
    } //End of snapshotStatusCheck(instance)

    function checkFinish(data) {
        if (data['stats']['run_snapshot'] == 'true') {
            setTimeout(function() { snapshotStatusCheck(gon.snapshoting) }, 1000);
        }else{
            $('#snapshotStatus').text("Finished!");
            $('#lastSnapshotDate').text(data['stats']['last_snapshot']);
            gon.snapshoting = null
            return;
        }
    }

});
