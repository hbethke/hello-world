module namespace _="process/beschaffung/drittlizenzen";
import module namespace global  ='influx/global';
import module namespace plugin='influx/plugin';
import module namespace ui    ='influx/ui';

import module namespace session = 'http://basex.org/modules/session';

declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace System='http://ns.exiftool.ca/File/System/1.0/';

declare variable $_:name := "process-beschaffung-drittlizenzen"; (: module folder name :)
declare variable $_:staticPath := global:generateStaticPath(file:base-dir());

declare variable $_:definitionId := ("id-d025905c-8d2a-4edc-a90f-b1f802908b1c","Property_release_beschaffen","Model_release_beschaffen"); (: definition ID for Drittlizenzen beschaffen process :)
declare variable $_:asset-fiendaten := "DataObjectReference_1sgwzn4";
declare variable $_:asset-muster := "DataObjectReference_1hqrrcm";
declare variable $_:sub-asset-muster := "DataObjectReference_0g3850o";
declare variable $_:fremd-und-drittrechte-markieren:="UserTask_11j7sz3";
declare variable $_:start-event := "sid-D7F237E8-56D0-4283-A3CE-4F0EFE446138";



(: Thumbnail for "einzellizenz prozess" is the thumb rendition of the dataobject "asset-muster" :)
declare %plugin:provide('token/ui/process/thumb', 'Property_release_beschaffen')
function _:task-thumb-property-release($Token){
 plugin:lookup('token/ui/dataobject/thumb')!.($Token,$_:sub-asset-muster,100,100)
};

(: Thumbnail for "einzellizenz prozess" is the thumb rendition of the dataobject "asset-muster" :)
declare %plugin:provide('token/ui/process/thumb', 'Model_release_beschaffen')
function _:task-thumb-model-release($Token){
 plugin:lookup('token/ui/dataobject/thumb')!.($Token,$_:sub-asset-muster,100,100)
};
   
declare %plugin:provide("process/beschaffung/drittlizenzen/id")
function _:get-id() {
  $_:definitionId
};
        
declare %plugin:provide("process/beschaffung/drittlizenzen/ui")
function _:render-page-content($ProcessInstanceId as xs:string,$ButtonBar as element(xhtml:div), $Class as xs:string?, $Action as item()*)
  as element(xhtml:div) {
  let $parentProcessInstance :=  plugin:lookup("instance")!.($ProcessInstanceId)
  let $token := $parentProcessInstance//*:Token[@ActivityId=$_:fremd-und-drittrechte-markieren][@Status='assigned'][@Performer=session:get('user')]
  let $processInstances := plugin:lookup("instances/filtered")!.(
    map {
      "ParentProcessInstanceId":$ProcessInstanceId,
      "DefinitionId":$_:definitionId
    }
    ,"[@ParentProcessInstanceId=$ParentProcessInstanceId][Definition/*:definitions/@id=$DefinitionId]")
  let $meta := plugin:lookup("dataobject/get/meta")!.($token,$_:asset-muster)
  return
  <div xmlns="http://www.w3.org/1999/xhtml" id="render-{$_:name}-{$ProcessInstanceId}" class="detail-view">{$Action}
        <link href="{$_:staticPath}/css/cropper.min.css" rel="stylesheet"/>
        <link href="{$_:staticPath}/css/style.css" rel="stylesheet"/>
          <div class="row">
              <div class="col-xs-8">
                <div class="image-wrapper">
                  <img id="{$_:name}-img" src="/static/{$meta/*:previewUrl}" style="max-width:100%;" onload="
                    var $img = $(this);
                    $img.parent().children('a').each(function() {{
                      var $div = $(this).children('div');
                      var ratio = $img.width() / $img.get(0).naturalWidth;

                      $div.css({{
                        left: ratio * parseFloat($div.data('left')),
                        top: ratio * parseFloat($div.data('top')),
                        width: ratio * parseFloat($div.data('width')),
                        height: ratio * parseFloat($div.data('height'))
                      }});
                    }});"/>
                  {
                    for $pi in $processInstances
                    let $class :=
                      if($pi/@Status=plugin:lookup("instance/statuses/active")!.()) then
                        "pi-third-party-license-pending"
                      else if($pi/@Status=plugin:lookup("instance/statuses/completed")!.()) then
                        "pi-third-party-license-agreed"
                      else
                        "pi-third-party-license-rejected"
                    return
                      <a>
                        <div class="pi-third-party-license {$class}" data-left="{$pi/@Left}" data-top="{$pi/@Top}" data-width="{$pi/@Width}" data-height="{$pi/@Height}">
                          <div class="image-wrapper--description">
                          <strong>{$pi/@Name/string()}</strong>
                          <span>{$pi/@Description/string()}</span>
                          </div>
                        </div>
                      </a>
                  }
                  <!--a><div class="pi-single-license agreed" data-x="{}" data-y="" data-with="" data-height=""/></a>
                  <a><div class="pi-single-license rejected"/></a>
                  <a><div class="pi-single-license"/></a-->
                </div>
              </div>
              <div class="col-xs-4">
                <h4>Preview</h4>
                <div id="{$_:name}-cropped-img" class="img-preview cropper-bg" style="min-width:100%;max-width:100%"/>
                <br/>
                <form method="post" id="{$_:name}-cropped-img-description" action="#">                
                  <label class="control-label">Beschreibung*</label>
                  <textarea required="required" class="form-control input-sm" rows="6" style="resize: none;"></textarea>
                </form>
              </div>
          </div>
          <div class="row">
              <div class="col-xs-12">{
                $ButtonBar
              }</div>
          </div>
  </div>
};

