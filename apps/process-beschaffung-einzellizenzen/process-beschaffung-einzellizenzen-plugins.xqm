module namespace _ = "process/beschaffung/einzellizenzen";

import module namespace feindaten-beschaffen = "process/beschaffung/einzellizenzen/feindaten-beschaffen" at "custom-tasks/feindaten-beschaffen-UserTask_1cnxzk0.xqm";
import module namespace rechte-klären = "process/beschaffung/einzellizenzen/rechte-klären" at "custom-tasks/rechte-klären-UserTask_1tl1mrv.xqm";
import module namespace titelinformation-aus-datenbank-lesen = "process/beschaffung/einzellizenzen/titelinfo-aus-db-lesen" at "custom-tasks/titelinformation-aus-datenbank-lesen-ScriptTask_0lkc7sc.xqm";
import module namespace bestellung-formulieren = "process/beschaffung/einzellizenzen/bestellung-formulieren" at "custom-tasks/bestellung-formulieren-UserTask_0ieifba.xqm";
import module namespace vertrag-pruefen-rechte-abgleichen-und-hochladen = "process/beschaffung/einzellizenzen/vertrag-pruefen-rechte-abgleichen-und-hochladen" at "custom-tasks/vertrag-pruefen-rechte-abgleichen-und-hochladen-UserTask_1ug0pge.xqm";
import module namespace lizenzgeber-recherchieren = "http://influx.adesso.de/modules/process-beschaffung-einzellizenzen/lizenzgeber-recherchieren" at "custom-tasks/lizenzgeber-recherchieren-und-anfrage-stellen-UserTask_0wrajtt.xqm";
import module namespace fremd-und-drittrechte-markieren = "process/beschaffung/einzellizenzen/fremd-und-drittrechte-markieren" at "custom-tasks/fremd-und-drittrechte-markieren-UserTask_11j7sz3.xqm";
import module namespace vertrag-versenden = "process/beschaffung/einzellizenzen/vertrag-versenden" at "custom-tasks/vertrag-versenden-UserTask_0ksjl7w.xqm";
import module namespace rechtliche-metadten-ergaenzen = "process/beschaffung/einzellizenzen/rechtliche-metadaten-ergaenzen" at "custom-tasks/rechtliche-metadaten-ergaenzen-UserTask_0qcil25.xqm";
import module namespace info-an-red = "process/beschaffung/einzellizenzen/info-an-red" at "custom-tasks/info-an-red-bildrechte-UserTask_11hpcwi.xqm";

declare namespace rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#';
declare namespace et='http://ns.exiftool.ca/1.0/'; 
declare namespace toolkit='Image::ExifTool 10.01';
declare namespace ExifTool='http://ns.exiftool.ca/ExifTool/1.0/';
declare namespace System='http://ns.exiftool.ca/File/System/1.0/';
declare namespace File='http://ns.exiftool.ca/File/1.0/';
declare namespace JFIF='http://ns.exiftool.ca/JFIF/JFIF/1.0/';
declare namespace IFD0='http://ns.exiftool.ca/EXIF/IFD0/1.0/';
declare namespace ExifIFD='http://ns.exiftool.ca/EXIF/ExifIFD/1.0/';
declare namespace Photoshop='http://ns.exiftool.ca/Photoshop/Photoshop/1.0/';
declare namespace ICC-header='http://ns.exiftool.ca/ICC_Profile/ICC-header/1.0/';
declare namespace ICC_Profile='http://ns.exiftool.ca/ICC_Profile/ICC_Profile/1.0/';
declare namespace ICC-view='http://ns.exiftool.ca/ICC_Profile/ICC-view/1.0/';
declare namespace ICC-meas='http://ns.exiftool.ca/ICC_Profile/ICC-meas/1.0/';
declare namespace Composite='http://ns.exiftool.ca/Composite/1.0/';
declare namespace inflow='http://influx.adesso.de/metadata';

