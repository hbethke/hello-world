module namespace _ = "http://influx.adesso.de/modules/process-beschaffung-einzellizenzen/lizenzgeber-recherchieren";
import module namespace global = 'influx/global';
import module namespace plugin = 'influx/plugin';
import module namespace ui = 'influx/ui';
import module namespace util = 'influx/ui/process';
import module namespace request = "http://exquery.org/ns/request";
import module namespace session = 'http://basex.org/modules/session';

declare namespace bpmn = "http://www.omg.org/spec/BPMN/20100524/MODEL";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace meta = "http://influx.adesso.de/metadata";

declare variable $_:name := "process-beschaffung-einzellizenzen"; (: module folder name :)
declare variable $_:staticPath := global:generateStaticPath(file:parent(file:base-dir()));
declare variable $_:dataObjectIdForTitleInfo := "DataObjectReference_0vql52u";
declare variable $_:einzellizenzgeber-recherchieren := "UserTask_0wrajtt";


(: UserTask: Lizenzgeber recherchieren und Anfrage stellen :)
declare %plugin:provide('token/ui/tasklist/content', 'UserTask_0mhw7s2')
function _:render-einzellizensierung-durchfuehren($ProcessInstance as element(ProcessInstance), $Token as element(Token), $Class as xs:string?, $Action)
{
    let $provider := $ProcessInstance/@ProcessInstanceProvider/string()
    let $definition := $ProcessInstance/Definition/*
    let $activity := $definition//bpmn:*[@id = $Token/@ActivityId]
    let $activity-name := $activity/@name/string()
    let $instance-name := $ProcessInstance/@name/string()
    let $product := plugin:lookup("dataobject/get")!.($Token, "DataObjectReference_0vql52u")/*:Produkt
    let $titleinfo := $product
    let $id := random:uuid()
    return
        (
            <div xmlns="http://www.w3.org/1999/xhtml" class="animated fadeInRight detail-view"
            style="padding:0px;" data-sort-key="{util:data-sort-key($ProcessInstance, $Token)}">
                {plugin:lookup("cornelsen/contacts/contact/new/modal")!.("Lizenzgeber")}
                    <div class="tabs-container">
                        <ul class="nav nav-tabs">
                            <li class=""><a data-toggle="tab" href="#tab-titelinfo">Titelinfo</a></li>
                            <li class=""><a data-toggle="tab" href="#tab-lizenzinfo">Lizenzinfo</a></li>
                            <li class=""><a data-toggle="tab" href="#tab-einzellizenz">Mitlizenzierte Produkte</a></li>
                            <li class="active"><a data-toggle="tab" href="#tab-lizgeb">Lizenzgeber auswählen</a></li>
                        </ul>

                        <div class="tab-content">
                            <div id="tab-titelinfo" class="tab-pane">
                                <div class="panel-body">
                                    {
                                    let $product := plugin:lookup("influx/product")!.($ProcessInstance/@ProductId)
                                    return plugin:lookup('influx/product/view')!.($product)
                                    }
                                </div>{(: tab-body :)}
                            </div>{(: tab-titleinfo :)}
                            <div id="tab-lizenzinfo" class="tab-pane">
                                <div class="panel-body">
                                    {
                                    let $product := plugin:lookup("influx/product")!.($ProcessInstance/@ProductId)
                                    return plugin:lookup('influx/product/licence/view')!.($product)
                                    }
                                </div>{(: tab-body :)}
                            </div>{(: tab-titleinfo :)}
                            <div id="tab-einzellizenz" class="tab-pane">
                                <div class="panel-body">   
                                    { plugin:lookup('influx/product/relation/form')($titleinfo) }
                                </div>{(: tab-body :)}                                
                            </div>{(: tab-einzellizenz :)}

                            <script src="{$_:staticPath}/js/script.js"></script>
                            <div id="tab-lizgeb" class="tab-pane active">
                                <div class="panel-body">                                        
                                  <form enctype="multipart/form-data" method="post" class="ajax" action="{$global:solutionName}/process/recherchieren/lizenzgeber/start/{$ProcessInstance/@Id/string()}?provider=http://influx.adesso.de/datastore/process-instances&amp;tokenId={$Token/@Id/string()}">
                                      <div class="form-group">
                                          <div class="col-lg-4">
                                          <strong>Angaben der Redaktion</strong><br/>
                                          <strong>Urheber: </strong>{$titleinfo//*:Asset-Urheber/string()}<br/>
                                          <strong>Agentur: </strong>{$titleinfo//*:Asset-Agentur/string()}<br/>
                                          </div>
                                          <div class="col-lg-4">
                                              {plugin:lookup("cornelsen/contacts/form/select")!.(plugin:lookup('cornelsen/contacts')("Lizenzgeber"), "Lizenzgeber", ())}
                                          </div>
                                          <div class="col-lg-2 m-t-md">
                                              {plugin:lookup('cornelsen/contacts/contact/new/button')("Lizgb.")}
                                          </div>
                                          <div class="col-lg-2 m-t-md">
                                              <button type="submit" class="btn btn-primary btn-xs">Prozess starten</button>
                                          </div>
                                          <div class="col-sm-12 hr-line-dashed"/>
                                      </div>
                                    </form>
                                    {_:render-process-instance-list(                                      
                                              "[@ProductId=$ProductId][Definition/*:definitions/@id=$DefinitionId][@ParentProcessInstanceId=$ParentProcessInstanceId]",
                                              map {
                                                "ProductId":$ProcessInstance/@ProductId/string(),
                                                "ParentProcessInstanceId":$ProcessInstance/@Id/string(),
                                                "DefinitionId":"id-6a71ed05-33b1-4819-96b8-b84973bf3646"
                                              })}

                                        {(:<ul id="lizenzgeb">
                                        </ul>
                                        <div class="form-group col-sm-12">
                                            <label class="control-label" style="">Anfrage gestellt per</label>
                                            <select class="form-control m-b" name="anfper">
                                                <option value="Web-Formular">Web-Formular</option>
                                                <option value="mail" selected="">E-mail</option>
                                                <option value="Brief">Brief</option>
                                                <option value="Telefon">Telefon</option>
                                                <option value="Facebook">Facebook</option>
                                            </select>
                                        </div>
                                        <div class="form-group col-sm-12">
                                            <label class="control-label">Anfrage-Info</label>
                                            <textarea class="form-control" rows="4" name="anfinfo">
                                                {if ($product/*:Anfrageinfo)
                                                then $product/*:Anfrageinfo/string()
                                                else ()
                                                }
                                            </textarea>
                                        </div>:)}
                                        <input name="tokenId" type="hidden" value="{$Token/@Id/string()}"/>
                                    </div>
                                </div>
                        </div>{(: tab-content :)}

                    </div>{(: tab-container :)}
                    {plugin:lookup("token/button/bar", $Token/@ActivityId)!.($Token)}
            </div>)
};


declare %rest:path("update/shownlizgeb")
%rest:POST
%rest:form-param("Lizenzgeber", "{$lgid}")
function _:UpdateShownLizenzgeber($lgid){
    <li data-append="#lizenzgeb" data-replace="#lizenzgebe" class="animated flipInX" id="lizenzgebe">
        {let $show := plugin:lookup('cornelsen/contacts/contact/view')(plugin:lookup('cornelsen/contacts/contact')($lgid))
        return $show}
    </li>
};


declare %rest:path("save/lizgebrecherche")
%rest:POST
%rest:form-param("tokenId", "{$tokenId}")
%rest:form-param("mitliz", "{$mitliz}")
%rest:form-param("Lizenzgeber", "{$lizenzgeber}")
%rest:form-param("anfper", "{$anfper}")
%rest:form-param("anfinfo", "{$anfinfo}")
function _:save-data-in-dataobject($tokenId, $mitliz, $lizenzgeber, $anfper, $anfinfo) {
    let $token := plugin:lookup("token")!.($tokenId)
    let $product := plugin:lookup("dataobject/get")!.($token, "DataObjectReference_0wlonxo")/*:Produkt
    return
        if ($product)
        then
            let $newProduct :=
                copy $x := $product modify
                (
                    let $mit-lizenzierungen := element {"mit-lizenzierungen"} {
                        for $pid in $mitliz
                        return
                            element {"isbn"} {$pid}
                    }
                    return
                        if ($x/mit-lizenzierungen) then
                            replace node $x/mit-lizenzierungen with $mit-lizenzierungen
                        else
                            insert node $mit-lizenzierungen into $x
                    ,
                    if ($product/LizenzgeberID)
                    then
                        replace node $x/LizenzgeberID with element {"LizenzgeberID"} { $lizenzgeber }
                    else
                        insert node (element {"LizenzgeberID"} { $lizenzgeber }) into $x
                    ,
                    if ($product/Anfrage-art)
                    then
                        replace node $x/Anfrageper with (element {"Anfrage-art"} {$anfper})
                    else
                        insert node (element {"Anfrage-art"} {$anfper}) into $x
                    ,
                    if ($product/Anfrage-info)
                    then
                        replace node $x/Anfrageinfo with (element {"Anfrage-info"} {$anfinfo})
                    else
                        insert node (element {"Anfrage-info"} {$anfinfo}) into $x
                )
                return $x
            let $write := plugin:lookup("dataobject/put")!.($token, "DataObjectReference_0wlonxo", $newProduct)
            return ($newProduct, ui:info('Erfolgreich gespeichert'))
        else ui:error("Titelinfo nicht gefunden.")
};


(: button bar :)

declare %plugin:provide("token/button/complete","UserTask_0mhw7s2") 
function _:token-button-complete($Token as element(Token)){  
  let $processInstance := plugin:lookup("instance")!.($Token/@ProcessInstanceId)
  let $definitionId := "id-6a71ed05-33b1-4819-96b8-b84973bf3646"
  let $count := plugin:lookup("instances/count")!.(
        map {
          "ProductId":$processInstance/@ProductId/string(),
          "ParentProcessInstanceId":$processInstance/@Id/string(),
          "DefinitionId":$definitionId,
          "PROCESS_STATUS_ACTIVE":plugin:lookup("instance/statuses/active")!.()
        },
        "[@ProductId=$ProductId][Definition/*:definitions/@id=$DefinitionId][@ParentProcessInstanceId=$ParentProcessInstanceId][@Status=$PROCESS_STATUS_ACTIVE]")
  return
    if($count) then
      plugin:lookup("token/button/complete/disabled")!.()
    else
      plugin:lookup("token/button/complete")!.($Token)
};

declare %plugin:provide("token/button/cancel","UserTask_0mhw7s2") 
function _:token-button-cancel($Token as element(Token)){
  plugin:lookup("token/button/cancel/disabled")!.()
};


declare %restxq:path("process/recherchieren/lizenzgeber/start/{$ProcessInstanceId}")
        %restxq:query-param("provider", "{$ProviderId}")
        %restxq:query-param("tokenId", "{$TokenId}")
        %restxq:POST
        %restxq:form-param("contactId", "{$LicenserId}")
%updating function _:start-process-lizenzgeber-recherchieren($ProviderId as xs:string, $ProcessInstanceId as xs:string, $TokenId as xs:string?, $LicenserId as xs:string)
as element(xhtml:table)
{
  let $parentProcessInstance := plugin:lookup("instance")!.($ProcessInstanceId)
  let $token := if($TokenId) then plugin:lookup("instance/token")!.($parentProcessInstance,$TokenId) else ()
  (:let $titleinfo := plugin:lookup("dataobject/get")!.($parentProcessInstance//*:Token[1],"DataObjectReference_0vql52u"):)
  
  let $definitionId := "id-6a71ed05-33b1-4819-96b8-b84973bf3646"
  
  let $subPI := plugin:lookup("instances/filtered")!.(                                 
        map {
          "ProductId":$parentProcessInstance/@ProductId/string(),
          "ParentProcessInstanceId":$parentProcessInstance/@Id/string(),
          "DefinitionId":$definitionId,
          "LicenserId":$LicenserId          
        },
        "[@ProductId=$ProductId][Definition/*:definitions/@id=$DefinitionId][@ParentProcessInstanceId=$ParentProcessInstanceId][@LicenserId=$LicenserId]")
  return
    if($subPI) then
      <table xmlns="http://www.w3.org/1999/xhtml">
        {ui:warn("Der Process Lizenzgeber recherchierren für diesen Kontakt existiert bereits.")}
      </table>      
    else  
      let $rulesProvider := "http://influx.adesso.de/engine/bpmn"
      let $processInstanceProvider := "http://influx.adesso.de/datastore/process-instances"
      let $processDefinitionProvider := "http://influx.adesso.de/datastore/definition"
      let $processDefinition :=  plugin:provider-lookup($processDefinitionProvider,"definition")!.($definitionId)
    
      let $userId := session:get("user")
          
      let $contact := plugin:lookup("cornelsen/contacts/contact")!.($LicenserId)
      let $processInstanceName := concat("Lizenzgeber recherchieren - ", $contact/*:Vorname/string(), " ", $contact/*:Nachname/string())
      let $subPI := plugin:provider-lookup('http://influx.adesso.de/modules/bpmn-instances-manager/processinstance',"instance/new")!.(
        $rulesProvider,
        $processInstanceName,
        $processInstanceProvider,
        $processDefinitionProvider,
        $processDefinition)
      let $subPI := plugin:lookup("instance/extend/attribute")($subPI,"ProductId",$parentProcessInstance/@ProductId)
      let $subPI := plugin:lookup("instance/extend/attribute")($subPI,"ParentProcessInstanceId",$parentProcessInstance/@Id)
      let $subPI := plugin:lookup("instance/extend/attribute")($subPI,"LicenserId",$LicenserId)
      let $subPI := plugin:lookup("instance/start")($subPI, $userId)
      (:let $activeToken:=$subPI//*:Token[1]
      let $write-titleinfo :=
        plugin:lookup("dataobject/put")
                     !.($activeToken,"DataObjectReference_0vql52u",$titleinfo):)
                     
      let $activeToken := $subPI//*:Token[@ActivityId=$_:einzellizenzgeber-recherchieren][@Status="unassigned"]
      let $assign := if($activeToken) then plugin:lookup("instance/token/reassign")!.($activeToken,$userId,$userId) else ()
      return
        <table xmlns="http://www.w3.org/1999/xhtml">
          {_:render-process-instance($subPI, 'animated fadeInRight once', attribute data-prepend {'#process-instance-list'})}
          {
            if($token) then
              plugin:lookup('token/button/bar',$token/@ActivityId)!.($token)
            else ()
          }
          {ui:info("Der Process Lizenzgeber recherchierren gestartet.")}
        </table>
};


declare function _:render-process-instance-list($Filter as xs:string, $Variables as map(*)) {
  <div xmlns="http://www.w3.org/1999/xhtml">
    <table class="table table-hover">
      <tbody id="process-instance-list">{
       for $processInstances in plugin:lookup('instances/filtered')!.($Variables, $Filter)
       let $date := $processInstances/@Opened/string()
       order by $date
       return 
         for $pi in $processInstances 
         return _:render-process-instance($pi,(),())
      }</tbody>
    </table>
  </div>
};

declare function _:render-process-instance($ProcessInstance as element(ProcessInstance), $Class as xs:string?, $Action as item()*) {
  let $definition := $ProcessInstance/Definition/*
  let $activeTokens := plugin:lookup("instance/tokens/active")($ProcessInstance)
  let $completedTokens := plugin:lookup("instance/tokens/completed")($ProcessInstance)
  return
    <tr xmlns="http://www.w3.org/1999/xhtml"
    id="render-process-instance-{$ProcessInstance/@Id}" class="{$Class}">{$Action}
      <td class="project-status">
          {util:renderStatus($ProcessInstance/@Status)}
      </td>      
      <td style="text-align:center;vertical-align:middle;max-width:116px;">
      </td>
      <td>
        <div>
          {
            for $endEvent in $definition//bpmn:endEvent[@id = $completedTokens/@ActivityId]
            return
              <div><small><i class="fa fa-check-circle-o"></i>&#160;{$endEvent/@name/string()}</small></div>
          }
        </div>
      </td>
      <td class="project-title">
        <strong>
          {plugin:lookup("instance/name")($ProcessInstance)}
        </strong>
        <br/>
        <small>{format-dateTime(xs:dateTime($ProcessInstance/@Opened/string()), '[D]-[M]-[Y]')}</small>
      </td>
      <td class="project-completion">
        <div>
          {
            for $token in $activeTokens
            let $activityName := $definition//bpmn:*[@id = $token/@ActivityId]/@name/string()
            return
              <div>
                <small><i class="fa fa-caret-right fa-lg" aria-hidden="true"></i>&#160;{$activityName},&#160;<strong>Performer:</strong>&#160;{
                  if ($token/@Performer/string()) then
                    (
                        $token/@Performer/string()
                        , <a href="mailto:info@adesso.de"><i class="fa fa-envelope-o" aria-hidden="true"></i></a>
                    )
                  else "Nicht zugewiesen"
                }
                </small>
              </div>
          }
        </div>
      </td>
      <td class="project-actions">
        {(:<a href="{$global:solutionName}/instance/timeline/{$ProcessInstance/@Id}?provider={$ProcessInstance/@ProcessInstanceProvider}" class="btn btn-white btn-sm ajax" title="timeline">
          <i class="fa fa-clock-o"></i>
        </a>:)}
      </td>
    </tr>
};


(: save handler :)
declare %plugin:provide("bpmn/token/save/active","UserTask_0mhw7s2")
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