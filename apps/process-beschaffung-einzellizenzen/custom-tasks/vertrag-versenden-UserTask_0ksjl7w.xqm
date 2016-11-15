module namespace _ = "process/beschaffung/einzellizenzen/vertrag-versenden";

import module namespace global = 'influx/global';
import module namespace plugin = 'influx/plugin';
import module namespace ui = 'influx/ui';
import module namespace util = 'influx/ui/process';

declare namespace bpmn = "http://www.omg.org/spec/BPMN/20100524/MODEL";
declare variable $_:titelinfo := "DataObjectReference_0vql52u";

declare %plugin:provide('token/ui/tasklist/content', 'UserTask_0ksjl7w')
function _:renderSenden ($ProcessInstance as element(ProcessInstance), $Token as element(Token), $Class as xs:string?, $Action)
{
    let $provider := $ProcessInstance/@ProcessInstanceProvider/string()
    let $definition := $ProcessInstance/Definition/*
    let $activity := $definition//bpmn:*[@id = $Token/@ActivityId]
    let $activity-name := $activity/@name/string()
    let $DataInputRefIds := $activity/bpmn:dataInputAssociation/bpmn:sourceRef/text() (: ??? :)
    let $DataObjectInputRefs := $definition//bpmn:dataObjectReference[@id=$DataInputRefIds]
    let $DataStoreInputRefs := $definition//bpmn:dataStoreReference[@id=$DataInputRefIds]
    let $titelinfo := plugin:lookup("dataobject/get")!.($Token,$_:titelinfo)
    (:let $lizenzgeber := $titelinfo//*:Beschaffung/*:Lizenzgeber:)
    let $licenser := plugin:lookup('cornelsen/contacts/contact')($ProcessInstance/@LicenserId)
    

    return
        <div xmlns="http://www.w3.org/1999/xhtml" class="detail-view" data-sort-key="{util:data-sort-key($ProcessInstance, $Token)}">
        <div class="row">
            <div class="col-md-12">
                <div class="col-md-2">
                    <label>E-Mail</label>
                </div>
                <div class="col-md-4">{
                  if($licenser/*:Email/string()) then
                    <a href="mailto:{$licenser/*:Email/string()}?cc=absender.mail@example.de&amp;subject=Kurztitel%20und%20ISBN&amp;body=Guten%20Tag%20{concat($licenser/*:Titel/string(),'%20',$licenser/*:Vorname/string(),'%20',$licenser/*:Nachname/string())},%0A%0ALorem%20ipsum%20dolor%20sit%20amet,%20consetetur%20sadipscing%20elitr,%20sed%20diam%20nonumy%20eirmod%20tempor%20invidunt%20ut%20labore%20et%20dolore%20magna%20aliquyam%20erat,%20sed%20diam%20voluptua.%20At%20vero%20eos%20et%20accusam%20et%20justo%20duo%20dolores%20et%20ea%20rebum.%20Stet%20clita%20kasd%20gubergren,%20no%20sea%20takimata%20sanctus%20est%20Lorem%20ipsum%20dolor%20sit%20amet.%20Lorem%20ipsum%20dolor%20sit%20amet,%20consetetur%20sadipscing%20elitr,%20sed%20diam%20nonumy%20eirmod%20tempor%20invidunt%20ut%20labore%20et%20dolore%20magna%20aliquyam%20erat,%20sed%20diam%20voluptua.%20At%20vero%20eos%20et%20accusam%20et%20justo%20duo%20dolores%20et%20ea%20rebum.%20Stet%20clita%20kasd%20gubergren,%20no%20sea%20takimata%20sanctus%20est%20Lorem%20ipsum%20dolor%20sit%20amet.%0A%0AIhre%20ProzessID%20lautet:%2013132536%0A%0AMit%20freundlichen%20Grüßen">{$licenser/*:Email/string()}</a>
                    else ()
                }</div>
                <div class="col-md-2">
                    <label>Lizenzsgeberanschrift</label>
                </div>
                <div class="col-md-4">
                    <div>
                        <span>{
                          concat($licenser/*:Vorname/string(), " ", $licenser/*:Nachname/string())
                        }</span>
                    </div>
                    <div>
                        <span>{$licenser/*:Adresse/*:Strasse/string()}</span>
                    </div>
                    <div>
                        <span>{concat($licenser/*:Adresse/*:PLZ/string(), " ", $licenser/*:Adresse/*:Wohnort/string(), " ", $licenser/*:Adresse/*:Land/string())}</span>
                    </div>
                </div>
            </div>
             <div class="col-md-12">
                 <div class="col-md-2">
                     <label> Vertrag runterladen</label>
                 </div>
                 <div class="col-md-3">
                     <div class="attachment">
                         {
                             for $DataObject in $DataObjectInputRefs
                             let $fileBoxRenderer := plugin:lookup("dataobject/write/ui", $DataObject)
                             return $fileBoxRenderer!.($Token,$DataObject)
                         }
                     </div>
                 </div>
             </div>
         </div>


            { plugin:lookup("token/button/bar")!.($Token) }
        </div>(: /detail-view :)
};

(: Cancel-Button :)
declare %plugin:provide("token/button/cancel", "UserTask_0ksjl7w")
function _:token-button-cancel($Token as element(Token)){
    plugin:lookup("token/button/cancel/disabled")!.()
};
(: /Cancel-Button :)


(: Save-Button :)
declare %plugin:provide("token/button/save", "UserTask_0ksjl7w")
function _:token-button-save($Token as element(Token)){
    plugin:lookup("token/button/save/disabled")!.()
};
(: /Save-Button :)