module namespace _ = "process/beschaffung/einzellizenzgeber-hinzufügen";
import module namespace global = 'influx/global';
import module namespace plugin = 'influx/plugin';
import module namespace ui = 'influx/ui';
import module namespace util = 'influx/ui/process';
import module namespace request = "http://exquery.org/ns/request";
import module namespace session = 'http://basex.org/modules/session';
import module namespace einzel = "process-einzellizenzgeber-hinzufügen" at "../process-einzellizenzgeber-hinzufügen-plugins.xqm";


declare namespace bpmn = "http://www.omg.org/spec/BPMN/20100524/MODEL";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace meta = 'http://influx.adesso.de/metadata';

declare variable $_:asset-muster := "DataObjectReference_1hqrrcm";
declare variable  $_:dataObjectIdForTitleInfo := "DataObjectReference_0vql52u";


(: UserTask: Lizenzgeber recherchieren und Anfrage stellen :)
declare %plugin:provide('token/ui/tasklist/content', 'UserTask_0wrajtt')
function _:renderEinzellizensierungDurchfuehren($ProcessInstance as element(ProcessInstance), $Token as element(Token), $Class as xs:string?, $Action)
{
    let $provider := $ProcessInstance/@ProcessInstanceProvider/string()
    let $definition := $ProcessInstance/Definition/*
    let $activity := $definition//bpmn:*[@id = $Token/@ActivityId]
    let $activity-name := $activity/@name/string()
    let $instance-name := $ProcessInstance/@name/string()
    let $product := plugin:lookup("influx/product")($ProcessInstance/@ProductId)
    let $titleInfo := plugin:lookup('dataobject/get')($Token, $_:dataObjectIdForTitleInfo)/*:Produkt
    let $id := random:uuid()
    return
        (
  <div xmlns="http://www.w3.org/1999/xhtml" class="animated fadeInRight detail-view"
  style="padding:0px;" data-sort-key="{util:data-sort-key($ProcessInstance, $Token)}">
      <div class="tabs-container">
              <ul class="nav nav-tabs">
                  <li class="">
                    <a data-toggle="tab" href="#tab-titelinfo">Titelinfo</a>
                  </li>
                  <li class="active">
                    <a data-toggle="tab" href="#tab-lizgeb">Lizenzgeber Kontakt</a>
                  </li>
                  <li><a data-toggle="tab" href="#tab-lizenzinfo">Lizenzinfo</a></li>
                  <li><a data-toggle="tab" href="#tab-related">Mitlizenzierte Produkte</a></li>
              </ul>

              <div class="tab-content">
                  <div id="tab-related" class="tab-pane">
                      <div class="panel-body">
                       { plugin:lookup('influx/product/relation/form')($titleInfo) }
                      </div>{(: tab-body :)}
                  </div>{(: tab-einzellizenz :)}

                  <div id="tab-titelinfo" class="tab-pane">
                      <div class="panel-body">
                          {plugin:lookup('influx/product/view')!.($product)}
                      </div>
                  </div>{(: tab-lizenzinfo :)}
                  <div id="tab-lizenzinfo" class="tab-pane">
                      <div class="panel-body">      
                      {plugin:lookup("influx/product/licence/view")($product)}
                      </div>
                  </div>
                 
                  <div id="tab-lizgeb" class="tab-pane active">
                      <div class="panel-body">      
                      {
                        let $lizenzgeber := plugin:lookup('cornelsen/contacts/contact')($ProcessInstance/@LicenserId)
return
plugin:lookup('cornelsen/contacts/contact/view')($lizenzgeber)
}<div class="col-md-6">Kontaktieren Sie den Lizenzgeber und fragen Sie die gewünschten Linzenzkonditionen an.</div></div>

                      </div>
              </div>{(: tab-content :)}
          </div>{(: tab-container :)}
          {plugin:lookup("token/button/bar", $Token/@ActivityId)!.($Token)}
  </div>)
};


(: save handler :)
declare %plugin:provide("bpmn/token/save/active","UserTask_0wrajtt")
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


(: Cancel-Button :)
declare %plugin:provide("token/button/cancel","UserTask_0wrajtt") 
function _:cancel-button($Token as element(Token)){
    plugin:lookup("token/button/cancel/disabled")!.()
};
(: /Cancel-Button :)