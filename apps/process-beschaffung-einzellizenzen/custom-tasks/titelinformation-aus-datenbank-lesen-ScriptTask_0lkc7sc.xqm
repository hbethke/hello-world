module namespace _ = "process/beschaffung/einzellizenzen/titelinfo-aus-db-lesen";
import module namespace global = 'influx/global';
import module namespace plugin = 'influx/plugin';
import module namespace ui = 'influx/ui';
import module namespace util = 'influx/ui/process';
import module namespace request = "http://exquery.org/ns/request";
import module namespace session = 'http://basex.org/modules/session';

declare namespace bpmn = "http://www.omg.org/spec/BPMN/20100524/MODEL";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace meta = 'http://influx.adesso.de/metadata';

declare %plugin:provide('instance/transform/script', 'ScriptTask_0lkc7sc')
function _:write-data-from-prisma-database-into-titleinfo($Token, $PerformerId as xs:string?, $dummy) 
as element(ProcessInstance)
{
  let $processInstance := plugin:lookup("instance")!.($Token/@ProcessInstanceId)
  let $productId := $processInstance/@ProductId/string()  
  let $product := plugin:lookup("influx/product")!.($processInstance/@ProductId)

  let $saveDataObject := plugin:lookup("dataobject/put")!.($Token,"DataObjectReference_0vql52u",$product)
  return $processInstance
};