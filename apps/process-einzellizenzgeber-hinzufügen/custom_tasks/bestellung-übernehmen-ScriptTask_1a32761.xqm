module namespace _ = "process/beschaffung/bestellung-übernehmen";
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

declare variable $_:doAssetMuster := "DataObjectReference_1hqrrcm";
declare variable  $_:doManuscript := "DataObjectReference_1h9s671";
declare variable  $_:dataObjectIdForTitleInfo := "DataObjectReference_0vql52u";

declare %plugin:provide('instance/transform/script', 'ScriptTask_1a32761')
function _:bestellung-übernehmen($Token as element(Token), $PerformerId as xs:string?, $dummy) 
as element(ProcessInstance)
{
  let $processInstance := plugin:lookup("instance")!.($Token/@ProcessInstanceId)
  let $parentProcessInstance := plugin:lookup("instance")!.($processInstance/@ParentProcessInstanceId)
  
  let $titelinfo := plugin:lookup("dataobject/get")!.($parentProcessInstance/Tokens/Token[1],$_:dataObjectIdForTitleInfo)/*:Produkt
  let $saveDataObject := plugin:lookup("dataobject/put")!.($Token,$_:dataObjectIdForTitleInfo,$titelinfo)
  
  let $asset-muster := plugin:lookup("dataobject/get")!.($parentProcessInstance/Tokens/Token[1],$_:doAssetMuster)
  let $meta := plugin:lookup("dataobject/get/meta")!.($parentProcessInstance/Tokens/Token[1],$_:doAssetMuster)
  let $saveDataObject := if($meta) then plugin:lookup("dataobject/put")!.($Token,$_:doAssetMuster,$asset-muster) else ()
  let $saveMeta := if($meta) then plugin:lookup("dataobject/put/meta")!.($Token,$_:doAssetMuster,$meta) else ()
  
  let $manuscript := plugin:lookup("dataobject/get")!.($parentProcessInstance/Tokens/Token[1],$_:doManuscript)
  let $meta := plugin:lookup("dataobject/get/meta")!.($parentProcessInstance/Tokens/Token[1],$_:doManuscript)
  let $saveDataObject := if($meta) then plugin:lookup("dataobject/put")!.($Token,$_:doManuscript,$manuscript) else ()
  let $saveMeta := if($meta) then plugin:lookup("dataobject/put/meta")!.($Token,$_:doManuscript,$meta) else ()
  
  return $processInstance
};