import module namespace global = 'influx/global';
import module namespace plugin = 'influx/plugin';
import module namespace ui = 'influx/ui';
import module namespace util = 'influx/ui/process';
import module namespace request = "http://exquery.org/ns/request";
import module namespace session = 'http://basex.org/modules/session';

declare namespace bpmn = "http://www.omg.org/spec/BPMN/20100524/MODEL";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace meta = 'http://influx.adesso.de/metadata';

declare variable $_:name := "process-beschaffung-einzellizenzen"; (: module folder name :)
declare variable $_:staticPath := global:generateStaticPath(file:base-dir());
declare variable $_:staticDir := $global:moduleDir||"/"||$_:name||"/static";
declare variable $_:mediaProvider := "datastore/images";
declare variable $_:definitionId := "id-da186804-08f8-42fa-8548-fc75f3bf354b"; (: definition ID for Einzellizenzierung durchführen process :)

declare variable $_:asset-muster := "DataObjectReference_1hqrrcm";
declare variable $_:manuskript := "DataObjectReference_1h9s671";
declare variable $_:vertrag := "DataObjectReference_1c7l1do";
declare variable $_:standardvertragsvorlage := "DataObjectReference_0fj3ko6";
declare variable $_:asset-feindaten := "DataObjectReference_1sgwzn4";
declare variable $_:titelinformationen := "DataObjectReference_0vql52u";

declare variable $_:bestellung-formulieren := "UserTask_0ieifba";


(: Thumbnail for "einzellizenz prozess" is the thumb rendition of the dataobject "asset-muster" :)
declare %plugin:provide('token/ui/process/thumb', 'id-da186804-08f8-42fa-8548-fc75f3bf354b')
function _:task-thumb-einzellizenzen($Token){
 plugin:lookup('token/ui/dataobject/thumb')!.($Token,$_:asset-muster,100,100)
};



(: Standardvertragsvorlage :)
declare %plugin:provide('dataobject/get', 'DataObjectReference_0fj3ko6')
function _:staticProvideForDataObjectReference_0fj3ko6($Token, $DataObjectId){
    if ($DataObjectId != "DataObjectReference_0fj3ko6")
    then error("Trying to get default object with conflicting id.")
    else file:read-binary($_:staticDir || '/StandardVertrag.doc')
};

(: Standardvertragsvorlage meta :)
declare %plugin:provide('dataobject/get/meta','DataObjectReference_0fj3ko6')
function _:staticProvideMetaForDataObjectReference_0fj3ko6($Token,$DataObjectId)
as element(meta:meta)
{
 <meta:meta id="DEFAULT-STATIC">
        <meta:createdAt>{current-dateTime()}</meta:createdAt>
        <meta:filename>StandardVertrag.doc</meta:filename>
        <meta:filenameExtensionIconUrl>/static/inflow/icon/doc.svg</meta:filenameExtensionIconUrl>
        <meta:name>StandardVertrag</meta:name>
        <meta:content-type>application/vnd.openxmlformats-officedocument.wordprocessingml.document</meta:content-type>
    </meta:meta>
};

declare %plugin:provide("process/beschaffung/einzellizenzen/id")
function _:get-id() {
  $_:definitionId
};

