$(function(){

    if($(".login-error").length){
        errorMsg = $(".login-error").text();
        if (errorMsg.match(/missing plugin/)) {
          $('#plugin-modal').modal({
              show: true,
          });
        }
    }

    //$("#loginButton").click(function() {
    //    checkRomaVersion();
    //    //alert('sss');
    //        //if($(this).is(':checked')) {
    //        //    $('#repetition-modal').modal({
    //        //        show: true,
    //        //        keyboard: false
    //        //    })
    //        //}
    //});

    //function setApiEndpoint(action) {
    //    var protocol = location.protocol;
    //    var host = location.host;
    //    var webApiEndpoint = protocol+"//"+host+"/api/"+action;
    //    return webApiEndpoint;
    //}

    //function checkRomaVersion() {

    //    //var host = instance.split('_')[0]
    //    //var port = instance.split('_')[1]

    //    var webApiEndpoint = setApiEndpoint('get_parameter')

    //    alert(webApiEndpoint);

    //    $.ajax({
    //        //url: webApiEndpoint+"/"+host+"/"+port,
    //        url: webApiEndpoint,
    //        type: 'GET',
    //        dataType: 'json',
    //        cache: false,
    //    }).done(function(data){
    //    alert('sss');
    //    }).fail(function(){
    //      alert("fail to check ROMA version");
    //    });
    //}//End of checkRomaVersion

});
