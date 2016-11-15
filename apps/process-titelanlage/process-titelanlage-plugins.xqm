module namespace _ = "process/titelanlage";
import module namespace global = 'influx/global';
import module namespace plugin = 'influx/plugin';
import module namespace ui = 'influx/ui';
import module namespace util = 'influx/ui/process';
import module namespace session = 'http://basex.org/modules/session';

import module namespace form ="process/titelanlage/form" at "product-title-info-form.xqm";
import module namespace titelinformationen-aus-prisma-in-titelinfo-schreiben = "process/titelanlage/titelinformationen-aus-prisma-in-titelinfo-schreiben" at "custom-tasks/titelinformationen-aus-prisma-in-titelinfo-schreiben-ScriptTask_0sg1ew8.xqm";

declare namespace bpmn = "http://www.omg.org/spec/BPMN/20100524/MODEL";
declare namespace htm = "http://www.w3.org/1999/xhtml";
import module namespace request = "http://exquery.org/ns/request";

declare variable $_:prisma-products := plugin:lookup("prisma/products");
declare variable $_:prisma-product := plugin:lookup("prisma/product");
declare variable $_:prisma-product-search := plugin:lookup("prisma/product/search");

declare variable $_:influx-products := plugin:lookup("influx/products");
declare variable $_:influx-product := plugin:lookup("influx/product");
declare variable $_:influx-product-search := plugin:lookup("influx/product/search");
declare variable $_:influx-product-put := plugin:lookup("influx/product/put");

declare variable $_:path := "/static/modules/inspinia/";
declare variable $_:staticPath := global:generateStaticPath(file:base-dir());

declare variable $_:definitionId := "id-3175d742-1be9-443f-8e7c-f0b9b675a9ee"; (: Definition ID for Titelanlage process :)
declare variable $_:dataObjectIdForTitleInfo := "DataObjectReference_0wlonxo"; (: ID of data object that contain title info :)
declare variable $_:activityIdForTitleInfoForm := "UserTask_01uxb16"; (: Activity ID for form :)

declare %plugin:provide("process/beschaffung/titelanlage/id")
function _:get-id() {
  $_:definitionId
};

declare %plugin:provide('side-navigation')
function _:nav-item()
as element(htm:li) {
    <li xmlns="http://www.w3.org/1999/xhtml" data-parent="/config" data-sortkey="process-titelanlage">
        <a href="{$global:solutionName}/config/process-titelanlage"><i class="fa fa-cogs"></i> <span class="nav-label">Titelanlage</span></a>
    </li>
};

declare %plugin:provide("process/titelanlage/form/render")
function _:render-titelanlage-process(
    $ProductId as xs:string)
  {
  let $product := plugin:lookup("influx/product")!.($ProductId)
  return
    if($product) then
      <div class="alert alert-success text-center">
        Der Titel ist bereits angelegt. <a class="alert-link pull-right" href="{$global:solutionName}/dashboard-beschaffung">Zurück zum Dashboard</a>.
      </div>
    else
      let $processInstance := plugin:lookup("instances/filtered")!.(
        map {"ProductIds":$ProductId, "DefinitionId":$_:definitionId},
        "[@ProductId=$ProductIds][Definition/*:definitions/@id=$DefinitionId]")
      let $processInstance :=
        if($processInstance) then $processInstance
        else
          let $product := plugin:lookup("prisma/product")!.($ProductId)
          return
            if($product) then
              _:new-titelanlage-process($product)
            else
              ()          
      return
        if($processInstance) then
          let $token := $processInstance/Tokens/Token[@ActivityId=$_:activityIdForTitleInfoForm][@Status=('assigned','unassigned')]
          return
            (
              <script type="text/javascript" src="{$_:staticPath}/js/script.js"></script>
              ,plugin:lookup("token/ui/tasklist/content",$token/@ActivityId)!.($processInstance,$token,(),())
            )
        else
          <div class="alert alert-danger">
            Der Titelanlageprozess konnte nicht angelegt bzw. fortgesetzt werden. <a class="alert-link" href="{$global:solutionName}/dashboard-beschaffung">Zurück zum Dashboard</a>.
          </div>
};


