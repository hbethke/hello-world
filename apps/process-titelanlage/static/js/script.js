
$(document).ready(function () {
    /*
   * Translated default messages for the jQuery validation plugin.
   * Locale: DE (German, Deutsch)
   */
  $.extend( $.validator.messages, {
      required: "Dieses Feld ist ein Pflichtfeld.",
      maxlength: $.validator.format( "Geben Sie bitte maximal {0} Zeichen ein." ),
      minlength: $.validator.format( "Geben Sie bitte mindestens {0} Zeichen ein." ),
      rangelength: $.validator.format( "Geben Sie bitte mindestens {0} und maximal {1} Zeichen ein." ),
      email: "Geben Sie bitte eine gültige E-Mail Adresse ein.",
      url: "Geben Sie bitte eine gültige URL ein.",
      date: "Bitte geben Sie ein gültiges Datum ein.",
      number: "Geben Sie bitte eine Nummer ein.",
      digits: "Geben Sie bitte nur Ziffern ein.",
      equalTo: "Bitte denselben Wert wiederholen.",
      range: $.validator.format( "Geben Sie bitte einen Wert zwischen {0} und {1} ein." ),
      max: $.validator.format( "Geben Sie bitte einen Wert kleiner oder gleich {0} ein." ),
      min: $.validator.format( "Geben Sie bitte einen Wert größer oder gleich {0} ein." ),
      creditcard: "Geben Sie bitte eine gültige Kreditkarten-Nummer ein."
  });
});

/*
 * validate form
 */
function validateForm(selector) {
  var validator = $(selector).validate({
      ignore: "disabled",
      invalidHandler: function(e, validator){
          if(validator.errorList.length)
              $('#tabs a[href="#' + jQuery(validator.errorList[0].element).closest(".tab-pane").attr('id') + '"]').tab('show')
      },
      errorPlacement: function(error, element) {
          if ($(element).parent().hasClass("input-group")) {
              error.insertBefore($(element).parent());
          } else {
              error.insertBefore($(element));
          }
      }
  });
  return validator.form();
}