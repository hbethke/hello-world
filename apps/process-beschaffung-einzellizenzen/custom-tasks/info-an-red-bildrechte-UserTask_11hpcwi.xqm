module namespace _ = "process/beschaffung/einzellizenzen/info-an-red";

import module namespace global = 'influx/global';
import module namespace plugin = 'influx/plugin';
import module namespace ui = 'influx/ui';
import module namespace util = 'influx/ui/process';

declare namespace bpmn = "http://www.omg.org/spec/BPMN/20100524/MODEL";

declare variable  $_:dataObjectIdForTitleInfo := "DataObjectReference_0vql52u";

declare %plugin:provide('token/ui/tasklist/content', 'UserTask_11hpcwi')
function _:renderRedInfo ($ProcessInstance as element(ProcessInstance), $Token as element(Token), $Class as xs:string?, $Action)
{
    let $provider := $ProcessInstance/@ProcessInstanceProvider/string()


    return
        <div xmlns="http://www.w3.org/1999/xhtml" class="detail-view" >
        <div class="row">
            <div class="col-md-12">
            <div class="col-md-3">
                <label>Warum wurden die Bildrechte nicht erworben?*</label>
            </div>

            <div class="col-md-5">
              <form xmlns="http://www.w3.org/1999/xhtml" method="post" class="influx-form" action="#">
                <textarea required="true" name="Info-Bildrechte" class="form-control" rows="5"></textarea>
              </form>
            </div>
            </div>
         </div>
            { plugin:lookup("token/button/bar")!.($Token) }
        </div>(: /detail-view :)
};

(: Cancel-Button :)
declare %plugin:provide("token/button/cancel", "UserTask_11hpcwi")
function _:token-button-cancel($Token as element(Token)){
    plugin:lookup("token/button/cancel/disabled")!.()
};
(: /Cancel-Button :)


(: Save-Button :)
declare %plugin:provide("token/button/save", "UserTask_11hpcwi")
function _:token-button-save($Token as element(Token)){
    plugin:lookup("token/button/save/disabled")!.()
};
(: /Save-Button :)

(: handler for complete :)
declare %plugin:provide("bpmn/token/complete/active","UserTask_11hpcwi")
function _:submit-info-form($Token as element(Token), $ProcessInstance as element(ProcessInstance), $Parameters as map(*)) {
  let $titleInfo := plugin:lookup('dataobject/get')($Token, $_:dataObjectIdForTitleInfo)/*:Produkt
  let $bildrechteInfo :=  for $key in map:keys($Parameters)
                            return map:get($Parameters,$key) ! element {$key} {.}
  let $titleInfo := copy $x:=$titleInfo
                    modify
                      if ($x/Beschaffung) then
                        insert node $bildrechteInfo into $x/Beschaffung
                      else
                        insert node element {"Beschaffung"} {$bildrechteInfo} into $x
                    return $x
  return
  (
    plugin:lookup('dataobject/put')($Token, $_:dataObjectIdForTitleInfo, $titleInfo)
    ,ui:info("Info an Redakteur versendet")
  )
};
