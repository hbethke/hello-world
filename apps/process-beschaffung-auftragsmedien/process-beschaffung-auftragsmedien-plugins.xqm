module namespace _="process/beschaffung/auftragsmedien";
import module namespace global  ='influx/global';
import module namespace plugin='influx/plugin';
import module namespace ui    ='influx/ui';

import module namespace session = 'http://basex.org/modules/session';
import module namespace request = "http://exquery.org/ns/request";

import module namespace form = "process/beschaffung/auftragsmedien/media/order/form" at "media-order-form.xqm";

declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace meta='http://influx.adesso.de/metadata';

declare variable $_:dl-liste := "DataObjectReference_126uh6j";

declare variable $_:name := "process-beschaffung-auftragsmedien"; (: module folder name :)
declare variable $_:staticPath := global:generateStaticPath(file:base-dir());
declare variable $_:staticDir := $global:moduleDir||$_:name||"/static";

declare variable $_:definitionId := ("Auftragsmedien_beschaffen"); (: definition ID for Auftragmedien beschaffen process :)

declare %plugin:provide('dataobject/get','DataObjectReference_126uh6j')
function _:staticProvideForDataObjectReference_126uh6j($Token,$DataObjectId){
  if ($DataObjectId !="DataObjectReference_126uh6j")
    then error("Trying to get default object with conflicting id.")
    else file:read-binary($_:staticDir||'/Dienstleister-Liste.xlsx')
};

declare %plugin:provide('dataobject/get/meta','DataObjectReference_126uh6j')
function _:staticProvideMetaForDataObjectReference_126uh6j($Token,$DataObjectId)
as element(meta:meta){
 <meta:meta id="DEFAULT-STATIC">
        <meta:createdAt>{current-dateTime()}</meta:createdAt>
        <meta:filename>Dienstleister-Liste.xlsx</meta:filename>
        <meta:filenameExtensionIconUrl>/static/inflow/icon/xlsx.svg</meta:filenameExtensionIconUrl>
        <meta:name>Dienstleister-Liste</meta:name>
        <meta:content-type>application/vnd.openxmlformats-officedocument.spreadsheetml.sheet</meta:content-type>
 </meta:meta>
};

declare %plugin:provide("process/beschaffung/auftragsmedien/ui")
function _:render-page-content(
    $Product as element(Produkt))
  as element(xhtml:div) {
  <div xmlns="http://www.w3.org/1999/xhtml">
    <div class="tabs-container">
      <div class="tabs-left">
        <ul class="nav nav-tabs">
          <li class="active">
            <a data-toggle="tab" href="#tab-new-photo-order" aria-expanded="true">
              <i class="fa fa-picture-o" aria-hidden="true"></i>
            </a>
          </li>
          <li class="">
            <a data-toggle="tab" href="#tab-new-illustration-order" aria-expanded="true">
              <i class="fa fa-paint-brush" aria-hidden="true"></i>
            </a>
          </li>
          <li class="">
            <a data-toggle="tab" href="#tab-new-audio-order" aria-expanded="true">
              <i class="fa fa-volume-up" aria-hidden="true"></i>
            </a>
          </li>
          <li class="">
            <a data-toggle="tab" href="#tab-new-video-order" aria-expanded="true">
              <i class="fa fa-video-camera" aria-hidden="true"></i>
            </a>
          </li>
        </ul>
        <div class="tab-content ">
          <div id="tab-new-photo-order" class="tab-pane active">
            <div class="panel-body">
              {form:render-photo-order-form($Product,(),())}
            </div>
          </div>
          <div id="tab-new-illustration-order" class="tab-pane">
            <div class="panel-body">
              {form:render-illustration-order-form($Product,(),())}
            </div>
          </div>
          <div id="tab-new-audio-order" class="tab-pane">
            <div class="panel-body">
              {form:render-audio-order-form($Product,(),())}
            </div>
          </div>
          <div id="tab-new-video-order" class="tab-pane">
            <div class="panel-body">
              {form:render-video-order-form($Product,(),())}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
};

declare %restxq:path("process/beschaffung/auftragsmedien/start/order/video")
        %restxq:query-param("provider", "{$ProviderId}", "")
        %restxq:query-param("productid", "{$ProductId}")
        %restxq:GET
%updating function _:start-process-instance(
    $ProviderId as xs:string,
    $ProductId as xs:string)
  as element(xhtml:table) {
  let $order :=
    <Bestellung>
      {
        for $param-name in request:parameter-names()
        let $param-value := request:parameter($param-name)
        return element {$param-name}{$param-value}
      }
    </Bestellung>
  let $processInstanceName := plugin:lookup("contractor/name")!.($order/*:Auftragnehmer)
  
  let $rulesProvider := "http://influx.adesso.de/engine/bpmn"
  let $processInstanceProvider := "http://influx.adesso.de/datastore/process-instances"
  let $processDefinitionProvider := "http://influx.adesso.de/datastore/definition"
  let $processDefinition :=  plugin:provider-lookup($processDefinitionProvider,"definition")!.($_:definitionId)
  
  let $userId := session:get("user")
  
  return
    if($processDefinition) then
      let $id := random:uuid()
      let $dbpath := $ProductId || "/assets/{$id}"
      let $meta := <meta:meta id="{$id}">
        <meta:createdAt>{current-dateTime()}</meta:createdAt>
          <meta:filename>/static/icons/image/svg/design/ic_camera_alt_48px.svg</meta:filename>
          <meta:filenameExtensionIconUrl>icons/image/svg/design/ic_camera_alt_48px.svg</meta:filenameExtensionIconUrl>
        </meta:meta>
      let $save := plugin:lookup("media/meta/put")!.($dbpath,$meta)
      
      let $newPI := plugin:provider-lookup('http://influx.adesso.de/modules/bpmn-instances-manager/processinstance',"instance/new")!.(
        $rulesProvider,
        $processInstanceName,
        $processInstanceProvider,
        $processDefinitionProvider,
        $processDefinition)

      let $newPI := plugin:lookup("instance/extend/attribute")($newPI,"ProductId",$ProductId)
      let $newPI := plugin:lookup("instance/extend/attribute")($newPI,"AssetId",$meta/@id)
      let $newPI := plugin:lookup("instance/start")($newPI, $userId)
      return
        <table xmlns="http://www.w3.org/1999/xhtml">
          {
            plugin:lookup("bpmn/instance/render/prepend")!.($newPI,$meta,"animated fadeInRight once")
            ,ui:info("Der Beschaffungsprozess für die Auftragmedien ist gestartet.")
          }
        </table>
     else
      <table xmlns="http://www.w3.org/1999/xhtml">
        {ui:error("Die Prozessdefinition existiert nicht.")}
      </table>
};