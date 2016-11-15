module namespace _ = "process/beschaffung/einzellizenzen/bestellung-formulieren";
import module namespace global = 'influx/global';
import module namespace plugin = 'influx/plugin';
import module namespace ui = 'influx/ui';
import module namespace util = 'influx/ui/process';
import module namespace request = "http://exquery.org/ns/request";
import module namespace session = 'http://basex.org/modules/session';
import module namespace einzel = "process/beschaffung/einzellizenzen" at "../process-beschaffung-einzellizenzen-plugins.xqm";


declare namespace bpmn = "http://www.omg.org/spec/BPMN/20100524/MODEL";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace meta = 'http://influx.adesso.de/metadata';

declare variable $_:asset-muster := "DataObjectReference_1hqrrcm";
declare variable $_:manuskript := "DataObjectReference_1h9s671";
declare variable  $_:dataObjectIdForTitleInfo := "DataObjectReference_0vql52u";
(:declare variable $_:profile-db-name := collection('profiles');:)


(: UserTask: Bestellung formulieren View :)
declare %plugin:provide("token/ui/tasklist/content/tabs", "UserTask_0ieifba")
function _:formulateOrder($ProcessInstance, $Token)
{  
  let $instance-name := $ProcessInstance/@Name/string()
  let $definition := plugin:provider-lookup($ProcessInstance/@ProcessDefinitionProvider, "definition")($ProcessInstance/@ProcessDefinitionId)
  let $activity := $definition//bpmn:*[@id = $Token/@ActivityId]
  let $activity-name := $activity/@name/string()
  let $ProviderId := $einzel:mediaProvider
  let $ProcessInstanceId := $ProcessInstance/@Id/string()
  let $titleInfo := plugin:lookup('dataobject/get')($Token, $_:dataObjectIdForTitleInfo)/*:Produkt

  (: filenamePrefix zusammenbauen :)
  let $userId := session:get("user")
  (:let $user := $_:profile-db-name[//Name = $userId][1]
  let $lastName := substring($user/*:user/*:LastName/string(), 1, 4)
  let $firstName := substring($user/*:user/*:FirstName/string(), 1, 2):)
  (: Datum aus dem "Bestellung formulieren Token" :)
  let $created-date := $Token/@Opened/string()
  let $yy := substring($created-date,3,2)
  let $MM := substring($created-date,6,2)
  let $dd := substring($created-date,9,2)

  let $filenamePrefix :=  $userId||"_"||$yy||$MM||$dd||"_001_"
  return    
    <tabs>
      <tab status="">
        <title>Titelinfo</title>
        <content>
          {plugin:lookup('influx/product/view')($titleInfo)}
        </content>
      </tab>
      <tab status="active">
        <title>Bestellung</title>
        <content>
          {_:render-asset-order-form($titleInfo, $ProcessInstance, $Token)}
        </content>
      </tab>
      <tab status="">
        <title>Asset-Muster</title>
        <content>
          {_:render-asset-filename-form($titleInfo, $ProcessInstance, $Token)}
        </content>
      </tab>
      <tab status="">
        <title>Manuskriptseite</title>
        <content>
          {_:render-manuskript-upload($titleInfo, $ProcessInstance, $Token)}
        </content>
      </tab>
      <tab status="">
        <title>Wiederverwendung</title>
        <content>
          {_:render-asset-reuse-form($titleInfo, $ProcessInstance, $Token)}
        </content>
      </tab>
      <tab status="">
        <title>Kollektion</title>
        <content>
          {_:render-collection(plugin:lookup("influx/product")!.($ProcessInstance/@ProductId), (), (), ())}
        </content>
      </tab>
      <tab status="">
        <title>Dateiname</title>
        <content>
          <form xmlns="http://www.w3.org/1999/xhtml" method="post" class="influx-form" action="#">
            { plugin:lookup("einzellizenzen/feindaten-beschaffen/render_filename_inputs")!.($filenamePrefix, ".xxx", $titleInfo/*:Beschaffung/*:filename/string()) }
          </form>
        </content>
      </tab>
    </tabs>
};
(: /Bestellung formulieren View :)

declare function _:render-asset-reuse-form($Product as element(Produkt), $ProcessInstance as element(ProcessInstance), $Token as element(Token)) {
  <div class="row">
    <div class="col-md-12">
      <!--<div class="col-md-4 col-md-offset-8">
        <div class="input-group m-b input-round" style="margin-top:20px">
          <input type="text" placeholder="Produkte suchen" class="form-control input-sm" name="search"/>
          <span class="input-group-btn">
            <button class="btn btn-primary btn-sm"><i class="fa fa-search"></i></button>
          </span>
        </div>
      </div>   -->
      <form xmlns="http://www.w3.org/1999/xhtml" method="post" class="influx-form" action="#">
          <label class="control-label">Für folgende Bestandteile lizenzieren:</label>
          {plugin:lookup("influx/product/relation/form")!.($Product)}
      </form>
    </div>
  </div>
};

declare function _:render-asset-order-form($Product as element(Produkt), $ProcessInstance as element(ProcessInstance), $Token as element(Token))
as element()
{  
  <form xmlns="http://www.w3.org/1999/xhtml" method="post" class="influx-form" action="#">
    <div class="row">
      <link href="{$ui:path}css/plugins/iCheck/custom.css" rel="stylesheet"/>
      <div class="col-lg-12">
        <div class="ibox float-e-margins">
              <div class="col-md-6">
                <label class="control-label">Urheber</label>
                <input name="Asset-Urheber" type="text" class="form-control" placeholder="Fotograf bzw. Illustrator" value="{$Product/*:Beschaffung/*:Asset-Urheber/string()}"/>
              </div>
              <div class="col-md-6">
                <label class="control-label">Asset-Typ</label>
                {
                  _:select($Product,"Asset-Typ",map{"Sonstige":"Sonstige","Foto":"Foto","Illustration":"Illustration","Grafiken":"Grafiken","Cartoon":"Cartoon","Coverabbildung":"Coverabbildung","Packshot":"Packshot","Plakat":"Plakat","Karte":"Karte","Collage":"Collage","Screenshot":"Screenshot","Filmstill":"Filmstill","Text":"Text","Liedtext":"Liedtext","Noten":"Noten","Audio":"Audio","Video":"Video"})
                }
                <input name="Sonstiger-Asset-Typ" value="{$Product/*:Beschaffung/*:Sonstiger-Asset-Typ/string()}" class="form-control m-b" placeholder="Sonstiger Asset-Typ"/>
              </div>
            </div>
              <div class="col-md-6">
                <label class="control-label">Anbieter*</label>
                <input name="Asset-Agentur" type="text" class="form-control" required="required" value="{$Product/*:Beschaffung/*:Asset-Agentur/string()}"/>
              </div>
              <div class="col-md-6">
                <label class="control-label">Position auf der Seite</label>
                {
                  _:select($Product,"Asset-Position-Auf-Seite",map{"Mitte rechts":"mi.re.","Mitte links":"mi.li.","Oben rechts":"ob.re.","Oben links":"ob.li.","Unten rechts":"un.re.","Unten links":"un.li."})
                }
              </div>
  
              <div class="col-md-6">
                <label class="control-label">Fundstelle</label>
                <input name="Asset-Referenz" type="text" class="form-control m-b" value="{$Product/*:Beschaffung/*:Asset-Referenz/string()}"/>
              </div>
              <div class="col-md-6">
                <label class="control-label">Kapitel</label>                
                <input name="Asset-Kapitel" type="text" class="form-control m-b" value="{$Product/*:Beschaffung/*:Asset-Kapitel/string()}"/>
                {(:
                  _:select($Product,"Asset-Kapitel",map{"Kapitel 1":"1","Kapitel 2":"2","Kapitel 3":"3","Einleitung":"0"})
                :)}
              </div>
  
              <div class="col-md-6">
                <label class="control-label">Motiv/Beschreibung</label>
                <textarea name="Asset-Beschreibung" class="form-control" rows="3">{$Product/*:Beschaffung/*:Asset-Beschreibung/string()}</textarea>
              </div>
              <div class="col-md-6">
                <label class="control-label">Seite</label>
                <input name="Asset-Seite" type="text" class="form-control" value="{$Product/*:Beschaffung/*:Asset-Seite/string()}"/>
              </div>
  
  
      </div>
      <script src="{$ui:path}js/plugins/iCheck/icheck.min.js"/>
      <script src="{$ui:path}js/plugins/chosen/chosen.jquery.js"/>
    </div>
  </form>
};

declare function _:select($Product as element(Produkt), $Name as xs:string,$Values as map(*)){
let $field := $Product/*:Beschaffung/*[local-name()=$Name]/string()
return
  <select name="{$Name}" class="form-control m-b">
    {
      for $option in map:keys($Values)
      let $value := map:get($Values,$option)
      return
       <option value="{$value}">
        {if ($field = $value) then attribute selected {"selected"} else ()} {$option}
       </option>
    }         
  </select>
};

declare function _:render-asset-filename-form($Product as element(Produkt), $ProcessInstance as element(ProcessInstance), $Token as element(Token))
as element()
{
  <div class="row">
    <link href="{$ui:path}css/plugins/iCheck/custom.css" rel="stylesheet"/>
    <div class="col-md-12">
    <div class="col-lg-3">
      <label class="control-label">Asset-Muster</label>
      {
        let $dataobject := $ProcessInstance//bpmn:dataObjectReference[@id = $_:asset-muster] (: TODO use better means! :)
        return (
          plugin:lookup("dataobject/write/ui",$_:asset-muster)!.($Token, $dataobject)
        )
      }
    </div>
    <div class="col-lg-6"><h4>Beschreibung:</h4><div>Wenn Sie noch kein Muster hochgeladen haben, können Sie dies hier nachholen. Sie können einfach per drag &amp; drop ein Datei hochladen, die dem Linzenzierer helfen soll, das richtige Asset für Sie zu finden. </div></div>
    </div>
  </div>
};

declare function _:render-manuskript-upload($Product as element(Produkt), $ProcessInstance as element(ProcessInstance), $Token as element(Token))
as element()
{
  <div class="row">
    <link href="{$ui:path}css/plugins/iCheck/custom.css" rel="stylesheet"/>
    <div class="col-md-12">
    <div class="col-lg-3">
      <label class="control-label">Manuskriptseite</label>
      {
        let $dataobject := $ProcessInstance//bpmn:dataObjectReference[@id = $_:manuskript] (: TODO use better means! :)
        return (
          plugin:lookup("dataobject/write/ui",$_:manuskript)!.($Token, $dataobject)
        )
      }
    </div>
    <div class="col-lg-6"><h4>Beschreibung:</h4><div>Bitte laden Sie die Seite des Manuskriptes hoch, auf dem das Medium platziert werden soll. </div></div>
    </div>
  </div>
};

declare function _:render-collection($Product as element(Produkt), $ChosenCollection as xs:string?, $Class as xs:string?, $Action as item()*) {
  <div id="render-collection-tab" class="row{if ($Class) then ' ' || $Class else ()}">{$Action}
    <div class="col-md-12">
      <div class="col-md-6">      
        <form xmlns="http://www.w3.org/1999/xhtml" method="post" class="influx-form" action="#">
          <label class="control-label">Kollektion</label>
          <select name="asset-chapter" class="form-control m-b" required="required">
            <option value=""></option>{
            for $collection in $Product/*:Kollektionen/*:Kollektion/string()
            return
              if ($ChosenCollection = $collection) then
                <option value="{$collection}" selected="selected">{$collection}</option>
              else
                <option value="{$collection}">{$collection}</option>
          }</select>
        </form>
      </div>
      <div class="col-md-5">
        <label class="control-label">Kollektion hinzufügen</label>
        <input id="new-collection-input" type="text" placeholder="Name der Kollektion" class="form-control" name="collection" onkeyup="
          var text = $(this).val();
          if(text == '')
            $('#render-collection-tab #new-collection-button').addClass('disabled');
          else {{
            $('#render-collection-tab #new-collection-button').removeClass('disabled');
            var regex = new RegExp('^[0-9a-zA-ZäÄöÖüÜ_\.]*$'); 
            if(!regex.test(text)) {{
              $(this).val(fitInputText(text,'[0-9a-zA-ZäÄöÖüÜ_\.]'))              
            }}              
          }}
        "/>
      </div>
      <div class="col-md-1 btn-sm">
        <a id="new-collection-button" href="{$global:solutionName}/process/beschaffung/einzellizenzen/collection/new" class="btn btn-primary btn-sm m-t-md ajax disabled" onclick="$(this).attr('href', $(this).attr('href') + '?productId={$Product/Produktnummer/string() || '&amp;'}collection=' + $('#render-collection-tab #new-collection-input').val())">Hinzufügen</a>
      </div>
    </div>
  </div>
};

declare %restxq:path("process/beschaffung/einzellizenzen/collection/new")
%restxq:query-param("collection", "{$Collection}")
%restxq:query-param("provider", "{$ProviderId}")
%restxq:query-param("productId", "{$ProductId}")
%restxq:GET
%output:method("xhtml")
%updating function _:new-collection($ProviderId as xs:string?, $ProductId as xs:string, $Collection as xs:string) {
  let $product := plugin:lookup("influx/product")!.($ProductId)
  return
    if ($product/*:Kollektionen) then
      if ($product/*:Kollektionen/*:Kollektion/string() = $Collection) then
        ui:info("Kollektion existiert bereits.")
      else
        let $product := $product update insert node <Kollektion>{$Collection}</Kollektion> into ./*:Kollektionen
        return (
          plugin:lookup("influx/product/put")!.($product)
          , _:render-collection($product, $Collection, (), attribute data-replace {"#render-collection-tab"})
          , ui:info("Neue Kollektion angelegt.")
        )
    else
      let $product := $product update insert node <Kollektionen><Kollektion>{$Collection}</Kollektion></Kollektionen> into .
      return (
        plugin:lookup("influx/product/put")!.($product)
        , _:render-collection($product, $Collection, (), attribute data-replace {"#render-collection-tab"})
        , ui:info("Neue Kollektion angelegt.")
      )
};


declare %plugin:provide("token/button/cancel","UserTask_0ieifba")
function _:token-button-cancel($Token as element(Token)){
  plugin:lookup("token/button/cancel/disabled")!.()
};


(:  save handler :)

declare %plugin:provide("bpmn/token/save/active","UserTask_0ieifba")
function _:save-declare-order-form($Token as element(Token), $ProcessInstance as element(ProcessInstance), $Parameters as map(*)){
  let $titleInfo := plugin:lookup('dataobject/get')($Token, $_:dataObjectIdForTitleInfo)/*:Produkt
  let $bestellung := <Beschaffung>
                      {
                        for $key in map:keys($Parameters)
                        return map:get($Parameters,$key) ! element {$key} {.}
                      }
                     </Beschaffung>
  let $titleInfo := copy $x:=$titleInfo
                    modify 
                      if ($x/Beschaffung) 
                      then replace node $x/Beschaffung with $bestellung
                      else insert node $bestellung into $x
                    return $x
  return
    (
      plugin:lookup('dataobject/put')($Token, $_:dataObjectIdForTitleInfo, $titleInfo )
      ,ui:info("Bestellung formulieren gespeichert.")
    )
};