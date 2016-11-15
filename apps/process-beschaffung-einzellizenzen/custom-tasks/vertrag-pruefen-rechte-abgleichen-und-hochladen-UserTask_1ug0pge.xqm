module namespace _ = "process/beschaffung/einzellizenzen/vertrag-pruefen-rechte-abgleichen-und-hochladen";
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
declare variable $_:staticPath := global:generateStaticPath(file:parent(file:base-dir()));
declare variable $_:staticDir := $global:homeDir||"/webapp"||$_:staticPath;
declare variable $_:mediaProvider := "datastore/images";
declare variable $_:checklistDataObject := "DataObjectReference_1xn0hak";
declare variable $_:dataObjectIdForTitleInfo := "DataObjectReference_0vql52u";

(: View für Vertrag prüfen, Rechte abgleichen und hochladen :)
declare %plugin:provide('token/ui/tasklist/content', 'UserTask_1ug0pge')
function _:renderPruefen($ProcessInstance as element(ProcessInstance), $Token as element(Token), $Class as xs:string?, $Action)
{
    let $provider := $ProcessInstance/@ProcessInstanceProvider/string()
    let $definition := $ProcessInstance/Definition/*
    let $activity := $definition//bpmn:*[@id = $Token/@ActivityId]
    let $activity-name := $activity/@name/string()
    let $instance-name := $ProcessInstance/@name/string()
    let $product := plugin:lookup("influx/product")!.($ProcessInstance/@ProductId)
    let $id := random:uuid()
    let $checklist := html:parse(file:read-text($_:staticDir||'/ChecklisteFuerVertragPruefung.xml'))/*:Checkliste  
    let $checklistData := plugin:lookup('dataobject/get')($Token, $_:checklistDataObject)/*:checklist    
    let $titleInfo := plugin:lookup('dataobject/get')($Token, $_:dataObjectIdForTitleInfo)/*:Produkt
        
    return
      <div xmlns="http://www.w3.org/1999/xhtml" class="detail-view" data-sort-key="{util:data-sort-key($ProcessInstance, $Token)}">  
          <script type="text/javascript" src="{$_:staticPath}/js/script.js"></script>    
          <div class="row">    
            <div class="col-sm-4">
              <label class="control-label">Checkliste: Ist der Vertrag in Ordnung?</label>
              {
                for $eintrag at $i in $checklist/*:Eintrag                    
                return    
                  <form id="checklist-form-{$i}" class="ajax" action="{$global:solutionName}/einzellizenzen/checklist/save?tokenId={$Token/@Id/string()}&amp;nr={$i}" method="post">
                    <div class="checkbox">
                      {
                        if($checklistData/*:checkbox[@nr[.=$i]]/string() = "true") then
                          <input name="checklist-checkbox" type="checkbox" class="checklist-checkbox" id="checklist-checkbox-{$i}" value="true" checked="checked" nr="{$i}"/>
                        else
                          <input name="checklist-checkbox" type="checkbox" class="checklist-checkbox" id="checklist-checkbox-{$i}" value="false" nr="{$i}"/>
                      }
                      <label for="checklist-checkbox-{$i}">{$checklist/*:Eintrag[$i]}</label>
                    </div>   
                  </form>    
                }                     
              </div>
              
              <div class="col-sm-8">
                  <form xmlns="http://www.w3.org/1999/xhtml" method="post" class="influx-form" action="#">
                      <div class="row form-group">
                          <div class="col-sm-6">
                              <label class="control-label">Lizenzpreis (netto)</label>
                              <input name="Lizenzpreis_netto" placeholder="19,99" type="number" min="0" step="1" max="200000" class="form-control" style="text-align:right;" value="{$titleInfo/*:Beschaffung/*:Lizenzpreis_netto/string()}"/>      
                          </div>
                          <div class="col-sm-6">
                              <label class="control-label">Mehrwertsteuer</label>
                              <input name="Mehrwertsteuer" placeholder="7,19" type="number" min="0" step="1" max="200000" class="form-control" style="text-align:right;" value="{$titleInfo/*:Beschaffung/*:Mehrwertsteuer/string()}"/>   
                          </div>
                      </div>{(: /row form-group :)}
                      <div class="row form-group">
                          <div class="col-sm-6">
                              <label class=" control-label">Belegversand: <br clear="none"/></label>                        
                              <div class="i-checks">
                              {
                                  ui:radio(
                                  "Belegversand",
                                  $titleInfo/*:Beschaffung/*:Belegversand/string(),
                                  map{"Ja":"Ja","Nein":"Nein"},
                                  6,
                                  false())
                              }
                              </div>
                          </div>
                          <div class="col-sm-6">                              
                              <label class="control-label">Belegform: </label>
                              <div>
                                  <select class="radio-inline col-sm-12 form-control" name="Belegform" size="1">
                                      <option>{ if ($titleInfo/*:Beschaffung/*:Belegform/string() = "PDF") then attribute selected {"selected"} else () }PDF</option>
                                      <option>{ if ($titleInfo/*:Beschaffung/*:Belegform/string() = "Buch") then attribute selected {"selected"} else () }Buch</option>
                                      <option>{ if ($titleInfo/*:Beschaffung/*:Belegform/string() = "Web-Link") then attribute selected {"selected"} else () }Web-Link</option>
                                  </select>
                              </div> 
                          </div>
                      </div>{(: /row form-group :)}
                      <div class="row form-group">
                          <div class="col-sm-6">
                              <label class="control-label">Anzahl</label>
                              <input name="Anzahl" placeholder="1" type="number" min="0" step="1" max="200000" class="form-control" style="text-align:right;" value="{$titleInfo/*:Beschaffung/*:Anzahl/string()}"/>     
                          </div>
                          <div class="col-sm-6">
                              &#160;    
                          </div>
                      </div>{(: /row form-group :)}                     
                  </form>
              </div>{(: /col-sm-8 :)}           
              
            </div>{(: /row :)}

            { plugin:lookup("influx/product/licence/table/view")!.($product, "12")}
           
            { plugin:lookup("token/button/bar")!.($Token) }
      </div>(: /detail-view :)
};


(: Speichert die Werte der Checklist in einem XML File um den Zustand zu halten :)
declare %restxq:path("einzellizenzen/checklist/save")
        %restxq:POST
        %restxq:query-param("nr", "{$Nr}")
        %restxq:query-param("tokenId", "{$TokenId}")
        %restxq:form-param('checklist-checkbox','{$Checked}')
function _:checklist_save($TokenId as xs:string, $Nr as xs:string, $Checked as xs:string?)
{
  let $tokenProvider := plugin:provider-lookup("xpdl/svg/plugins","xpdl/token") 
  let $token := plugin:lookup("token")!.($TokenId)  
  let $checklistData := plugin:lookup('dataobject/get')($token, $_:checklistDataObject)/*:checklist  
  let $checked :=  if($Checked) then "true" else "false"
    
  let $xml :=  
    <checklist>
      {
        for $checkbox in $checklistData/*:checkbox
          return 
          (
            if($checkbox/@nr/string() != $Nr) then (
              $checkbox
            )else()
          )
      }
      <checkbox nr="{$Nr}">
        {$checked}
      </checkbox>
    </checklist>
  
  let $dummy := plugin:lookup('dataobject/put')($token, $_:checklistDataObject, $xml)
  
  return 
    ui:info("Die Checkliste wurde gespeichert.") 
};


(: button bar :)

declare %plugin:provide('token/button/complete', "UserTask_1ug0pge")
function _:complete-button($Token as element(Token)) {
  let $decision := $Token/Condition[@Decision="set"][@GatewayId="ExclusiveGateway_03fjeqx"]
  return
    if($decision) then
      plugin:lookup("token/button/complete")!.($Token)
    else
      plugin:lookup("token/button/complete/disabled")!.()
};


declare %plugin:provide('token/button/cancel', "UserTask_1ug0pge")
function _:cancel-button($Token as element(Token)) {
  plugin:lookup("token/button/cancel/disabled")!.()
};

declare %plugin:provide('token/button/specific', "UserTask_1ug0pge")
function _:options-for-exclusive-gateway($Token as element(Token)) {
  let $decision := $Token/Condition[@Decision="set"][@GatewayId="ExclusiveGateway_03fjeqx"]
  let $tokenId := $Token/@Id/string()
  return
    if($decision) then
      ()
    else (
      <a id=""
        href="{$global:solutionName}/instance/apply/decision/{$tokenId}/ExclusiveGateway_03fjeqx/EndEvent_0faqxcr?provider={$Token/@ProcessInstanceProvider/string()}"
        class="btn btn-primary ajax">Die Bildrechte konnte erworben werden.</a>
      ,<a href="{$global:solutionName}/instance/apply/decision/{$tokenId}/ExclusiveGateway_03fjeqx/UserTask_11hpcwi?provider={$Token/@ProcessInstanceProvider/string()}"
        class="btn btn-outline btn-primary ajax">Die Bildrechte konnte nicht erworben werden.</a>
      
    )
};


(: save handler :)
declare %plugin:provide("bpmn/token/save/active", "UserTask_1ug0pge")
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
                      if ($x/Beschaffung) then 
                          replace node $x/Beschaffung with $bestellung
                      else 
                          insert node $bestellung into $x
                      return $x
    return
    (
        plugin:lookup('dataobject/put')($Token, $_:dataObjectIdForTitleInfo, $titleInfo )
        ,ui:info("Der Zwischenstand wurde gespeichert.")
    )
};
(: /save handler :)