/**
 * Initialize Dropzone
 */
function initDropzone(varname, selector, url) {
  if(Dropzone[varname]) {
    try {
      Dropzone[varname].destroy();
    } catch (e) {}
  }      
  Dropzone[varname] = new Dropzone(selector, { url: decodeURIComponent(url)});
  Dropzone[varname].on("complete", function(file) {
    handleAjaxResponse("",file.xhr,{restxq:true})
    window.file = file;
    window.file.rm = Dropzone.prototype.removeFile
    window.setTimeout(Dropzone.remove,2000)}
  );
}

$(document).ready(function(){
    //vertrag-pruefen-rechte-abgleichen-und-hochladen
    $(".checklist-checkbox").click(function(){
      var nr = $(this).attr("nr");
      var checked = $(this).is( ":checked" );
      
      if(checked){
        $(this).val("true");
      }
      else{
        $(this).val("false");
      }
      $("#checklist-form-" + nr).submit();
    });
    // /vertrag-pruefen-rechte-abgleichen-und-hochladen
    
    
    // feindaten-beschaffen
    $("#filename").keyup(function(){
        if($(this).val() != "" && !$('.attachment').find("[data-i18n='drop_file_here']").size()){
            var oldHref = $("[data-i18n='save']").parent().attr('href');
            if(oldHref.lastIndexOf("&newFilename") != -1){
                $("[data-i18n='save']").parent().attr('href', oldHref.substr(0, oldHref.lastIndexOf("&newFilename"))); 
            }
            
            $("[data-i18n='save']").parent().removeClass('disabled');    
            $("[data-i18n='complete-task']").parent().removeClass('disabled');
        }
        else{
            $("[data-i18n='save']").parent().addClass('disabled'); 
            $("[data-i18n='complete-task']").parent().addClass('disabled'); 
        }
    });
    
    $("#filename").keyup();
    // / feindaten-beschaffen
    
    $("#Lizenzgeber").change(function () {
        var form = $("#form");var action = form.data("update-action");form.attr("action", action);form.submit();
    });
    
    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green',
        radioClass: 'iradio_square-green',
    });
});

// feindaten-beschaffen
function save_filename(){
    $("#save_filename").click(function(){           
        var newFilename = $("#filenamePrefix").val() + $("#filename").val();            
        var oldHref = $("#save_filename").attr('href');
        
        $("#save_filename").attr('href', oldHref+"&newFilename="+newFilename);
        
        $(".filename").fadeToggle();
        $(".filename").html(newFilename + $("#filenameExtension").val());
        $(".filename").fadeToggle();
    });
    
    $("#filename").keyup();
    
    // wenn der Aufgabe erledigen Button gedrückt wird, wird vorher auch noch einmal gespeichert
    $("[data-i18n='complete-task']").parent().off( "click" ); // << hier wird verhindert das die onclick Methode mehrmals am Button hängt
    $("[data-i18n='complete-task']").parent().click(function(){
        $("[data-i18n='save']").parent().click();
    });
}
// /feindaten-beschaffen