declare %plugin:provide("process/beschaffung/einzellizenzen/ui")
function _:render-page-content($Product as element(Produkt))
  as element(xhtml:div)
{
<div xmlns="http://www.w3.org/1999/xhtml">
  <div class="row">
      <div class="col-md-12">
            <div class="col-md-5 text-center m-t-md">
              <a id="{$_:name}-start-process-instance" class="btn btn-primary ajax m-t-md" data-method="post" href="{$global:solutionName}/process/beschaffung/einzellizenzen/start?provider={$_:mediaProvider}&amp;productid={$Product/*:Produktnummer/string()}">Einzellizenzanfrage starten</a>
            </div>
            <div class="col-md-2 m-t-md">
            <label class="m-t-md"><strong>ODER</strong></label>
            </div>
            <div class="col-md-5">
              <div class="dz-message">
                  <h4 class="text-center">Medium hier fallen lassen <i class="fa fa-upload"></i></h4>
              </div>
                <div class="dropzone dz-clickable ajax" id="{$_:name}-dropzone" style="min-height:20px;padding:0px;margin:0px 0px 20px 0px;">
                    <script src="{$_:staticPath}/js/script.js"></script>
                    <script type="text/javascript">
                        Dropzone.autoDiscover = false;
                        initDropzone("singleLicenceDropzone",
                        "div#{$_:name}-dropzone",
                        "{$global:solutionName}/process/beschaffung/einzellizenzen/start?provider={$_:mediaProvider}%26productid={$Product/*:Produktnummer/string()}");
                        
                       // Urls that are ignored for dropzones with gui
                       Pace.options.ajax.ignoreURLs.push('{$global:solutionName}/process/beschaffung/einzellizenzen/start');
                    </script>
                </div>
            </div>
      </div>
  </div>
</div>
};

declare %restxq:path("process/beschaffung/einzellizenzen/start")
        %restxq:query-param("provider", "{$ProviderId}")
        %restxq:query-param("productid", "{$ProductId}")
        %restxq:POST
        %restxq:form-param("file", "{$files}")
%updating function _:upload-media-req($ProviderId as xs:string, $ProductId as xs:string, $files)
as element(xhtml:table)
{
      let $rulesProvider := "http://influx.adesso.de/engine/bpmn"
      let $processInstanceProvider := "http://influx.adesso.de/datastore/process-instances"
      let $processDefinitionProvider := "http://influx.adesso.de/datastore/definition"
      let $processDefinition :=  plugin:provider-lookup($processDefinitionProvider,"definition")!.($_:definitionId)
    
      let $userId := session:get("user")
    return
    if (exists($files)) then
      for $name in map:keys($files)
      let $content := $files($name)
      return
        if($processDefinition) then
          let $processInstanceName := "Einzellizenzierung durchführen - "||$name
          let $newPI := plugin:provider-lookup('http://influx.adesso.de/modules/bpmn-instances-manager/processinstance',"instance/new")!.(
            $rulesProvider,
            $processInstanceName,
            $processInstanceProvider,
            $processDefinitionProvider,
            $processDefinition)
          let $newPI := plugin:lookup("instance/extend/attribute")($newPI,"ProductId",$ProductId)
          let $newPI := plugin:lookup("instance/start")($newPI, $userId)
          let $activeToken:=$newPI//*:Token[@ActivityId=$_:bestellung-formulieren][@Status="unassigned"]
          let $processInstanceId := $newPI/@Id/string()
          let $write-asset-muster := 
            plugin:lookup("dataobject/put")
                         !.($activeToken,$_:asset-muster,$content)
          (:let $meta :=
            plugin:lookup("dataobject/create/rendition")
                         !.($activeToken,$_:asset-muster,"thumb"):)
          let $do-meta:= plugin:lookup("image/meta/extract")!.($content)
          let $do-meta:= copy $x:=$do-meta modify replace value of node $x//System:FileName with $name return $x
          let $meta := plugin:lookup("dataobject/put/meta")!.($activeToken, $_:asset-muster, $do-meta)

          let $assign := plugin:lookup("instance/token/reassign")!.($activeToken,$userId,$userId)
          return
            <table xmlns="http://www.w3.org/1999/xhtml">
              {
                (
                plugin:lookup("bpmn/instance/render/prepend")!.($newPI,$meta,"animated fadeInRight once")
                ,ui:info("Der Beschaffungsprozess für die Einzellizenz ist gestartet.")
               )
              }
            </table>
         else
          <table xmlns="http://www.w3.org/1999/xhtml">
            {ui:error("Die Prozessdefinition existiert nicht.")}
          </table>
    else 
        if($processDefinition) then
          let $processInstanceName := "Einzellizenzierung durchführen - "
          let $newPI := plugin:provider-lookup('http://influx.adesso.de/modules/bpmn-instances-manager/processinstance',"instance/new")!.(
            $rulesProvider,
            $processInstanceName,
            $processInstanceProvider,
            $processDefinitionProvider,
            $processDefinition)
          let $newPI := plugin:lookup("instance/extend/attribute")($newPI,"ProductId",$ProductId)
          let $newPI := plugin:lookup("instance/start")($newPI, $userId)
          let $activeToken:=$newPI//*:Token[@ActivityId=$_:bestellung-formulieren][@Status="unassigned"]
          let $assign := plugin:lookup("instance/token/reassign")!.($activeToken,$userId,$userId)
          let $newPI := plugin:lookup("instance")!.($newPI/@Id)
          return
            <table xmlns="http://www.w3.org/1999/xhtml">
              {
                (
                plugin:lookup("bpmn/instance/render/prepend")!.($newPI,(),"animated fadeInRight once")
                ,<a id="{$_:name}-start-process-instance" class="btn btn-primary ajax m-t-md" data-method="post" href="{$global:solutionName}/process/beschaffung/einzellizenzen/start?provider={$_:mediaProvider}&amp;productid={$ProductId}" data-replace="#{$_:name}-start-process-instance">Einzellizenzanfrage starten</a>
                ,ui:info("Der Beschaffungsprozess für die Einzellizenz ist gestartet.")
               )
              }
            </table>
         else
          <table xmlns="http://www.w3.org/1999/xhtml">
             <a id="{$_:name}-start-process-instance" class="btn btn-primary ajax m-t-md" data-method="post" href="{$global:solutionName}/process/beschaffung/einzellizenzen/start?provider={$_:mediaProvider}&amp;productid={$ProductId}" data-replace="#{$_:name}-start-process-instance">Einzellizenzanfrage starten</a>
            ,{ui:error("Die Prozessdefinition existiert nicht.")}
          </table>
};