declare %restxq:path("process/beschaffung/drittlizenzen/start/{$DefinitionId}/{$ParentProcessInstanceId}")
        %restxq:query-param("provider", "{$ProviderId}", "")
        %restxq:query-param("productid", "{$ProductId}")
        %restxq:query-param("tokenId", "{$TokenId}")
        %restxq:POST
        %restxq:form-param("croppedImg","{$CroppedImg}")
        %restxq:form-param("description","{$Description}")
        %restxq:form-param("left","{$Left}")
        %restxq:form-param("top","{$Top}")
        %restxq:form-param("width","{$Width}")
        %restxq:form-param("height","{$Height}")
%updating function _:start-process-instance(
    $ProviderId as xs:string,
    $ProductId as xs:string,
    $TokenId as xs:string?,
    $ParentProcessInstanceId as xs:string,
    $CroppedImg as xs:base64Binary,
    $Description as xs:string?,
    $Left as xs:string,
    $Top as xs:string,
    $Width as xs:string,
    $Height as xs:string,
    $DefinitionId as xs:string)
  as element(xhtml:table) {  
  let $rulesProvider := "http://influx.adesso.de/engine/bpmn"
  let $processInstanceName := 

    if($DefinitionId="Model_release_beschaffen") then "Model Release beschaffen"||$Description
    else if($DefinitionId="Property_release_beschaffen") then "Property Release beschaffen"||$Description
    else if ($DefinitionId="id-d025905c-8d2a-4edc-a90f-b1f802908b1c") then "Medien bei VGs melden"||$Description
    else "Drittlizenz beschaffen - "||$Description
  let $processInstanceProvider := "http://influx.adesso.de/datastore/process-instances"
  let $processDefinitionProvider := "http://influx.adesso.de/datastore/definition"
  let $processDefinition :=  plugin:provider-lookup($processDefinitionProvider,"definition")!.($DefinitionId)
  
  let $userId := session:get("user")
  
  return
    if($processDefinition) then
      let $dbPath := $ProductId || "/assets"
      let $meta := plugin:provider-lookup($ProviderId, "media/put/filename")!.($CroppedImg, "img.jpg", $dbPath)
      
      let $subPI := plugin:provider-lookup('http://influx.adesso.de/modules/bpmn-instances-manager/processinstance',"instance/new")!.(
        $rulesProvider,
        $processInstanceName,
        $processInstanceProvider,
        $processDefinitionProvider,
        $processDefinition)
      let $subPI := plugin:lookup("instance/extend/attribute")($subPI,"ProductId",$ProductId)
      let $subPI := plugin:lookup("instance/extend/attribute")($subPI,"ParentProcessInstanceId",$ParentProcessInstanceId)
      let $subPI := plugin:lookup("instance/extend/attribute")($subPI,"Description",$Description)
      let $subPI := plugin:lookup("instance/extend/attribute")($subPI,"Left",$Left)
      let $subPI := plugin:lookup("instance/extend/attribute")($subPI,"Top",$Top)
      let $subPI := plugin:lookup("instance/extend/attribute")($subPI,"Width",$Width)
      let $subPI := plugin:lookup("instance/extend/attribute")($subPI,"Height",$Height)
      let $subPI := plugin:lookup("instance/start")($subPI, $userId)
      
      let $startToken:=$subPI//*:Token[@ActivityId=$_:start-event]
      let $processInstanceId := $subPI/@Id/string()
      let $write-sub-asset-muster := 
        plugin:lookup("dataobject/put")
                     !.($startToken,$_:sub-asset-muster,$CroppedImg)
      (:let $meta :=
        plugin:lookup("dataobject/create/rendition")
                     !.($activeToken,$_:asset-muster,"thumb"):)
      let $do-meta:= plugin:lookup("image/meta/extract")!.($CroppedImg)
      let $meta := plugin:lookup("dataobject/put/meta")!.($startToken, $_:sub-asset-muster, $do-meta)
      
      let $pi := plugin:lookup('instance')!.($ParentProcessInstanceId)[@Status=plugin:lookup("instance/statuses/active")!.()]
      return
        <table xmlns="http://www.w3.org/1999/xhtml">
          {
            let $token :=  if($TokenId) then plugin:lookup("token")!.($TokenId) else ()
            return
              if($token) then
                _:render-page-content($ParentProcessInstanceId,plugin:lookup("token/button/bar",$token/@ActivityId)!.($token),(),attribute data-replace {"#render-"||$_:name||"-"||$ParentProcessInstanceId})
              else
                _:render-page-content($ParentProcessInstanceId,_:button-bar(_:specific-buttons($ParentProcessInstanceId,())),(),attribute data-replace {"#render-"||$_:name||"-"||$ParentProcessInstanceId})
            ,(plugin:lookup("bpmn/instance/render")!.($subPI,$meta,"animated fadeInRight once", attribute data-prepend {"#render-sub-process-instances-of-"||$pi/@Id})
            ,ui:info("Der Beschaffungsprozess für die Drittlizenz ist gestartet."))
          }
        </table>
     else
      <table xmlns="http://www.w3.org/1999/xhtml">
        {ui:error("Die Prozessdefinition existiert nicht.")}
      </table>
};


