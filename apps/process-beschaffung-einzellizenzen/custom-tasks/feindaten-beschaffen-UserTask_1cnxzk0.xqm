module namespace _ = "process/beschaffung/einzellizenzen/feindaten-beschaffen";

import module namespace global = 'influx/global';
import module namespace plugin = 'influx/plugin';
import module namespace ui = 'influx/ui';
import module namespace util = 'influx/ui/process';
import module namespace request = "http://exquery.org/ns/request";
import module namespace session = 'http://basex.org/modules/session';
import module namespace functx = "http://www.functx.com";

declare namespace bpmn = "http://www.omg.org/spec/BPMN/20100524/MODEL";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace meta = 'http://influx.adesso.de/metadata';
declare namespace htm ="http://www.w3.org/1999/xhtml";

declare variable $_:name := "process-beschaffung-einzellizenzen"; (: module folder name :)
declare variable $_:staticPath := global:generateStaticPath(file:parent(file:base-dir()));
declare variable $_:assetDataObject := "DataObjectReference_1sgwzn4";
declare variable $_:bestellungFormulierenToken := "UserTask_0ieifba";
declare variable $_:titelinfo := "DataObjectReference_0vql52u";

(: View für Feindaten beschaffen :)
declare %plugin:provide('token/ui/tasklist/content', 'UserTask_1cnxzk0')
function _:feindaten-beschaffen($ProcessInstance as element(ProcessInstance), $Token as element(Token), $Class as xs:string?, $Action)
as element(Q{http://www.w3.org/1999/xhtml}div)
{ 
    let $definition := $ProcessInstance/Definition/*
    let $activity := $definition//bpmn:*[@id = $Token/@ActivityId]
    let $product := plugin:lookup("influx/product")!.($ProcessInstance/@ProductId)   
    let $titelinfo := plugin:lookup("dataobject/get")!.($Token,$_:titelinfo)
    let $DataOutputRefIds := $activity/bpmn:dataOutputAssociation/bpmn:targetRef/text() (: ??? :)
    let $DataObjectOutputRefs := $definition//bpmn:dataObjectReference[@id=$DataOutputRefIds]  
    let $metaData := plugin:lookup('dataobject/get/meta')($Token, $_:assetDataObject)
    let $metaFileExtension := if($metaData/*:filename) then(
        "."||substring($metaData/*:filename, functx:index-of-string($metaData/*:filename, ".") + 1)
        )else(".xxx")
    
    (: filenamePrefix zusammenbauen :)
    let $userId := session:get("user")
    (:let $user := $_:profile-db-name[//Name = $userId][1]
    let $lastName := substring($user/*:user/*:LastName/string(), 1, 4)
    let $firstName := substring($user/*:user/*:FirstName/string(), 1, 2):)
    (: Datum aus dem "Bestellung formulieren Token" :)
    let $created-date := $ProcessInstance/*:Tokens/*:Token[@Status='completed'][@ActivityId=$_:bestellungFormulierenToken]/@Opened/string()
    let $yy := substring($created-date,3,2)
    let $MM := substring($created-date,6,2)
    let $dd := substring($created-date,9,2)
    
    let $filenamePrefix :=  $userId||"_"||$yy||$MM||$dd||"_001_"
    let $filename := $titelinfo//*:filename/string()
    
    return
    (
      <div xmlns="http://www.w3.org/1999/xhtml" class="detail-view">
        <script src="{$_:staticPath}/js/script.js"></script>
        
        <div class="row">
          <div class="detail-view">
            <div class="tabs-container">
              <ul id="tabs" class="nav nav-tabs">
                <li class="">
                  <a data-toggle="tab" href="#tab-titelinfo" aria-expanded="true">
                    Titelinfo
                  </a>
                </li>
                <li class="active">
                  <a data-toggle="tab" href="#tab-feindaten" aria-expanded="true">
                    Feindaten hochladen
                  </a>
                </li>
              </ul>
              <div class="tab-content ">
                <div id="tab-titelinfo" class="tab-pane ">
                  <div class="panel-body">
                    {plugin:lookup('influx/product/view')($product)}
                  </div>
                </div>
              
                <div id="tab-feindaten" class="tab-pane active"> 
                  <div class="panel-body">             
                    <div class="row">
                      <br/><br/><br/>
                      <div class="col-md-3 text-right">
                        <label class="control-label">Bitte laden Sie hier die Feindaten hoch:</label>
                      </div>
                      <div class="col-md-9">
                        <div class="attachment">
                        {
                          for $DataObject in $DataObjectOutputRefs
                          let $fileBoxRenderer := plugin:lookup("dataobject/write/ui", $DataObject)
                          return $fileBoxRenderer!.($Token,$DataObject)
                        }
                        </div>
                      </div>
                    </div>
                    { _:render_filename_inputs($filenamePrefix, $metaFileExtension, $filename) }
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>{(: /row :)}
        
        
        { plugin:lookup("token/button/bar", $Token/@ActivityId)!.($Token) }
      
      </div>(: /detail-view :)
    )    
};


(: Inputfelder für den Dateinamen :)
declare %plugin:provide("einzellizenzen/feindaten-beschaffen/render_filename_inputs") 
function _:render_filename_inputs($FilenamePrefix as xs:string, $FileExtension as xs:string, $Value as xs:string?){
    <div class="row">
        <div class="col-md-3 text-right">
            <label class="control-label">Dateiname:</label><br/>
        </div>
        <div class="col-md-9 form-inline">
            <input type="text" class="form-control input-sm" disabled="disabled" name="filenamePrefix" id="filenamePrefix" value="{$FilenamePrefix}"/>
            <input type="text" placeholder="z.B. Kind_mit_Ball" class="form-control input-sm" name="filename" id="filename" maxlength="30" value="{$Value}"/>
            <input type="text" class="form-control input-sm" disabled="disabled" name="filenameExtension" id="filenameExtension" value="{$FileExtension}"/>
        </div>
    </div>  (: /row :)
};


(: Überschreibt den Speichern-Button :)
declare %plugin:provide("token/button/save", "UserTask_1cnxzk0")
function _:save-button($Token as element(Token)) {
    
    <a id="save_filename" class="btn btn-outline btn-primary btn-sm ajax" type="submit" href="{$global:solutionName}/feindaten-beschaffen/save-filename?tokenId={$Token/@Id/string()}">
        <i class="fa fa-floppy-o"></i>
        <span data-i18n="save">Speichern</span>
    </a>,
    <script class="rxq-js-eval">save_filename();</script>
}; 

(: Überschribt das FileDrop Feld für das Asset :)
declare %plugin:provide("dataobject/upload/request/handler","DataObjectReference_1sgwzn4-UserTask_1cnxzk0") 
function _:fileDrop($Token, $DataObject, $Html)
{    
   (
       $Html, 
       <input type="text" class="form-control input-sm" disabled="" name="filenameExtension" id="filenameExtension" value=".{functx:substring-after-last($Html//htm:span[@class='filename'],'.')}" data-replace="#filenameExtension"/>
   )
};


(: Speichert den manuell eingetippten Dateinamen in den Metadaten des Assets(Feindaten) :)
declare %restxq:path("feindaten-beschaffen/save-filename")
        %restxq:GET
        %restxq:query-param("tokenId", "{$TokenId}")
        %restxq:query-param("newFilename", "{$NewFilename}")
function _:save_filename($TokenId as xs:string, $NewFilename as xs:string)
{
    let $token := plugin:lookup("token")!.($TokenId)   
    let $metaData := plugin:lookup('dataobject/get/meta')($token, $_:assetDataObject)
    let $metaFileExtension := substring-after($metaData/*:filename, "\.")

    let $newMeta :=
        <meta:meta xmlns:meta='http://influx.adesso.de/metadata'>
            <meta:filename>{$NewFilename}.{$metaFileExtension}</meta:filename>
            {for $node in $metaData/*
            return $node}
        </meta:meta>
    
    let $dummy := plugin:lookup('dataobject/put/meta')($token, "DataObjectReference_1sgwzn4", $newMeta)
    
    return (
        ui:info("Der Dateiname wurde gespeichert.") 
    )
};


(: Cancel-Button :)
declare %plugin:provide("token/button/cancel", "UserTask_1cnxzk0") 
function _:cancel-button($Token as element(Token)){
    plugin:lookup("token/button/cancel/disabled")!.()
};
(: /Cancel-Button :)