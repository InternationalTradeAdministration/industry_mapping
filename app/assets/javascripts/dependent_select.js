// Source : https://github.com/abhidsm/dependent-select/blob/master/dependent_select.js
// Modified: fix broken has() & find() with new sizzlejs update.

jQuery(document).ready(function() {
    $('select[data-option-dependent=true]').each(function (i) {

        var observer_dom_id = $(this).attr('id');
        var observed_dom_id = $(this).data('option-observed');
        var url_mask        = $(this).data('option-url');
        var key_method      = "id"; //$(this).data('option-key-method');
        var value_method    = "name"; //$(this).data('option-value-method');
        var regexp          = /:[0-9a-zA-Z_]+/g;

        var observer = $('select#'+ observer_dom_id);
        var observed = $('select#'+ observed_dom_id);

        if (!observer.val() && observed.size() > 1) {
            observer.attr('disabled', true);
        }
        observed.on('change', function() {
            url = url_mask.replace(regexp, function(submask) {
                dom_id = submask.substring(1, submask.length);
                return $("select#"+ dom_id).val();
            });

            observer.empty();

            $.getJSON(url, function(data) {
                $.each(data, function(i, object) {
                    observer.append($('<option>').attr('value', object[key_method]).text(object[value_method]));
                    observer.attr('disabled', false);
                });

            });
        });
    });
});
