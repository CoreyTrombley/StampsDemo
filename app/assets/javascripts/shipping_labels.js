// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){
  var update_add_ons;
  $('#shipping_label_weight').blur(function(){
    $.ajax({
      url: '/getrates',
      type: 'post',
      data: $('form').serialize(),
      success: function(data) {
        $('#add_ons').html(data);
        $('.insurance').hide();
        $('.cod').hide();
        $('#shipping_label_US-A-INS').click(function(){
          $('.insurance').toggle();
        });
        $('#shipping_label_US-A-COD').click(function(){
          $('.cod').toggle();
        });
      },
      error: function(){
        // raise error
      }
    });
  });
});
