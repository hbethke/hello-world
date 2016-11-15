module namespace _ = "process/beschaffung/einzellizenzen/rechte-klären";
import module namespace global = 'influx/global';
import module namespace plugin = 'influx/plugin';
import module namespace ui = 'influx/ui';
import module namespace util = 'influx/ui/process';
import module namespace request = "http://exquery.org/ns/request";
import module namespace session = 'http://basex.org/modules/session';

declare namespace bpmn = "http://www.omg.org/spec/BPMN/20100524/MODEL";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace meta = 'http://influx.adesso.de/metadata';
declare variable  $_:dataObjectIdForTitleInfo := "DataObjectReference_0vql52u";


(: Rechte für Asset klären :)
declare %plugin:provide('token/ui/tasklist/content', 'UserTask_1tl1mrv')
function _:feindaten-beschaffen($ProcessInstance as element(ProcessInstance), $Token as element(Token), $Class as xs:string?, $Action)
as element(Q{http://www.w3.org/1999/xhtml}div)
{
    let $provider := $ProcessInstance/@ProcessInstanceProvider/string()
    let $definition := $ProcessInstance/Definition/*
    let $activity := $definition//bpmn:*[@id = $Token/@ActivityId]
    let $activity-name := $activity/@name/string()
    let $instance-name := $ProcessInstance/@name/string()
    let $product := plugin:lookup("influx/product")!.($ProcessInstance/@ProductId)
    let $id := random:uuid()
    let $DataInputRefIds := $activity/bpmn:dataInputAssociation/bpmn:sourceRef/text() (: ??? :)
    let $DataObjectInputRefs := $definition//bpmn:dataObjectReference[@id=$DataInputRefIds]
    let $DataStoreInputRefs := $definition//bpmn:dataStoreReference[@id=$DataInputRefIds]
    let $DataOutputRefIds := $activity/bpmn:dataOutputAssociation/bpmn:targetRef/text() (: ??? :)
    let $DataObjectOutputRefs := $definition//bpmn:dataObjectReference[@id=$DataOutputRefIds]
    let $DataStoreOutputRefs := $definition//bpmn:dataStoreReference[@id=$DataOutputRefIds]
    let $processInstanceId := $ProcessInstance/@Id/string()
    let $titleInfo := plugin:lookup('dataobject/get')($Token, $_:dataObjectIdForTitleInfo)/*:Produkt

    return
    (
    <div xmlns="http://www.w3.org/1999/xhtml" class="detail-view">
     <div class="tabs-container">
        <ul class="nav nav-tabs">
            <li class=""><a data-toggle="tab" href="#tab-titelinfo">Titelinfo</a></li>
            <li class="active"><a data-toggle="tab" href="#tab-vertrag">Vertrag</a></li>
            <li class=""><a data-toggle="tab" href="#tab-lizenzinfo">Lizenzinfo</a></li>
            <li class=""><a data-toggle="tab" href="#tab-related">Mitlizenzierte Produkte</a></li>
        </ul>

        <div class="tab-content">
            <div id="tab-titelinfo" class="tab-pane">
                <div class="panel-body">
                  {plugin:lookup("influx/product/view")!.($product)}
                </div>
            </div>
              <div id="tab-lizenzinfo" class="tab-pane">
                  <div class="panel-body">
                    { plugin:lookup("influx/product/licence/table/view")!.($product, "4")}
                  </div>
              </div>
              <div id="tab-related" class="tab-pane">
                  <div class="panel-body">
                    {plugin:lookup("influx/product/relation/form")!.($titleInfo)}
                  </div>
              </div>
              <div id="tab-vertrag" class="tab-pane active">
                  <div class="panel-body">
                    <div class="col-md-12">
                        <div class="col-md-6">
                            <label>Hier Vorlage für Standardvertrag herunterladen</label>
                            <div class="attachment">
                            {
                            for $DataObject in $DataObjectInputRefs[@id="DataObjectReference_0fj3ko6"]
                            let $fileBoxRenderer := plugin:lookup("dataobject/read/ui",$DataObject)
                            return $fileBoxRenderer!.($Token,$DataObject)
                            }
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label>Bitte laden Sie hier den bearbeiteten Vertrag hoch:</label>
                            <div class="attachment">
                            {
                            for $DataObject in $DataObjectOutputRefs[@id="DataObjectReference_1c7l1do"]
                            let $fileBoxRenderer := plugin:lookup("dataobject/write/ui",$DataObject)
                            return $fileBoxRenderer!.($Token,$DataObject)
                            }
                            </div>
                        </div>
                  </div>
              </div>
            </div>
         </div>
       </div>
        {plugin:lookup('token/button/bar')!.($Token)}
    </div>
    )    
};


(: button bar :)

declare %plugin:provide('token/button/complete', "UserTask_1tl1mrv")
function _:complete-button($Token as element(Token)) {
  let $meta := plugin:lookup("dataobject/get/meta")!.($Token,"DataObjectReference_1c7l1do")
  let $decision1 := $Token/Condition[@Decision="set"][@GatewayId="ExclusiveGateway_12e2p2c"]
  let $decision2 := $Token/Condition[@Decision="set"][@GatewayId="ExclusiveGateway_0cr8h1b"]
  return
    if($decision1 and $meta) then
      if($decision1/@TargetRef="ExclusiveGateway_0cr8h1b" and not($decision2)) then    
        plugin:lookup("token/button/complete/disabled")!.()
      else
        plugin:lookup("token/button/complete")!.($Token)
    else
      plugin:lookup("token/button/complete/disabled")!.()
};

declare %plugin:provide("token/button/cancel","UserTask_1tl1mrv") 
function _:cancel-button($Token as element(Token)){
  plugin:lookup("token/button/cancel/disabled")!.()
};

declare %plugin:provide('token/button/specific', "UserTask_1tl1mrv")
function _:options-for-exclusive-gateway($Token as element(Token)) {
  let $meta := plugin:lookup("dataobject/get/meta")!.($Token,"DataObjectReference_1c7l1do")
  return
    if($meta) then
      let $decision := $Token/Condition[@Decision="set"][@GatewayId="ExclusiveGateway_12e2p2c"]
      let $tokenId := $Token/@Id/string()
      return
        if($decision) then
          if($decision/@TargetRef="ExclusiveGateway_0cr8h1b") then
            let $decision := $Token/Condition[@Decision="set"][@GatewayId="ExclusiveGateway_0cr8h1b"]
            return
              if($decision) then ()
              else (  
                <a href="{$global:solutionName}/instance/apply/decision/{$tokenId}/ExclusiveGateway_0cr8h1b/EndEvent_0syyo6l?provider={$Token/@ProcessInstanceProvider/string()}"
                  class="btn btn-primary ajax">möglich über §46 möglich zu lizensieren</a>
                ,<a href="{$global:solutionName}/instance/apply/decision/{$tokenId}/ExclusiveGateway_0cr8h1b/ScriptTask_01jraps?provider={$Token/@ProcessInstanceProvider/string()}"
                  class="btn btn-outline btn-primary ajax">nicht möglich über §46 möglich zu lizensieren</a>
              )
          else ()
        else (
          <a id=""
            href="{$global:solutionName}/instance/apply/decision/{$tokenId}/ExclusiveGateway_12e2p2c/UserTask_0ksjl7w?provider={$Token/@ProcessInstanceProvider/string()}"
            class="btn btn-primary ajax">ist vertragsreif</a>
          ,<a href="{$global:solutionName}/instance/apply/decision/{$tokenId}/ExclusiveGateway_12e2p2c/ExclusiveGateway_0cr8h1b?provider={$Token/@ProcessInstanceProvider/string()}"
            class="btn btn-outline btn-primary ajax">ist nicht vertragsreif</a>
          
        )
  else ()
};


(: save handler :)
declare %plugin:provide("bpmn/token/save/active", "UserTask_1tl1mrv")
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
      plugin:lookup('dataobject/put')($Token, $_:dataObjectIdForTitleInfo, $titleInfo ),
      ui:info("Der Zwischenstand wurde gespeichert.")
    )
};
(: /save handler :)