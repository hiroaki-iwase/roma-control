$(function(){

    $('.get-value-btn').click(function () {
       var value = $('.getKeyName').val();
       alert(value);
       /** Call API **/
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
       alert(port);
       /** generate cmd **/
    })

});
