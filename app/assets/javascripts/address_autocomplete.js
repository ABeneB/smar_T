//= require typeahead.bundle
//= require typeahead-addresspicker

$( document ).ready(function() {

    var addressPicker = new AddressPicker({
            language: 'de'
        }
    );

    $('#address').typeahead(
        {
            highlight: true
        },
        {
            displayKey: 'description',
            source: addressPicker.ttAdapter(),
            templates: {
                empty: [
                    '<div class="empty-message">Keine Adresse gefunden</div>'].join('\n')
            }
        }
    );

    var address = "";
    addressPicker.bindDefaultTypeaheadEvent($('#address'));
    $(addressPicker).on('addresspicker:selected', function (event, result) {
        address = result.placeResult.formatted_address;
        $('#address').val(address);
    });

    $('#address').on('blur', function (event, result) {
        $('#address').val(address);
    });
});