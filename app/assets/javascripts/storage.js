$(function(){

    $('.get-value-btn').click(function () {
       var value = $('.getKeyName').val();
       setValue(value);
    })

    $('.set-value-btn').click(function () {
       var key = $('.setKeyName').val();
       var value = $('.setValueName').val();
       var expt = $('.setExptName').val();
       alert(key + value+ expt);
       /** Call API **/
    })
    

    $('.snapshot-btn').click(function () {
       var port = $('.snapPort').val();
       $('.snap-command').css("background-color", "black");
       $('.snap-command').html(
         "$ cd ${ROMA directory}/ruby/server<br>"+"$ bin/cpdb "+ port
       );
    })

    function setValue(value) {
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
