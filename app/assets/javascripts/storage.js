$(function(){

    $('.get-value-btn').click(function () {
       var value = $('.getKeyName').val();
       getValue(value);
    })

    $('.set-value-btn').click(function () {
        var key = $('.setKeyName').val();
        var value = $('.setValueName').val();
        var expt = Number($('.setExptName').val());

        if ( isNaN (expt) || expt < 0 ) {
            $('.set-result').html(
              "<font color='red'>Expt Time should be digit & over 0</font>"
            );
        }else{
          //console.log(typeof expt);
          setValue(key, value, expt);
        }
    })
    

    $('.snapshot-btn').click(function () {
        var port = Number($('.snapPort').val());
        if ( isNaN (port) || port < 0 ) {
            $('.snap-command').html(
              "<font color='red'>Port No. should be digit & over 0</font>"
            );
        } else {
            $('.snap-command').css("background-color", "black");
            $('.snap-command').html(
              "$ cd ${ROMA directory}/ruby/server<br>"
              + "$ bin/cpdb " + port
            );
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

});
