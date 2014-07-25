$(function(){

    function validate(param, restrictBrank, onlyDigit) {
       if(typeof restrictBrank === 'undefined') restrictBrank = false;
       if(typeof onlyDigit === 'undefined') onlyDigit = false;

       if (restrictBrank) {
           if (!param.match(/\S/g)) {
               return false;
           }
       }

       if ( onlyDigit ) {
           if (!isFinite(parseInt(param, 10)) || parseInt(param, 10) < 0 ) {
               return false;
           }
       }

      return true;
    }


    $('.get-value-btn').click(function () {
        var key = $('.getKeyName').val();
        
        if (validate(key, true)) {
            getValue(key);
        } else {
            $('.get-result').html("<font color='red'> Please input Key name</font>");
        }
    })

    $('.set-value-btn').click(function () {
        var key = $('.setKeyName').val();
        var value = $('.setValueName').val();
        var expt = $('.setExptName').val();

        if (!validate(key, true) || !validate(value, true)) {
            $('.set-result').html("<font color='red'>Please input all parameters.</font>");
        } else if (!validate(expt, true, true)) {
            $('.set-result').html("<font color='red'>Expt Time should be digit & over 0</font>");
        } else {
            setValue(key, value, parseInt(expt, 10)) 
        }
    })

    $('.snapshot-btn').click(function () {
        var port = $('.snapPort').val();

        $('.snap-command').css("background-color", "black");
        if (validate(port, true, true)) {
            $('.snap-command').html(
              "$ cd ${ROMA directory}/ruby/server<br>"
              + "$ bin/cpdb " + parseInt(port, 10)
            );
        } else {
            $('.snap-command').html("<font color='red'>Port No. should be digit & over 0</font>");
        }
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
