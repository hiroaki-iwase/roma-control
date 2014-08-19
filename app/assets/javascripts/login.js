$(function(){

    //plugin check
    if($(".login-error").length){
        errorMsg = $(".login-error").text();
        if (errorMsg.match(/missing plugin/)) {
          $('#plugin-modal').modal({
              show: true,
          });
        }
    }

//    //version check
//    $("#loginButton").click(function() {
//        version = checkRomaVersion();
//        if (version >= 65536) { // over v1.0.0
//           //access to auth
//            var userName = $('#userNameValue').val();
//            var passWord = $('#passWordValue').val();
//            login(userName, passWord);
//
//        } else if ( version >= 2059 && version < 65536 ) { //v0.8.11 - v0.8.14
//            var userName = $('#userNameValue').val();
//            var passWord = $('#passWordValue').val();
//            $('#loginUserName').val(userName);
//            $('#loginPassword').val(passWord);
//            $('#version-modal').modal({
//                show: true,
//                keyboard: false,
//            });
//        } else { // below v0.8.10 and unexpected version
//            $('.password').val('');
//            $('#version-restrict-modal').modal({
//                show: true,
//                keyboard: false,
//            });
//            alert('no s');
//        }
//    });
//
//    function checkRomaVersion() {
//    //      $('#plugin-modal').modal({
//    //          show: true,
//    //      });
//        return 777;
//    //    //var host = instance.split('_')[0]
//    //    //var port = instance.split('_')[1]
//
//    //    var webApiEndpoint = setApiEndpoint('get_parameter')
//
//    //    alert(webApiEndpoint);
//
//    //    $.ajax({
//    //        //url: webApiEndpoint+"/"+host+"/"+port,
//    //        url: webApiEndpoint,
//    //        type: 'GET',
//    //        dataType: 'json',
//    //        cache: false,
//    //    }).done(function(data){
//    //    alert('sss');
//    //    }).fail(function(){
//    //      alert("fail to check ROMA version");
//    //    });
//    //}//End of checkRomaVersion
//
//    //function setApiEndpoint(action) {
//    //    var protocol = location.protocol;
//    //    var host = location.host;
//    //    var webApiEndpoint = protocol+"//"+host+"/api/"+action;
//    //    return webApiEndpoint;
//    }
//
//    //function login(userName, passWord) {
//    ////    //var host = instance.split('_')[0]
//    ////    //var port = instance.split('_')[1]
//
//    //var webApiEndpoint = 'http://192.168.223.2:3000/login/auth'
//
//    ////    var webApiEndpoint = setApiEndpoint('get_parameter')
//
//    //var data = {username:userName, password:passWord}
//    //    $.ajax({
//    //        url: webApiEndpoint,
//    //        type: 'POST',
//    //        data: {
//    //            username: userName,
//    //            password: passWord
//    //        },
//    //        dataType: "html",
//    //        cache: false,
//    //    }).done(function(data){
//    //        console.log('success to login');
//    //    }).fail(function(){
//    //        alert("fail to check ROMA version");
//    //    });
//
//    ////function setApiEndpoint(action) {
//    ////    var protocol = location.protocol;
//    ////    var host = location.host;
//    ////    var webApiEndpoint = protocol+"//"+host+"/api/"+action;
//    ////    return webApiEndpoint;
//    //}

});
