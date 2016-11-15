module namespace _ = "process/beschaffung/einzellizenzen/fremd-und-drittrechte-markieren";
import module namespace global = 'influx/global';
import module namespace plugin = 'influx/plugin';
import module namespace ui = 'influx/ui';
import module namespace util = 'influx/ui/process';
import module namespace request = "http://exquery.org/ns/request";
import module namespace session = 'http://basex.org/modules/session';

declare namespace bpmn = "http://www.omg.org/spec/BPMN/20100524/MODEL";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace meta = 'http://influx.adesso.de/metadata';
declare variable $_:asset-muster := "DataObjectReference_1hqrrcm";


declare %plugin:provide('token/ui/tasklist/content', 'UserTask_11j7sz3')
function _:render-token-content-mark-third-party-rights($ProcessInstance as element(ProcessInstance), $Token as element(Token), $Class as xs:string?, $Action)
{    
  plugin:lookup("process/beschaffung/drittlizenzen/ui")!.($ProcessInstance/@Id,plugin:lookup("token/button/bar")!.($Token),(),())
};


(: button bar :)

declare %plugin:provide("token/button/cancel","UserTask_11j7sz3")
function _:token-button-cancel($Token as element(Token)){
  plugin:lookup("token/button/cancel/disabled")!.()
};

declare %plugin:provide("token/button/save","UserTask_11j7sz3")
function _:token-button-save($Token as element(Token)){
  plugin:lookup("token/button/save/disabled")!.()
};

declare %plugin:provide("token/button/specific","UserTask_11j7sz3")
function _:token-specific-buttons($Token as element(Token)) {
  plugin:lookup("process/beschaffung/drittlizenzen/button/specific")!.($Token/@ProcessInstanceId,$Token/@Id)
};