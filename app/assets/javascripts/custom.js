$(function() {
  $("tbody.sortable").sortable({
    items: "tr:not(.unsortable)",
    update: function (event, ui) {
        var data = $(this).sortable('serialize');
        $.ajax({
            data: data,
            type: 'POST',
            url: '/tours/positions/update'
        });
        $("#map").hide();
        $(".map-info").removeClass("hidden");
     }
  });
});

var disableButton = function(button) {
  if(!$(button).hasClass("disabled")) {
    button.addClass("disabled");
  }
}


$(function() { 
$('select#problem').bind('change', function() {
  $('.type_forms').hide();
  $('.type_forms input').attr('disabled', true);
  var selection = $(this).val();
  $('#' + selection).show();
  $('#' + selection + ' input').attr('disabled', false);
  if ( this.value == 'type_3'){
  $('#type_1').show();
  $('#type_1 input').attr('disabled', false);
  $('#type_2').show();
  $('#type_2 input').attr('disabled', false);
  }
}).change();

});