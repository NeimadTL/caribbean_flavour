$(document).ready(function () {
  $('#add-product-btn').on('click', function(){
    alert('Not working yet');
  })
});

$(function () {
  $('[data-toggle="popover"]').popover({
    container: 'body',
    trigger: 'focus',
    html: true
  })
})

$(document).on('hidden.bs.modal', '.modal', function () {
  $("#lineItemModalId").remove(); $(".modal-dialog").remove();
});

$(document).on('hidden.bs.modal', '.modal', function () {
  $("#orderModalId").remove(); $(".modal-dialog").remove();
});

$(document).on('hidden.bs.modal', '.modal', function () {
  var modal = $(".modal");
  $("#"+modal.attr('id')).remove(); $(".modal-dialog").remove();
});

$(document).on('change', "input[name='order[delivery_option_code]']", function() {
  url = $("#new_order").attr('action');
  shop_id = url.split("/")[5];

  $.ajax({
    method: "GET",
    url: "/consumer/shops/"+shop_id,
    dataType: "script",
    success: function(res) {
      console.log("ajax request went well");
    },
    fail: function(xhr, textStatus, errorThrown) {
      console.log('ajax request failed: ' + errorThrown);
    }
  })
  .done(function( msg ) {
    console.log('ajax request done');
  });




});
