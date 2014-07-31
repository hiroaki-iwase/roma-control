$(function(){

    function validate(param, checkBrank, checkDigit) {
       if(typeof checkBrank === 'undefined') checkBrank = false;
       if(typeof checkDigit === 'undefined') checkDigit = false;

       if (checkBrank) {
           if (!param.match(/\S/g)) {
               return false;
           }
       }

       if ( checkDigit ) {
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
        var expire = $('.setExptName').val();

        if (!validate(key, true) || !validate(value, true)) {
            $('.set-result').html("<font color='red'>Please input all parameters.</font>");
        } else if (!validate(expire, true, true)) {
            $('.set-result').html("<font color='red'>Expt Time should be digit & over 0</font>");
        } else {
            setValue(key, value, parseInt(expire, 10)) 
        }
    })

    $('.set-reset-btn').click(function () {
        $('.setKeyName').val('');
        $('.setValueName').val('');
        $('.setExptName').val('');
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

    function setApiEndpoint(action) {
        var protocol = location.protocol;
        var host = location.host;
        var webApiEndpoint = protocol+"//"+host+"/api/"+action;
        return webApiEndpoint;
    }

    function setValue(key, value, expire) {
        var webApiEndpoint = setApiEndpoint('set_value')

        $.ajax({
            url: webApiEndpoint,
            type: 'POST',
            beforeSend: function(xhr) {
                xhr.setRequestHeader(
                    'X-CSRF-Token',
                    $('meta[name="csrf-token"]').attr('content')
                )
            },
            data: {
                "key": key,
                "value": value,
                "expire": expire
            },
            dataType: 'text',
            cache: false,
        }).done(function(data){
            $('.set-result').html(data);
        }).fail(function(error){
            alert("fail to access Gladiator Web API");
        });
    }

    function getValue(value) {
        var webApiEndpoint = setApiEndpoint('get_value')

        $.ajax({
            url: webApiEndpoint+"/"+value,
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

        var webApiEndpoint = setApiEndpoint('get_parameter')
        $('#lastSnapshotDate').text("-----");

        $.ajax({
            url: webApiEndpoint+"/"+host+"/"+port,
            type: 'GET',
            dataType: 'json',
            cache: false,
        }).done(function(data){
            eachStatus = data['storages[roma]']['storage.safecopy_stats'].replace(/\[|\]/g, "").split(', ');
            if (typeof gon.pastSnapshotDate === 'undefined') {
               gon.pastSnapshotDate = data['stats']['gui_last_snapshot'];
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
        if (data['stats']['gui_run_snapshot'] == 'true') {
            setTimeout(function() { snapshotStatusCheck(gon.snapshoting) }, 1000);
        }else{
            if (data['stats']['gui_last_snapshot'] != gon.pastSnapshotDate) {
                $('#snapshotStatus').text("Finished!");
            } else {
                $('#snapshotStatus').text("Unexpected Error: STOP snapshot");
            }
            $('#lastSnapshotDate').text(data['stats']['gui_last_snapshot']);
            gon.snapshoting = null
            return;
        }
    }

});
