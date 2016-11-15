module namespace _ = "process/beschaffung/einzellizenzen/rechtliche-metadaten-ergaenzen";

import module namespace global = 'influx/global';
import module namespace plugin = 'influx/plugin';
import module namespace ui = 'influx/ui';
import module namespace util = 'influx/ui/process';

declare namespace bpmn = "http://www.omg.org/spec/BPMN/20100524/MODEL";
declare variable $_:titelinfo := "DataObjectReference_0vql52u";
declare variable $_:asset-muster := "DataObjectReference_1hqrrcm";
declare variable $_:asset-feindaten := "DataObjectReference_1sgwzn4";


declare %plugin:provide('token/ui/tasklist/content', 'UserTask_0qcil25')
function _:renderErgaenzen($ProcessInstance as element(ProcessInstance), $Token as element(Token), $Class as xs:string?, $Action)
{
  let $provider := $ProcessInstance/@ProcessInstanceProvider/string()
  let $definition := $ProcessInstance/Definition/*
  let $activity := $definition//bpmn:*[@id = $Token/@ActivityId]
  let $activity-name := $activity/@name/string()
  let $DataOutputRefIds := $activity/bpmn:dataOutputAssociation/bpmn:targetRef/text() (: ??? :)
  let $DataObjectOutputRefs := $definition//bpmn:dataObjectReference[@id = $DataOutputRefIds]
  let $DataStoreOutputRefs := $definition//bpmn:dataStoreReference[@id = $DataOutputRefIds]
  let $titelinfo := plugin:lookup("dataobject/get")!.($Token, $_:titelinfo)
  let $meta := plugin:lookup("dataobject/get/meta")!.($Token, $_:asset-muster)
  let $feindaten-meta := plugin:lookup("dataobject/get/meta")!.($Token, $_:asset-feindaten)
  let $lizenzgeber := $titelinfo//*:Beschaffung/*:Lizenzgeber


  return
    <div xmlns="http://www.w3.org/1999/xhtml" class="detail-view" data-sort-key="{util:data-sort-key($ProcessInstance, $Token)}">
      <div class="row">
        <div class="col-md-12">
          <div class="col-sm-3">
            <!-- TODO: Titel über dem Bild anzeigen, nach breakpoint auf kleinen Geräten -->
            {
              if ($meta/*:previewUrl) then
                <div class="product-imitation" style="margin-left:20px;padding: 34px 0px;min-height:300px;">
                  <img class="img-responsive" style="margin:auto;" src="/static/{$feindaten-meta/*:previewUrl}" alt="Kein Cover verfügbar"/>
                </div>
              else
                <div class="product-imitation"  style="margin-left:20px;padding: 34px 0px;min-height:300px;"> Keine Vorschau </div>
            }

            <div class="product-desc"/>
          </div>
          <div class="col-sm-9">
            <div class="row">
              <div class="col-sm-12">
                <h1> {$feindaten-meta/*:filename[1]/string()} </h1>
                <div class="row" style="margin-bottom: 5px;">
                  <div class="col-xs-3">
                    <strong> Copyright: </strong>
                  </div>
                  <div class="col-xs-9 text-primary">
                    {
                      $titelinfo/*:Produkt/*:Titelinfo/*:Copyright/string()
                    }
                  </div>
                </div>
                <div class="row" style="margin-bottom: 5px;">
                  <div class="col-xs-3">
                    <strong> Anbieter: </strong>
                  </div>
                  <div class="col-xs-9">
                    {
                      $titelinfo/*:Produkt/*:Beschaffung/*:Asset-Anbieter/string()
                    }
                  </div>
                </div>

                <div class="row" style="margin-bottom: 5px;">
                  <div class="col-xs-3">
                    <strong>Urheber:</strong>
                  </div>
                  <div class="col-xs-9">
                    {
                      $titelinfo/*:Produkt/*:Beschaffung/*:Asset-Urheber/string()
                    }
                  </div>
                </div>
                <div class="row" style="margin-bottom: 5px;">
                  <div class="col-xs-3">
                    <strong> Medientyp: </strong>
                  </div>
                  <div class="col-xs-9">
                    {
                      $titelinfo/*:Produkt/*:Beschaffung/*:Asset-Typ/string()
                    }
                  </div>
                </div>

                <div class="row" style="margin-bottom: 5px;">
                  <div class="col-xs-3">
                    <strong>Model Release:</strong>
                  </div>
                  <div class="col-xs-9">
                    {
                      $titelinfo/*:Produkt/*:Titelinfo/*:Model-Release/string()
                    }
                  </div>
                </div>
                <div class="row" style="margin-bottom: 5px;">
                  <div class="col-xs-3">
                    <strong> Property Release: </strong>
                  </div>
                  <div class="col-xs-9">
                    {
                      $titelinfo/*:Produkt/*:Titelinfo/*:Property-Release/string()
                    }
                  </div>
                </div>

                <div class="row" style="margin-bottom: 5px;">
                  <div class="col-xs-3">
                    <strong>Vertragsstatus:</strong>
                  </div>
                  <div class="col-xs-9">
                    {
                      $titelinfo/*:Produkt/*:Titelinfo/*:Vertragsstatus/string()
                    }
                  </div>
                </div>
                <div class="row" style="margin-bottom: 5px;">
                  <div class="col-xs-3">
                    <strong> Belegversand: </strong>
                  </div>
                  <div class="col-xs-9">
                    {
                      $titelinfo/*:Produkt/*:Titelinfo/*:Belegversand/string()
                    }
                  </div>
                </div>

                <div class="row" style="margin-bottom: 5px;">
                  <div class="col-xs-3">
                    <strong>Reichweite:</strong>
                  </div>
                  <div class="col-xs-9">
                    {
                      $titelinfo/*:Produkt/*:Beschaffung/*:Reichweite/string()
                    }
                  </div>
                </div>
                <div class="row" style="margin-bottom: 5px;">
                  <div class="col-xs-3">
                    <strong> Territorial: </strong>
                  </div>
                  <div class="col-xs-9">
                    {
                      $titelinfo/*:Produkt/*:Titelinfo/*:Territorial/string()
                    }
                  </div>
                </div>

                <div class="row" style="margin-bottom: 5px;">
                  <div class="col-xs-3">
                    <strong>Nutzungsrechte (print):</strong>
                  </div>
                  <div class="col-xs-9">
                    {
                      $titelinfo/*:Produkt/*:Titelinfo/*:Nutzungsrechte-print/string()
                    }
                  </div>
                </div>
                <div class="row" style="margin-bottom: 5px;">
                  <div class="col-xs-3">
                    <strong>Nutzungsrechte (digital):</strong>
                  </div>
                  <div class="col-xs-9">
                    {
                      $titelinfo/*:Produkt/*:Titelinfo/*:Nutzungsrechte-digital/string()
                    }
                  </div>
                </div>
                <div class="row" style="margin-bottom: 5px;">
                  <div class="col-xs-3">
                    <strong>Lizenzdauer:</strong>
                  </div>
                  <div class="col-xs-9">
                    {
                      concat($titelinfo/*:Produkt/*:Titelinfo/*:Lizenzdauer/string(), ' Jahre')
                    }
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <!--pre>{
          serialize($titelinfo)
        }</pre-->

      </div>

      {plugin:lookup("token/button/bar")!.($Token)}
    </div>(: /detail-view :)
};

(: Cancel-Button :)
declare %plugin:provide("token/button/cancel", "UserTask_0qcil25")
function _:cancel-button($Token as element(Token)){
  plugin:lookup("token/button/cancel/disabled")!.()
};
(: /Cancel-Button :)


(: Save-Button :)
declare %plugin:provide("token/button/save", "UserTask_0qcil25")
function _:save-button($Token as element(Token)){
  plugin:lookup("token/button/save/disabled")!.()
};
(: /Save-Button :)