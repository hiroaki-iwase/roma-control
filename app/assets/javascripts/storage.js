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
        snapshotStatusCheck(gon.snapshoting);
    }

    function snapshotStatusCheck(instance) {
        var host = instance.split('_')[0]
        var port = instance.split('_')[1]
        var webApiEndPoint

        webApiEndPoint = location.protocol+"//"+location.host+"/api/get_parameter";
        $('#lastSnapshotDate').text("-----");

        $.ajax({
            url: webApiEndPoint+"/"+host+"/"+port,
            type: 'GET',
            dataType: 'json',
            cache: false,
        }).done(function(data){
            eachStatus = data['storages[roma]']['storage.safecopy_stats'].replace(/\[|\]/g, "").split(', ');
            if (typeof gon.pastSnapshotDate === 'undefined') {
               gon.pastSnapshotDate = data['stats']['last_snapshot'];
            }
            jQuery.each(eachStatus, function(index, value){
                $('#snapshotStatus'+index).text(value)
            }); 
            checkFinish(data);

        }).fail(function(){
          alert("fail to access Gladiator Web API");
        });
    } //End of snapshotStatusCheck(instance)

    function checkFinish(data) {
        if (data['stats']['run_snapshot'] == 'true') {
            setTimeout(function() { snapshotStatusCheck(gon.snapshoting) }, 1000);
        }else{
            console.log(gon.debug)
            if (data['stats']['last_snapshot'] != gon.pastSnapshotDate) {
                $('#snapshotStatus').text("Finished!");
            } else {
                $('#snapshotStatus').text("Unexpected Error: STOP snapshot");
            }
            $('#lastSnapshotDate').text(data['stats']['last_snapshot']);
            gon.snapshoting = null
            return;
        }
    }

});
