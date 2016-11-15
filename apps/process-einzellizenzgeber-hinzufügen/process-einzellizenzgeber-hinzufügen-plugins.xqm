module namespace _="process-einzellizenzgeber-hinzufügen";
import module namespace global  ='influx/global';
import module namespace plugin='influx/plugin';
import module namespace ui    ='influx/ui';

declare namespace html = "http://www.w3.org/1999/xhtml";


import module namespace session = 'http://basex.org/modules/session';
import module namespace bestellung-übernehmen = "process/beschaffung/bestellung-übernehmen" at "custom_tasks/bestellung-übernehmen-ScriptTask_1a32761.xqm";
import module namespace einzel-hinzu = "process/beschaffung/einzellizenzgeber-hinzufügen" at "custom_tasks/einzellizenzgeber-recherchieren-UserTask_0wrajtt.xqm";


declare namespace xhtml = "http://www.w3.org/1999/xhtml";

declare variable $_:name := "process-einzellizenzgeber-hinzufügen"; (: module folder name :)
declare variable $_:staticPath := $global:modulePath||$_:name||"/static";

declare variable $_:definitionId := ("id-6a71ed05-33b1-4819-96b8-b84973bf3646"); (: definition ID for Einzellizenzgeber hinzufügen process :)
declare variable $_:asset-muster := "DataObjectReference_1hqrrcm";


declare %plugin:provide("process/beschaffung/einzellizenzgeber/id")
function _:get-id() {
  $_:definitionId
};

(: Thumbnail for "einzellizenz prozess" is the thumb rendition of the dataobject "asset-muster" :)
declare %plugin:provide('token/ui/process/thumb', 'id-6a71ed05-33b1-4819-96b8-b84973bf3646')
function _:task-thumb-einzellizenzen($Token){
 plugin:lookup('token/ui/dataobject/thumb')!.($Token,$_:asset-muster,100,100)
};
        

(:
  let $processInstance := plugin:lookup("instance")!.($Token/@ProcessInstanceId)
  let $parentProcessInstance := plugin:lookup("instance")!.($processInstance/@ParentProcessInstanceId)
  let $parentToken := $parentProcessInstance//*:Token[@ActivityId='UserTask_0mhw7s2'][@Status=plugin:lookup('token/statuses/active')()]
  let $product := plugin:lookup("dataobject/get")!.($processInstance/@ProductId)

  let $saveDataObject := plugin:lookup("dataobject/put")!.($parentToken,"DataObjectReference_0vql52u",$product)
  return $processInstance
  
  :)