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