declare %plugin:provide("bpmn/token/save/active","UserTask_01uxb16")
function _:save-token-active($Token as element(Token), $ProcessInstance as element(ProcessInstance), $Params as map(*)?){
 let $ProductId := $ProcessInstance/@ProductId
 let $TokenId := $Token/@Id
  let $extendedProduct :=
    <Produkt>
        {
          for $product in $_:prisma-product($ProductId)
          return $product/node()
        }        
        <Titelinfo>
          {
            for $parameter-name in map:keys($Params)
            return
                element {$parameter-name} {map:get($Params,$parameter-name)}
          }
        </Titelinfo>
    </Produkt>
  let $token := plugin:lookup("token")!.($TokenId)
  let $saveTitleInfo := plugin:lookup("process/titelanlage/titleInfo/put")!.($extendedProduct,$token)
  return 
    ui:info("Der Zwischenstand wurde gespeichert.")
};




declare %plugin:provide("process/titelanlage/new")
function _:new-titelanlage-process(
  $Product as element(Produkt)) {
  let $rulesProvider := "http://influx.adesso.de/engine/bpmn"
  let $processInstanceName := $Product/*:Bibliographie/*:Kurztitel/string()
  let $processInstanceProvider := "http://influx.adesso.de/datastore/process-instances"
  let $processDefinitionProvider := "http://influx.adesso.de/datastore/definition"
  let $processDefinition :=  plugin:provider-lookup($processDefinitionProvider,"definition")!.($_:definitionId)
  
  let $userId := session:get("user")
  return
    if($processDefinition) then
      let $newPI := plugin:provider-lookup("http://influx.adesso.de/modules/bpmn-instances-manager/processinstance","instance/new")!.(
        $rulesProvider,
        $processInstanceName,
        $processInstanceProvider,
        $processDefinitionProvider,
        $processDefinition)
      let $newPI := plugin:lookup("instance/extend/attribute")($newPI,"ProductId",$Product/*:Produktnummer/string())
      return
        plugin:lookup("instance/start")($newPI, $userId)
    else ()
};


declare %plugin:provide("processes/titelanlage")
function _:get-titelanlage-processes(
  $ProductIds as xs:string*) {            
  if($ProductIds) then
    plugin:lookup("instances/filtered")!.(
      map {"ProductIds":$ProductIds, "DefinitionId":$_:definitionId},
      "[@ProductId=$ProductIds][Definition/*:definitions/@id=$DefinitionId]"
    )
  else ()       
};

declare %plugin:provide("process/titelanlage/delete")
function _:delete-titelanlage-process(
  $ProductId as xs:string,
  $Token as element(Token)) {    
  let $processInstance := plugin:lookup("instance")($Token/@ProcessInstanceId)
          [@ProductId=$ProductId]
          [Definition/*:definitions/@id=$_:definitionId]  
  return
    plugin:lookup("instance/delete")($processInstance/@Id/string())    
};

declare %plugin:provide("process/titelanlage/form/token")
function _:get-token-for-title-info-form($ProcessInstance) {
    $ProcessInstance/Tokens/Token[@ActivityId=$_:activityIdForTitleInfoForm]
};

declare %plugin:provide("process/titelanlage/titleInfo/put")
function _:put-title-info-into-titleinfo-dataobject($Product as element(Produkt), $Token as element(Token)) {
  let $processInstance := plugin:lookup("instance")($Token/@ProcessInstanceId)
                                [@ProductId=$Product/*:Produktnummer/string()]
                                [Definition/*:definitions/@id=$_:definitionId]
  return
    if($processInstance) then
      let $titleInfo :=
        <Produkt>
          {$Product/node()}
          <Meta>
            {
                element {"Process-Definitions-Id"} {$_:definitionId},
                element {"Process-Instance-Id"} {$processInstance/@Id},
                element {"Aenderungs-Datum"} {current-dateTime()}
            }
          </Meta>
        </Produkt>
      return
        plugin:lookup('dataobject/put')($Token, $_:dataObjectIdForTitleInfo, $titleInfo)
    else
      ()
};

declare function _:apply-title-info(
    $Product as element(Produkt),
    $Token as element(Token),
    $PerformerId as xs:string)
  as element(Token)* {
  let $processInstance := plugin:lookup("instance")($Token/@ProcessInstanceId)
                                [@ProductId=$Product/*:Produktnummer/string()]
                                [Definition/*:definitions/@id=$_:definitionId]
  return
    if($processInstance) then 
      let $saveTitleInfo :=_:put-title-info-into-titleinfo-dataobject($Product,$Token)
      return
        plugin:lookup("instance/token/apply")($processInstance,$Token,$PerformerId)
    else
      ()
};


declare 
%plugin:provide('instance/transform/script', 'ScriptTask_1y0arew') 
function _:copyTitelInfoToDataStore($Token, $PerformerId as xs:string?, $dummy){
let $processInstance := plugin:lookup("instance")!.($Token/@ProcessInstanceId)
let $Content := plugin:lookup("dataobject/get")!.($Token,"DataObjectReference_0wlonxo")                
let $save := plugin:lookup("influx/product/put")($Content/Produkt)
return $processInstance
};


declare 
%plugin:provide('instance/transform/script', 'ScriptTask_1yg0bty') 
function _:titel-in-pubuch-anlegen($Token, $PerformerId as xs:string?, $dummy){
 plugin:lookup("instance")!.($Token/@ProcessInstanceId)
};


declare %plugin:provide('token/ui/tasklist/content', 'UserTask_04rvvgu')
function _:renderTitelAuswahlTask($ProcessInstance, $Token, $Class as xs:string?, $Action){
    let $provider := $ProcessInstance/@ProcessInstanceProvider/string()
    let $definition := $ProcessInstance/Definition/*
    let $activity := $definition//bpmn:*[@id = $Token/@ActivityId]
    let $activity-name := $activity/@name/string()
    let $instance-name := $ProcessInstance/@name/string()
    let $id := random:uuid()
    return
        <div xmlns="http://www.w3.org/1999/xhtml"
        class="animated fadeInRight"
        data-sort-key="{util:data-sort-key($ProcessInstance, $Token)}" >
            <div class="row">
                <div class="form-group">
                    <label class="col-sm-2 control-label">Titel nach Stichwort filtern</label>
                    <div class="col-sm-10">
                        <input class="ajax form-control"
                        data-url=""
                        data-handler="{$global:solutionName}/UserTask_04rvvgu/search?q="
                        onchange="$(this).data('url',$(this).data('handler')+$(this).val());restxq(this)"/>
                        <br/><br/>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <table class="table table-hover table-bordered">
                        <thead>
                            <tr>
                                <th class="col-lg-2">Reihe</th>
                                <th class="col-lg-2">Band</th>
                                <th class="col-lg-4">Kurztitel</th>
                                <!--th class="col-lg-2">PSP-Element</th>
                                <th class="col-lg-2">Produktnummer</th-->
                                <th class="col-lg-2">Medium</th>
                            </tr>
                        </thead>
                        {_:tbody("")}
                    </table>
                </div>
            </div>
        </div>
};

declare %rest:path("UserTask_04rvvgu/search")
%rest:query-param("q", "{$q}")
function _:tbody($q as xs:string){
    let $style := "border:2px solid #DDDDDD"
    return
        <tbody id="t_UserTask_04rvvgu" data-replace="#t_UserTask_04rvvgu" class="animated fadeInLeft once">
            {

                for $produkte_in_reihe at $rc in $_:prisma-product-search($q)
                let $reihe := $produkte_in_reihe/*:Reihe
                order by $reihe
                group by $reihe
                return (
                    <tr onclick="restxq($(this))"
                    data-url="{$global:solutionName}/UserTask_04rvvgu/reihe?q={$reihe}"
                    style="{$style}">
                        <td rowspan="{count($produkte_in_reihe) + count(distinct-values($produkte_in_reihe/*:Band)) + 1}">{$reihe}</td>
                    </tr>
                    , for $produkte_in_band at $bc in $produkte_in_reihe
                    let $band := $produkte_in_band/*:Band
                    order by $band
                    group by $band
                    return (
                        <tr onclick="restxq($(this))"
                        data-url="{$global:solutionName}/UserTask_04rvvgu/band?q={$band}"
                        style="{$style}">
                            <td rowspan="{count($produkte_in_band) + 1}">{$band}</td>
                        </tr>
                        , for $produkt in $produkte_in_band
                        let $id := $produkt/*:Produktnummer
                        let $psp-element := $produkt/*:PSP-Element
                        let $medium := $produkt/*:Medium
                        order by $medium
                        return <tr onclick="restxq($(this))"
                        data-url="{$global:solutionName}/UserTask_04rvvgu/product?q={$id}"
                        style="{if ($_:influx-product($id)) then 'color:blue;' else ()}{$style}">
                            <td>{$produkt/*:Bibliographie/*:Kurztitel/string()}</td>
                            <td>{$produkt/*:Bibliographie/*:Medium/string()}</td>
                        </tr>)
                )
            }
        </tbody>
};

declare %rest:path("UserTask_04rvvgu/reihe")
%rest:query-param("q", "{$q}")
function _:tbody-reihe($q as xs:string){
    let $style := "border:2px solid #DDDDDD"
    return
        <tbody id="t_UserTask_04rvvgu" data-replace="#t_UserTask_04rvvgu" class="animated fadeInLeft once">
            {
                for $produkte_in_reihe at $rc in $_:prisma-products()[*:Reihe = $q]
                let $reihe := $produkte_in_reihe/*:Reihe
                order by $reihe
                group by $reihe
                return (
                    <tr
                    style="{$style}">
                        <td rowspan="{count($produkte_in_reihe) + count(distinct-values($produkte_in_reihe/*:Band)) + 1}">{$reihe}</td>
                    </tr>
                    , for $produkte_in_band at $bc in $produkte_in_reihe
                    let $band := $produkte_in_band/*:Band
                    order by $band
                    group by $band
                    return (
                        <tr
                        style="{$style}">
                            <td rowspan="{count($produkte_in_band) + 1}">{$band}</td>
                        </tr>
                        , for $produkt in $produkte_in_band
                        let $id := $produkt/*:Produktnummer
                        let $medium := $produkt/*:Bibliographie/*:Medium
                        order by $medium
                        return <tr
                        style="{if ($_:influx-product($id)) then 'color:blue;' else ()} {$style}">
                            <td>{$produkt/*:Bibliographie/*:Kurztitel/string()}</td>
                            <td>{$produkt/*:Bibliographie/*:Medium/string()}</td>
                        </tr>)
                )
            }
            <tr style="{$style}">
                <td colspan="4">
                    <a href="{$global:solutionName}/UserTask_04rvvgu/reihe/add?q={$q}"
                    class="ajax btn btn-small btn-primary pull-right">Gesamte Reihe nach in|FLUX übernehmen</a>
                </td>
            </tr>
        </tbody>
};

declare %rest:path("UserTask_04rvvgu/reihe/add")
%rest:query-param("q", "{$q}")
function _:reihe-add($q as xs:string){
    let $products := $_:prisma-products()[*:Reihe = $q]
    let $add-products := $products ! $_:influx-product-put(.)
    return _:tbody("")

};


declare %rest:path("UpdateMMB")
%rest:POST
%rest:form-param("user", "{$user}")
%rest:form-param("tokenId", "{$tokenId}")
function _:UpdateMMB($user as xs:string, $tokenId){
    let $token := plugin:lookup("token")!.($tokenId)
    let $titelinfo := plugin:lookup("dataobject/get")!.($token, "DataObjectReference_0wlonxo")
    return 
      if ($titelinfo/*:Produkt) 
      then
        let $titelinfo := copy $x:=$titelinfo 
                      modify replace value of node $x//*:MMB with $user
                      return $x
        let $write := plugin:lookup("dataobject/put")!.($token,"DataObjectReference_0wlonxo",$titelinfo)
        return ui:info('MMB aktualisiert.') 
      else ui:error("Titelinfo nicht gefunden.")
};

(: Titelinfos in Datenbank bereitstellen :)
declare %plugin:provide('instance/transform/script', 'ScriptTask_1111901')
function _:script-titelinfos-to-db($Token, $Class as xs:string?, $Action){
  let $processInstance := plugin:lookup("instance")!.($Token/@ProcessInstanceId)
  let $titelinfo:=plugin:lookup("dataobject/get")($Token,"DataObjectReference_0wlonxo")    
  let $save := plugin:lookup("influx/product/put")($titelinfo/*)
  return $processInstance
};



declare %plugin:provide('instance/transform/script', 'ScriptTask_1vqei4y')
function _:script-MMB-Vorschlagen($Token, $Class as xs:string?, $Action){
  let $processInstance := plugin:lookup("instance")!.($Token/@ProcessInstanceId)
  let $titelinfo:=plugin:lookup("dataobject/get")($Token,"DataObjectReference_0wlonxo")
  let $verlagsbereich := $titelinfo/*:Grunddaten/*:Verlagsbereich/string()
  let $zuordnung := <zuordnungen>{for $line in tokenize( 
"AA - Englisch m. Schulform = BSN
AB - Englisch GY SEK I = BSN
AC - Englisch GY SEK II = BSN
AD - GB Fremdsprachen allg. = BSN und ABT
AE - SGF Englisch allg. = BSN
BA - Franz. m. Schulform = ABT
BB - Franz. GY SEK I / II = ABT
BC - Franz. allgemein = ABT
CA - Geschichte m. Schulform = MKT
CB - Geschichte GY = MKT
CC – GEWI = MKT
CD - GEWI Politik = MKT
CE - GEWI Erdkunde = MKT
CF - GEWI KuWi = WHV
DA - Deutsch m. Schulform = KHH und HRB
DB - Deutsch GY SEK I = KHH und HRB
DC - Deutsch GY SEK II = KHH und HRB
EA - Mathe m. Schulform = RUD
EB - Mathe GY SEK I = RUD
EF - Mathe GY SEK II = RUD
EG - GB Mathe/Nawi allg. = PIL
FA - NAWI Physik/Chemie MSF = PIL
FB - NAWI Physik/Chemie GY = PIL
FC - NAWI Biologie MSF = PIL
FD - NAWI Biologie Gymnasium = PIL
GA - BB Gesundheit = MAG
GB - BB Wirtschaft / BK = MAG
GC - BB Deutsch = MAG
GD - GB Berufl. Bildung/Erwachsenenbildung = MAG
GE - BB Fremdsprachen = MAG + ABT
GF - BB Mathematik = MAG
GG - BB Schweiz = MAG
GH - BB allgemein = MAG
HA - GS Deutsch 1. Klasse = HAC
HB - GS Deutsch 2.-4. Klasse = HAC
HC - GS Sachunterricht = HAC
HD - GS Mathe = HAC
HE - GS Englisch = HAC
HF - GS Weitere Fächer = HAC
HG - GB GS/ Pädagogik allgemein = VMO
IA - Weit. FS Spanisch / Ital. = ABT
IB - Weit. FS Latein = WHV
IC - Weit. FS Russisch/Chinesisch/Sonstige FS = ABT
ID - Weit. FS allgemein = ABT
JA - EWB DAF = MKT
JB - EWB Fremdsprachen = MAG
JC - BB Technik = MAG
NA  - Pädagogik / Lehrmittel = VMO
NB  - Pädagogik ZS = VMO
NC  - Frühe Kindheit = VMO
NE - PÄD Frühe Kindheit = VMO
NF - PÄD Grundschule = VMO
NG - PÄD Sekundarstufe = VMO
NH - PÄD Altenpflege/ Sonstiges = VMO","&#10;") (: Vorgabe per Mail :)
return 
  let $tok12 := tokenize($line,"=")
return <zuordnung><vb>{normalize-space($tok12[1])}</vb><user>{normalize-space($tok12[2])}</user></zuordnung>} </zuordnungen>
  let $titelinfo := 
      if ($titelinfo//*:MMB) then
                  copy $x:=$titelinfo
                    modify replace value of node $x//*:MMB with "admin" 
                    return $x
      else 
                  copy $x:=$titelinfo
                    modify insert node <MMB>{$zuordnung//*:zuordnung[*:vb=$verlagsbereich]/user/string()}</MMB> into $x/*:Produkt
                    return $x
  let $save := plugin:lookup("dataobject/put")($Token,"DataObjectReference_0wlonxo",$titelinfo)
  return $processInstance
};

(:
AA - Englisch m. Schulform = BSN
AB - Englisch GY SEK I = BSN
AC - Englisch GY SEK II = BSN
AD - GB Fremdsprachen allg. = BSN und ABT
AE - SGF Englisch allg. = BSN
BA - Franz. m. Schulform = ABT
BB - Franz. GY SEK I / II = ABT
BC - Franz. allgemein = ABT
CA - Geschichte m. Schulform = MKT
CB - Geschichte GY = MKT
CC – GEWI = MKT
CD - GEWI Politik = MKT
CE - GEWI Erdkunde = MKT
CF - GEWI KuWi = WHV
DA - Deutsch m. Schulform = KHH und HRB
DB - Deutsch GY SEK I = KHH und HRB
DC - Deutsch GY SEK II = KHH und HRB
EA - Mathe m. Schulform = RUD
EB - Mathe GY SEK I = RUD
EF - Mathe GY SEK II = RUD
EG - GB Mathe/Nawi allg. = PIL
FA - NAWI Physik/Chemie MSF = PIL
FB - NAWI Physik/Chemie GY = PIL
FC - NAWI Biologie MSF = PIL
FD - NAWI Biologie Gymnasium = PIL
GA - BB Gesundheit = MAG
GB - BB Wirtschaft / BK = MAG
GC - BB Deutsch = MAG
GD - GB Berufl. Bildung/Erwachsenenbildung = MAG
GE - BB Fremdsprachen = MAG + ABT
GF - BB Mathematik = MAG
GG - BB Schweiz = MAG
GH - BB allgemein = MAG
HA - GS Deutsch 1. Klasse = HAC
HB - GS Deutsch 2.-4. Klasse = HAC
HC - GS Sachunterricht = HAC
HD - GS Mathe = HAC
HE - GS Englisch = HAC
HF - GS Weitere Fächer = HAC
HG - GB GS/ Pädagogik allgemein = VMO
IA - Weit. FS Spanisch / Ital. = ABT
IB - Weit. FS Latein = WHV
IC - Weit. FS Russisch/Chinesisch/Sonstige FS = ABT
ID - Weit. FS allgemein = ABT
JA - EWB DAF = MKT
JB - EWB Fremdsprachen = MAG
JC - BB Technik = MAG
NA  - Pädagogik / Lehrmittel = VMO
NB  - Pädagogik ZS = VMO
NC  - Frühe Kindheit = VMO
NE - PÄD Frühe Kindheit = VMO
NF - PÄD Grundschule = VMO
NG - PÄD Sekundarstufe = VMO
NH - PÄD Altenpflege/ Sonstiges = VMO
:)

declare 
  %plugin:provide("token/transform/afterCreate","UserTask_0hczk6f")
function _:titelinfo-mmb-freigeben-before($Token as element(Token), $PerformerId as xs:string?) {
  plugin:lookup("token/performer/set")($Token,"SoenneckenD")
};


declare %plugin:provide('token/button/save', 'UserTask_0hczk6f')
function _:titelinfo-mmb-freigeben-save($Token){
  plugin:lookup("token/button/save/disabled")!.()
};

declare %plugin:provide('token/button/cancel', 'UserTask_0hczk6f')
function _:titelinfo-mmb-freigeben-cancel($Token){  
  plugin:lookup("token/button/cancel/disabled")!.()
};


declare %plugin:provide('token/ui/tasklist/content', 'UserTask_0hczk6f')
function _:render-titelinfo-mmb-freigeben($ProcessInstance, $Token, $Class as xs:string?, $Action){
    let $provider := $ProcessInstance/@ProcessInstanceProvider/string()
    let $definition := (:plugin:provider-lookup($ProcessInstance/@ProcessDefinitionProvider,"definition")($ProcessInstance/@ProcessDefinitionId):)$ProcessInstance/Definition/*
    let $activity := $definition//bpmn:*[@id = $Token/@ActivityId]
    let $activity-name := $activity/@name/string()
    let $instance-name := $ProcessInstance/@Name/string()

(:

  TODO: das hier ist noch "FAKE" Code. Hier muss nach einer Methode, die der Kunde uns noch
  sagen muss, der MMB aus den aktuellen Produktdaten ermittelt werden.

:)

    let $titelinfo := plugin:lookup("dataobject/get")!.($Token, "DataObjectReference_0wlonxo")
    let $token := $Token
    return
        <div xmlns="http://www.w3.org/1999/xhtml" class="animated fadeInRight"  data-sort-key="{util:data-sort-key($ProcessInstance, $Token)}">
            <link href="{$ui:path}css/plugins/awesome-bootstrap-checkbox/awesome-bootstrap-checkbox.css" rel="stylesheet"/>
            <link href="{$ui:path}css/plugins/jasny/jasny-bootstrap.min.css" rel="stylesheet"/>
            <link href="{$ui:path}css/plugins/iCheck/custom.css" rel="stylesheet"/>
            <div class="detail-view clearfix">
                <div class="row">
                    <div class="col-md-12">
                        <label>MMB ggf. neu zuordnen</label>
                    </div>
                    <div class="form-group form-inline">
                        <form id="mmb-submit-form" action="{$global:solutionName}/UpdateMMB" method="post" class="ajax clearfix">
                            {
                                for $user in plugin:lookup("groups/user")!.("MMB")
                                return
                                <div class="radio radio-primary col-md-6">
                                <input name="user" type="radio" id="{$user}" value="{$user}" onchange="$('#mmb-submit-form').submit()">
                            {
                                if ($titelinfo//*:MMB = $user)
                                then attribute checked {}
                                else ()
                            }
                            </input>
                            <label for="{$user}">{$user}</label>
                            </div>

                            }
                            <br/>
                            <br/>
                            <br/>
                            <input name="tokenId" type="hidden" value="{$token/@Id/string()}"/>
                            <button type="submit" class="btn btn-primary pull-right hidden">Save changes</button>
                        </form>
                    </div>
                </div>
            </div>
            {plugin:lookup("token/button/bar",$Token/@ActivityId)!.($Token)}
        </div>
};



