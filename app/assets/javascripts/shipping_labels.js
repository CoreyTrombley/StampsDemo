// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){

  // $('#shipping_label_weight').focusout(function(){
  //   console.log("Fired off");
  //   $.ajax('/getaddons').append('#add_ons');
  // });

    var update_add_ons;
    $('#shipping_label_weight').blur(function() {
      $.ajax({
        // TODO - fix the routes so there is a POST to add_on_lookup
        url: '/getrates',
        type: 'post',
        data: $('form').serialize(),
        success: function(data) {
          $('#add_ons').html(data);
        },
        error: function() {
          // raise error
        }
      });
    });


});