declare function _:button-bar($Buttons as item()*) {  
  <div xmlns="http://www.w3.org/1999/xhtml" id="token-button-bar" class="animated fadeInLeft" data-replace="#token-button-bar">
   <hr/>
   <div class="row">
     <div class="col-md-12 button-bar">
       <div class="button-classic clearfix">{
         $Buttons
       }</div>
     </div>
   </div>
  </div>
};

declare %plugin:provide("process/beschaffung/drittlizenzen/button/specific")
function _:specific-buttons($ProcessInstanceId as xs:string, $TokenId as xs:string?) {
  (
    <a id="{$_:name}-init-cropper" class="btn btn-outline btn-sm btn-primary">Motiv auswählen</a> ,
    <a data-pid="Model_release_beschaffen" class="btn btn-outline btn-sm btn-primary disabled {$_:name}-start-pi">Model release</a> ,
    <a data-pid="Property_release_beschaffen" class="btn btn-outline btn-sm btn-primary disabled {$_:name}-start-pi">Property release</a>,
    <a data-pid="id-d025905c-8d2a-4edc-a90f-b1f802908b1c" class="btn btn-outline btn-sm btn-primary {$_:name}-start-pi">Medium bei VGs melden</a>,
    <a id="{$_:name}-destroy-cropper" class="btn btn-outline btn-primary btn-sm disabled">Auswahl abbrechen</a>,
    <script src="{$_:staticPath}/js/cropper.js"></script>,
    <script type="text/javascript"><![CDATA[
      var $img = $('#process-beschaffung-drittlizenzen-img');
      var selectorCroppedImg = '#process-beschaffung-drittlizenzen-cropped-img';
      var $croppedImg = $(selectorCroppedImg);
      var $croppedImgDescription = $('#process-beschaffung-drittlizenzen-cropped-img-description textarea');
      var $btnInitCropper = $('#process-beschaffung-drittlizenzen-init-cropper');
      var $btnDestroyCropper = $('#process-beschaffung-drittlizenzen-destroy-cropper');
      var $btnStartPI = $('.process-beschaffung-drittlizenzen-start-pi');

      $(window).off('resize');
      $(window).off('resize.cropper');

      $croppedImg.height(3*$croppedImg.width()/4)
      $(window).resize(function() {
        $croppedImg.height(3*$croppedImg.width()/4)

        $.merge($img.parent().children('a').children('div'), $img.parent().find('.cropper-canvas').children('')).each(function() {
          var $div = $(this);
          var ratio = $img.parent().width() / $img.get(0).naturalWidth;

          $div.css({
            left: ratio * parseFloat($div.data('left')),
            top: ratio * parseFloat($div.data('top')),
            width: ratio * parseFloat($div.data('width')),
            height: ratio * parseFloat($div.data('height'))
          });
        });
      });

      $btnInitCropper.unbind('click').click(function() {
        $btnInitCropper.addClass('disabled');
        $img.cropper('destroy')
        $img.cropper({
          aspectRatio: 4 / 3,
          preview:selectorCroppedImg,
          viewMode:1,
          zoomable: false,
          autoCropArea: 0.2,
          restore: true,
          built: function (e) {
            $img.parent().children('a').hide().children('div').clone().appendTo($img.parent().find('.cropper-canvas'));
          },
          resize: function (e) {
            console.log('resized!');
          }
        })
        $btnDestroyCropper.removeClass('disabled');
        $btnStartPI.removeClass('disabled');
      });

      $btnDestroyCropper.unbind('click').click(function() {
        $btnDestroyCropper.addClass('disabled');
        $btnStartPI.addClass('disabled');
        $img.cropper('destroy');
        $img.parent().children('a').show();
        $btnInitCropper.removeClass('disabled');
      });

      $btnStartPI.unbind('click').click(function() {
        if(validateForm("form#process-beschaffung-drittlizenzen-cropped-img-description")) {
          var pid = $(this).data('pid')
          var croppedImg = $img.cropper('getCroppedCanvas').toDataURL().replace('data:image/png;base64,','');
          $btnDestroyCropper.addClass('disabled');
          $btnStartPI.addClass('disabled');
          var data = $img.cropper('getData');
          var formData = new FormData();
          formData.append('croppedImg', croppedImg);
          formData.append('left', data.x);
          formData.append('top', data.y);
          formData.append('width', data.width);
          formData.append('height', data.height);
          formData.append('description', $croppedImgDescription.val());
          Pace.track(function(){
            $.ajax({
              url:decodeURIComponent(']]>{$global:solutionName}/<![CDATA[process/beschaffung/drittlizenzen/start/'+pid+'/]]>{$ProcessInstanceId}?provider=datastore/images%26productid={session:get("productId")}{if($TokenId) then"%26tokenId="||$TokenId else ()}<![CDATA[%26random=' + Math.random()),
              method: "POST",
              data: formData,
              processData: false,
              contentType: false,
              complete: function(response) {
                handleAjaxResponse("",response,{restxq:true});
              }
            });
          });
        }
      });
    ]]></script>
  )
};