declare %restxq:path("process/beschaffung/einzellizenzen/delete/{$ProcessInstanceId}")
        %restxq:query-param("provider", "{$ProviderId}", "")
        %restxq:GET
        %output:method("xhtml")
%updating function _:delete-media-req($ProviderId as xs:string, $ProcessInstanceId as xs:string)
as element(xhtml:table)
{
  let $instance := plugin:provider-lookup('http://influx.adesso.de/modules/bpmn-instances-manager/processinstance',"instance")!.($ProcessInstanceId)
  let $delete := plugin:lookup("instance/delete")($instance/@ProcessInstanceId)
  return(
     plugin:lookup("bpmn/instance/render/prepend")!.($instance,(),"animated fadeOutRight burnAfterReading")
    ,ui:info("Der Beschaffungsprozess für die Einzellizenz wurde gelöscht.")
    )

};

(: bricht einen "Einzellizenzierung durchführen"-Prozess ab :)
declare %restxq:path("beschaffung/einzellizenzen/cancel/{$ProductId}")
        %rest:query-param("pid","{$ProcessInstanceId}")
function _:cancel-process-instanc($ProductId as xs:string, $ProcessInstanceId as xs:string)
{
  (: delete created process :)
  let $deletePI := plugin:lookup("instance/delete")($ProcessInstanceId)

  return (
     plugin:lookup("bpmn/instance/render/prepend")!.($deletePI,(),"animated fadeOutRight burnAfterReading")
     ,ui:info("der 'Einzellizenzierung durchführen'-Prozess wurde abgebrochen")
  )
};
(: /bricht einen "Einzellizenzierung durchführen"-Prozess ab :)


declare %plugin:provide('instance/transform/script', 'ScriptTask_0lkc7sc')
function _:script-get-titleinfo($Token, $Class as xs:string?, $Action){
    let $processInstance := plugin:lookup("instance")!.($Token/@ProcessInstanceId)
    let $titelinfo := plugin:lookup("influx/product")!.($processInstance/@ProductId)
    return plugin:lookup("dataobject/put")($Token,"DataObjectReference_0wlonxo",$titelinfo)
};