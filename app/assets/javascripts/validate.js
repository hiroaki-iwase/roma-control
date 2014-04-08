$(function(){
    $("#dynamic_chage_valude").validate({
      rules: {
        "size_of_zredundant": {
          required: true,
          min: 1,
          maxlength: 10
        }
      },
      rules: {
        "hilatency_warn_time": {
          required: true,
          min: 1,
          maxlength: 10
        }
      },
      rules: {
        "spushv_klength_warn": {
          required: true,
          min: 1,
          maxlength: 10
        }
      },
      rules: {
        "spushv_vlength_warn": {
          required: true,
          min: 1,
          maxlength: 10
        }
      },
      rules: {
        "routing_trans_timeout": {
          required: true,
          min: 1,
          maxlength: 10
        }
      }
	});
});