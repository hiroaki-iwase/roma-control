$(function(){

    //$("dd:not(:first)").css("display","none");                                                                                            
    $("dd").css("display","none");

    $("dl dt").click(function(){
        if($("+dd",this).css("display")=="none"){
            $("dd").slideUp("slow");
            $("+dd",this).slideDown("slow");
        }else{
            $("dd").slideUp("slow");
        }
    });

    $("[data-toggle=tooltip]").tooltip({
      placement: 'left',
      html: true
    });

    var maxlength = 3;
    $("#dynamic").validate({
      rules: {
        "change_value": {
          required: true,
          maxlength: maxlength
        }
      },
      messages: {
        ":changed_value": {
          required: "This param is esssential",
          maxlength: "This param is esssential",
        }
      }
    });

});
