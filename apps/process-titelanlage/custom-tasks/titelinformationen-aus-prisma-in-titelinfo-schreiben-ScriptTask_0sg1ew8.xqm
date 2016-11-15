module namespace _ = "process/titelanlage/titelinformationen-aus-prisma-in-titelinfo-schreiben";
import module namespace global = 'influx/global';
import module namespace plugin = 'influx/plugin';
import module namespace ui = 'influx/ui';
import module namespace util = 'influx/ui/process';
import module namespace request = "http://exquery.org/ns/request";
import module namespace session = 'http://basex.org/modules/session';

declare namespace bpmn = "http://www.omg.org/spec/BPMN/20100524/MODEL";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace meta = 'http://influx.adesso.de/metadata';

declare variable $_:dataObjectIdForTitleInfo := "DataObjectReference_0wlonxo"; (: ID of data object that contain title info :)

declare 
%plugin:provide('instance/transform/script', 'ScriptTask_0sg1ew8')
function _:write-data-from-prisma-database-into-titleinfo($Token, $PerformerId as xs:string?, $dummy) {
  let $processInstance := plugin:lookup("instance")!.($Token/@ProcessInstanceId)
  let $productId := $processInstance/@ProductId/string()  
  let $titleInfo :=    
    <Produkt>
      {
        for $product in plugin:lookup("prisma/product")!.($productId)
        return $product/node()
      }
    </Produkt>
  let $saveDO := plugin:lookup('dataobject/put')($Token, $_:dataObjectIdForTitleInfo, $titleInfo)
  return $processInstance
};