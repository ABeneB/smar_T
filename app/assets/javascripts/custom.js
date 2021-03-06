var disableButton = function(button) {
  if(!$(button).hasClass("disabled")) {
    button.addClass("disabled");
    button.prop('disabled', true);
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

$(function() { 
$('select#user_form_role').bind('change', function() {
  $('#driver').hide();
  $('#driver input').attr('disabled', true);
  var selection = $(this).val();
  $('#' + selection).show();
  $('#' + selection + ' input').attr('disabled', false);
}).change();

});

var deleteCompanyLogo = function(company_id) {
    $.ajax({
        type: 'POST',
        url: '/companies/' + company_id + '/delete_logo',
        success: function(data) {
            $('input#company_logo').val('');
            $('#current_company_logo').remove();
            $('button#delete_company_logo').hide();
            return true;
        }
    })
};

$(function () {
    $('.order_import input').change(function() {
        $('#upload-orders-btn').prop('disabled', ($('#inputfile').val() == ""));
        }
    )
});