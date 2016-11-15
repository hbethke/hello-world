module namespace _ = "process/titelanlage/form";

import module namespace global = 'influx/global';
import module namespace plugin = 'influx/plugin';
import module namespace ui = 'influx/ui';
import module namespace util = 'influx/ui/process';
import module namespace functx = 'http://www.functx.com';

import module namespace session = 'http://basex.org/modules/session';

declare namespace bpmn = "http://www.omg.org/spec/BPMN/20100524/MODEL";
declare namespace htm = "http://www.w3.org/1999/xhtml";
declare variable $_:staticPath := $global:modulePath || '/dashboard-beschaffung/static';

declare variable $_:definitionId := "id-3175d742-1be9-443f-8e7c-f0b9b675a9ee"; (: Definition ID for Titelanlage process :)
declare variable $_:dataObjectIdForTitleInfo := "DataObjectReference_0wlonxo"; (: ID of data object that contain title info :)
declare variable $_:activityIdForTitleInfoForm := "UserTask_01uxb16"; (: Activity ID for form :)

declare variable $_:licence-requirements := ('Territorial','Geplante-Gesamtauflage','Lizenzdauer','Erstauflage','Auslandslizenzen');


declare %plugin:provide("token/ui/tasklist/content", "UserTask_01uxb16")
function _:render-form-for-title-info(
    $ProcessInstance as element(ProcessInstance),
    $Token as element(Token),
    $Class as xs:string?,
    $Action as item()*)
  {
  let $titleInfo := plugin:lookup('dataobject/get')($Token, $_:dataObjectIdForTitleInfo)/*:Produkt
  return
    _:renderTitelAuswahlTask($titleInfo, $Token, ())
};


declare function _:renderTitelAuswahlTask($Product as element(Produkt), $Token as element(Token), $RedirectUrl as xs:string?)
{
  <div xmlns="http://www.w3.org/1999/xhtml"
  class="animated fadeInRight"
  data-sort-key="" >
    <link href="{$ui:path}css/bootstrap.min.css" rel="stylesheet"/>
    <link href="{$ui:path}font-awesome/css/font-awesome.css" rel="stylesheet"/>
    <link href="{$ui:path}css/plugins/iCheck/custom.css" rel="stylesheet"/>
    <link href="{$ui:path}css/animate.css" rel="stylesheet"/>
    <link href="{$ui:path}css/style.css" rel="stylesheet"/>
    <link href="{$ui:path}css/plugins/chosen/chosen.css" rel="stylesheet"/>
    <link href="{$ui:path}css/plugins/datapicker/datepicker3.css" rel="stylesheet"/>
    <div class="row">
      <div class="col-lg-12">
        {
          _:render-form($Product, $Token, ())(:$RedirectUrl:)
        }
      </div>
    </div>

  </div>
};

(:~
 : Bootstrap "drumherum" einfügen
 : @page <page><title>Some Title</title><content>html content goes here</content></page>
 : @return eine Bootstrap html element
 :)
declare function _:render-form($Product as element(Produkt), $Token as element(Token), $RedirectUrl as xs:string?){
  <div class="row">
    <div class="col-sm-12">
      <form enctype="multipart/form-data"  method="post" role="form" class="influx-form" action="">
        <div class="tabs-container">
          <ul id="tabs" class="nav nav-tabs">
            <li class="active">
              <a shape="rect" data-toggle="tab" href="#tab-1"> Titelinfo </a>
            </li>
            <li class="">
              <a shape="rect" data-toggle="tab" href="#tab-2"> Ergänzende Titelinfos</a>
            </li>           
            <!--li class="">
              <a shape="rect" data-toggle="tab" href="#tab-4"> Auftragsmedien</a>
            </li>            
            <li class="">
              <a shape="rect" data-toggle="tab" href="#tab-7"> Zusatz </a>
            </li-->
          </ul>
          <div class="tab-content">
            <div class="tab-pane active" id="tab-1">
              <div class="panel-body">
                <div class="row">
                  {plugin:lookup('prisma/product/view')($Product)}
                </div>
              </div>
            </div>
            <div class="tab-pane" id="tab-2">
              <div class="panel-body">
                <div class="row">
                  <div class="col-sm-6">
                    <div class="form-group col-sm-12">
                      <label class=" control-label">SOLL-Erscheinungstermin (ET)</label>
                      <input name="Erscheinungstermin" type="text" class="form-control" disabled="disabled" value="{
                        if ($Product/*:Erscheinungstermine/*:SollErscheinung/string()) then
                          let $unformattedDate := tokenize($Product/*:Erscheinungstermine/*:SollErscheinung/string(), '-')
                          let $year := $unformattedDate[1]
                          let $month := $unformattedDate[2]
                          let $day := $unformattedDate[3]
                          let $date := functx:date($year, $month, $day)
                          return fn:format-date($date, '[D01]/[M01]/[Y0001]')
                        else ()
                      }"/>
                    </div>
                    <div class="form-group col-sm-12">
                      <label class=" control-label">Datenabgabe (L&amp;R)</label>
                      <div class="" id="data_2">
                        <div class="input-group date">
                          <span class="input-group-addon">
                            <i class="fa fa-calendar"/>
                          </span>
                          <input name="Datenabgabe" type="text" class="form-control" value="{
                            $Product/*:Titelinfo/*:Datenabgabe/string()
                          }"/>
                        </div>
                      </div>
                    </div>
                    <div class="form-group col-sm-12">
                      <label class=" control-label">Erstauflage</label>
                      <input name="Erstauflage" required="required" type="number" min="0" step="500" max="150000" class="form-control" style="text-align:right;" value="{
                        $Product/*:Titelinfo/*:Erstauflage/string()
                      }"/>
                    </div>
                  </div>
                  <div class="col-sm-6">
                    <div class="form-group col-sm-12">
                      <label class=" control-label">Komm.    Vorabdruck    ET</label>
                      <div class="" id="data_2">
                        <div class="input-group date">
                          <span class="input-group-addon">
                            <i class="fa fa-calendar"/>
                          </span>
                          <input name="Komm-Vorabdruck-ET" type="text" class="form-control" value=" {                            $Product/*:Titelinfo/*:Komm-Vorabdruck-ET/string()
                          } "/>
                        </div>
                      </div>
                    </div>
                    <div class="form-group col-sm-12">
                      <label class=" control-label">Prüfauflage</label>
                      <div class="" id="data_2">
                        <div class="input-group date">
                          <span class="input-group-addon">
                            <i class="fa fa-calendar"/>
                          </span>
                          <input name="Prüfauflage" type="text" class="form-control" value="{
                            $Product/*:Titelinfo/*:Prüfauflage/string()
                          }"/>
                        </div>
                      </div>
                    </div>
                    <div class="form-group col-sm-12">
                      <label class=" control-label">Geplante Gesamtauflage</label>
                      <input name="Geplante-Gesamtauflage" required="" type="number" min="0" step="500" max="200000" class="form-control" style="text-align:right;" value="{
                        $Product/*:Titelinfo/*:Geplante-Gesamtauflage/string()}"/>
                    </div>
                  </div>
                </div>
                <div class="col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>
                <div class="row">
                  <div class="col-sm-6">

                    <div class="form-group col-sm-12">
                      <label class=" control-label">Zielgruppe <br clear="none"/>
                      </label>
                      <div class="i-checks">
                      {
                        ui:radio(
                          "Zielgruppe",
                          $Product/*:Titelinfo/*:Zielgruppe/string(),
                          map{"Schule":"Schule",
                              "Nachmittagsmarkt":"Nachmittagsmarkt",
                              "Erwachsene":"Erwachsene"},
                          6,
                          false())
                      }
                      </div>
                    </div>
                  </div>
                  <div class="col-sm-6">
                    <div class="form-group col-sm-12">
                      <label class=" control-label">Territorium <br clear="none"/></label>
                      <div class="i-checks">
                       {
                        ui:radio(
                          "Territorial",
                          $Product/*:Titelinfo/*:Territorial/string(),
                          map{"nur Deutschland":"Deutschland","DACH":"DACH","Europa":"Europa","Welt ohne USA":"Welt-Ohne-USA","Welt":"Welt"},
                          6,
                          true())
                      }
                      </div>
                    </div>

                  </div>
                </div>
                <div class="col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>
                <div class="row">
                  <div class="col-sm-6">
                    <div class="form-group col-sm-12">                      
                      <label class=" control-label">Lizenzdauer <br clear="none"/></label>
                      <label class="error" for="Lizenzdauer" id="Lizenzdauer_label"></label>
                      <br/>
                        <div class="i-checks">
                        {
                        (: DO NOT REFACTOR THIS TO THE _:radio function! Otherwise, the labels will be printed in an unorderly fashion :)
                        
                          let $lizenzdauer := map{"2 Jahre":"2","5 Jahre":"5","7 Jahre":"7","10 Jahre":"10"}
                          for $name in map:keys($lizenzdauer)
                          let $value := map:get($lizenzdauer,$name)
(: THIS IS DIFFERENT --->:)order by xs:integer($value) ascending
                          return
                          <div class="col-sm-6">
                          <label class="control-label"> 
                            <input class="form-control" type="radio" value="{$value}" name="Lizenzdauer" required="required">
                            {
                              if ($Product/*:Titelinfo/*:Lizenzdauer[.=$value])
                              then attribute checked {"checked"}
                              else ()
                            }
                            </input>&#160;{$name} 
                            <script type="text/javascript">
                                <![CDATA[
                                   $(window).load(function(){
                                        $('input[name="Lizenzdauer"]').next().click(function(){
                                            $('#Lizenzdauer_label').hide();
                                        });       
                                    });       
                                ]]>
                            </script>
                          </label>
                        </div>
                        }
                          
                      </div>
                    </div>


                  </div>
                  <div class="col-sm-6">
                    <div class="form-group col-sm-12">
                      <label class=" control-label">Auslandslizenzen zur Weiterlizenzierung <br clear="none"/>
                      </label>
                      <div class="i-checks">
                      {
                        ui:radio(
                          "Auslandslizenzen",
                          $Product/*:Titelinfo/*:Auslandslizenzen/string(),
                          map{"Ja":"Ja",
                              "Nein":"Nein"},
                          3,
                          false())
                      }
                      </div>
                    </div>


                  </div>
                </div>
                <div class="col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>
                <div class="row">
                 {
                   let $text := $Product/*:Titelinfo/*:Budget-Text/string()
                   let $text := if (not($text)) then 0 else try {xs:integer(xs:decimal($text))} catch *{0}
                   let $video := $Product/*:Titelinfo/*:Budget-Video/string()
                   let $video := if (not($video)) then 0 else try {xs:integer(xs:decimal($video))} catch *{0}
                   let $foto := $Product/*:Titelinfo/*:Budget-Foto/string()
                   let $foto := if (not($foto)) then 0 else try {xs:integer(xs:decimal($foto))} catch *{0}
                   let $audio := $Product/*:Titelinfo/*:Budget-Audio/string()
                   let $audio := if (not($audio)) then 0 else try {xs:integer(xs:decimal($audio))} catch *{0}
                   let $illustration := $Product/*:Titelinfo/*:Budget-Illustration/string()
                   let $illustration := if (not($illustration)) then 0 else try {xs:integer(xs:decimal($illustration))} catch *{0}                 
                   return
                  <div class="col-sm-6">
                    <div class="form-group col-sm-12">
                      <label class=" control-label">Assetbudget</label>
                       <div class="">
                        <div class="input-group m-b">
                          <span class="input-group-addon"><strong> Text </strong></span>
                          <input name="Budget-Text" 
                                 required="required" 
                                 type="number" 
                                 min="0" step="50"
                                 class="form-control" 
                                 style="text-align:right;" 
                                 max="20000"
                                 value="{$text}"
                                 />
                          <span class="input-group-addon"> € </span>
                        </div>
                        <div class="input-group m-b">
                          <span class="input-group-addon"><strong> Foto </strong></span>
                          <input name="Budget-Foto" required="required" type="number" min="0" step="50" max="20000" class="form-control" style="text-align:right;" value="{$foto}"/>
                          <span class="input-group-addon"> € </span>
                        </div>
                        <div class="input-group m-b">
                          <span class="input-group-addon"><strong> Illustration </strong></span>
                          <input name="Budget-Illustration" required="required" type="number" min="0" step="50" max="20000" class="form-control" style="text-align:right;" value="{$illustration}"/>
                          <span class="input-group-addon"> € </span>
                        </div>
                        <div class="input-group m-b">
                          <span class="input-group-addon"><strong> Audio </strong></span>
                          <input name="Budget-Audio" required="required" type="number" min="0" step="50" max="20000" class="form-control" style="text-align:right;" value="{$audio}"/>
                          <span class="input-group-addon"> € </span>
                        </div>
                        <div class="input-group m-b">
                          <span class="input-group-addon"><strong> Video </strong></span>
                          <input name="Budget-Video" required="required" type="number" min="0" step="50" max="20000" class="form-control" style="text-align:right;" value="{$video}"/>
                          <span class="input-group-addon"> € </span>
                        </div>
                      </div>
                    </div>
                  </div>
                  }
                  {
                   let $nachlizenz := $Product/*:Titelinfo/*:Budget-Nachlizensierung/string()
                   let $nachlizenz := if (not($nachlizenz)) then 0 else try {xs:integer(xs:decimal($nachlizenz))} catch *{0} 
                   return
                  <div class="col-sm-6">
                    <div class="form-group col-sm-12">
                      <label class=" control-label">Gesamtbudget</label>
                      <div class="">
                        <div class="input-group m-b">
                          <input name="Budget-Gesamt" required="required" type="number" min="0" step="50" class="form-control" style="text-align:right;" value="{
                            $Product/*:Titelinfo/*:Budget-Gesamt/string()
                          }"/> <span class="btn btn-primary btn-sm input-group-addon" onclick="$('input[name=Budget-Gesamt]').val(parseInt($('input[name=Budget-Video]').val())+parseInt($('input[name=Budget-Audio]').val())+parseInt($('input[name=Budget-Illustration]').val())+parseInt($('input[name=Budget-Text]').val())+parseInt($('input[name=Budget-Foto]').val()))"> ∑ </span>
                        </div>
                      </div>
                    </div>
                    <div class="form-group col-sm-12">
                      <label class=" control-label">Nachlizensierungsbudget</label>
                      <div class="">
                        <div class="input-group m-b">
                          <input name="Budget-Nachlizensierung" required="required" type="number" min="0" class="form-control" style="text-align:right;" value="{$nachlizenz}"/> <span class="btn btn-primary btn-sm input-group-addon" onclick="$('input[name=Budget-Nachlizensierung]').val(parseInt($('input[name=Budget-Gesamt]').val())*0.25)"> % </span>
                        </div>
                      </div>
                    </div>
                  </div>}
                </div>
                <div class="col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>
              </div>
            </div>            

            <!--div class="tab-pane" id="tab-4">
              <div class="panel-body">
                <div class="row">
                  <div class="col-sm-12">
                    <div class="form-group col-sm-12">
                      <label class=" control-label"><h2> Auftragsmedien (allgemein): </h2>
                      </label>
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-sm-6">
                    <div class="form-group col-sm-12 auftragnehmer-bekannt">
                      <label class=" control-label"> Auftragnehmer/ Dienstleister / Künstler ist bereits bekannt: <br clear="none"/>
                      </label>
                      <br />
                      <div class="i-checks">
                          {
                              ui:radio(
                                  "Auftragnehmer-bekannt",
                                  $Product/*:Titelinfo/*:Auftragnehmer-bekannt/string(),
                                  map{"Ja":"Ja","Nein":"Nein"},
                                  3,
                                  false()
                              )
                          }             
                      </div>
                    </div>
                    <div class="form-group col-sm-12 auftragnehmer-beratung">
                      <label class=" control-label"> Beratung zur Auswahl erforderlich:  <br clear="none"/>
                      </label>
                      <div class="i-checks">
                          {
                              ui:radio(
                                  "Auftragnehmer-Beratung",
                                  $Product/*:Titelinfo/*:Auftragnehmer-Beratung/string(),
                                  map{"Ja":"Ja","Nein":"Nein"},
                                  3,
                                  false()
                              )
                          }             
                      </div>                   
                    </div>
                  </div>
                  <div class="col-sm-6">
                    <label class="control-label"> Bekannte Auftragnehmer/ Dienstleister / Künstler auswählen:</label>
                    <br />
                    <div class="col-sm-6">
                      <div class="col-sm-12 input-group">
                        <select name="Wiederverwendung-aus-Titel" class="form-control chosen-select" multiple="" tabindex="-1" style="">
                          {
                            for $dl in plugin:lookup("contractors")()
                            let $id := $dl/*:IDLieferant/string()
                            return if (not(empty($dl))) then (
                              <option value="{$id}">
                                  {
                                      if(index-of(fn:tokenize($Product/*:Titelinfo/*:Wiederverwendung-aus-Titel/string(), '\s'), $id)) then
                                          attribute selected {"selected"} 
                                      else ()
                                  }
                                  {plugin:lookup("contractor/name")($id)}
                              </option>
                            ) else ()
                          }
                        </select>
                        <div class=" chosen-container chosen-container-multi chosen-with-drop chosen-container-active" style="display: none;" title="">
                          <ul class="chosen-choices">
                            {
                              let $count := 0
                              for $dl in plugin:lookup("contractors")()
                              let $count := $count + 1
                              return if (not(empty($dl)))
                              then <li class="search-choice">
                                  <span> {$dl/*:IDLieferant/string()} </span>
                                  <a class="search-choice-close" data-option-array-index="{$count}"></a>
                                </li>
                              else ()
                            }

                          </ul>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                
                <div class="col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>
                <div class="row">
                  <div class="col-sm-12">
                    <div class="form-group col-sm-12">
                      <label class=" control-label"> Fremd-Texte (allgemein): <br clear="none"/>
                      </label>
                      
                      
                      <div class="i-checks">
                          {
                              ui:checkboxes(
                                  "Fremd-Texte",
                                  $Product/*:Titelinfo/*:Fremd-Texte/string(),
                                  map{"Deutsch":"Deutsch", 
                                      "Deutscher Film":"Deutscher-Film",
                                      "Britisch":"Britisch",
                                      "Formeln":"Formeln",
                                      "ungekürzt":"ungekürzt",
                                      "gekürzt":"gekürzt",
                                      "gesprochen / vertont":"gesprochen-vertont",
                                      "Lückentext":"Lückentext",
                                      "Zeitungsartikel":"Zeitungsartikel",
                                      "wissenschaftliche Texte":"wissenschaftliche-Texte",
                                      "Interviews / Reden":"Interviews-Reden",
                                      "Blog-Einträge":"Blog-Einträge",
                                      "Statistiken":"Statistiken",
                                      "Statistiken mit Bildern":"Statistiken-mit-Bildern",
                                      "Liedtexte":"Liedtexte",
                                      "Liedtexte (VG Musikedition)":"Liedtexte-VG-Musikedition",
                                      "Literatur (vor 1940)":"Literatur-vor-1940",
                                      "Literatur":"Literatur",
                                      "Werbung als Beispiel":"Werbung-als-Beispiel",
                                      "Transkripte":"Transkripte",
                                      "Leserbriefe":"Leserbriefe",
                                      "gemeinfreie Texte":"gemeinfreie-Texte",
                                      "Noten":"Noten"}
                              )
                          }   
                          <div class="col-sm-4" style="margin-bottom: 10px;">
                              <label class="control-label">  Sprache/Land:
                                  <input class="form-control" type="text" name="Fremd-Texte-Freitext" style="width: 75%;" value="{ $Product/*:Titelinfo/*:Fremd-Texte-Freitext/string() }"/>
                              </label>
                          </div>      
                      </div>  
                    </div>
                    <div class="form-group col-sm-12">
                      <label class=" control-label">  </label>
                      <div class="col-sm-6">
                        <div class="input-group">
                          <span class="input-group-addon"><strong> Fremdtexte zu </strong></span>
                          <input name="Fremdtexte-im-Buch" type="number" min="0" max="100" class="form-control" style="text-align:right;" value="{ $Product/*:Titelinfo/*:Fremdtexte-im-Buch/string() }"/>
                          <span class="input-group-addon"><strong> % im Buch </strong></span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>
                <div class="row">
                  <div class="col-sm-12">
                    <div class="form-group col-sm-12">
                      <label class="control-label">Fremd-Video (allgemein): <br clear="none"/>
                      </label>
                      <div class="i-checks">
                          {
                              ui:checkboxes(
                                  "Fremd-Video",
                                  $Product/*:Titelinfo/*:Fremd-Video/string(),
                                  map{"Hollywood-Film":"Hollywood-Film", 
                                      "Deutscher Film":"Deutscher-Film",
                                      "Spielfilm Ausland":"Spielfilm-Ausland",
                                      "Kurzfilm":"Kurzfilm",
                                      "Dokumentation Sender dt.":"Dokumentation-Sender-dt",
                                      "Dokumentation-Sender-Ausland":"Dokumentation-Sender-Ausland",
                                      "Dokumentation Websender":"Dokumentation-Websender",
                                      "Dokumentation Nachrichten":"Dokumentation-Nachrichten",
                                      "BBC":"BBC",
                                      "ZDF - Material (Clips)":"ZDF",
                                      "Interfilm / KUKI Festival (Kurzfilme)":"Interfilm",
                                      "ITN - Material":"ITN-Material",
                                      "Spotlight":"Spotlight",
                                      "Sky":"Sky",
                                      "Picture Alliance":"Picture-Alliance",
                                      "Historisches Filmmaterial (vor 1940)":"Historisches-Filmmaterial-vor-1940",
                                      "youtube o.ä.":"youtube",
                                      "Musikvideo":"Musikvideo",
                                      "Opern-Mitschnitt":"Opern-Mitschnitt",
                                      "Theater-Mitschnitt":"Theater-Mitschnitt",
                                      "Konzert-Mitschnitt":"Konzert-Mitschnitt",
                                      "Material ohne DVD Vorlage":"Material-ohne-DVD-Vorlage",
                                      "Material mit DVD Vorlage":"Material-mit-DVD-Vorlage"}
                              )
                          }             
                      </div> 
                    </div>
                  </div>
                </div>
                <div class="col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>
                <div class="row">
                  <div class="col-sm-12">
                    <div class="form-group col-sm-12">
                      <label class=" control-label"> Fremd-Audio (allgemein): <br clear="none"/>
                      </label>
                       <div class="i-checks">
                          {
                              ui:checkboxes(
                                  "Fremd-Audio",
                                  $Product/*:Titelinfo/*:Fremd-Audio/string(),
                                  map{"Deutsch":"Deutsch", 
                                      "Englisch":"Englisch",
                                      "Hörbuch (ein Leser)":"Hörbuch-ein-Leser",
                                      "Musik":"Musik",
                                      "Hörspiel":"Hörspiel",
                                      "Songs / Musik":"Songs-Musik",
                                      "Lieder":"Lieder",
                                      "Ohne gesprochenen Text":"Ohne-gesprochenen-Text",
                                      "Audio von Video (kein Bild)":"Audio-von-Video-kein-Bild",
                                      "..............":"...",
                                      "Musikvideo":"Musikvideo",
                                      "Opern-Mitschnitt":"Opern-Mitschnitt",
                                      "Theater-Mitschnitt":"Theater-Mitschnitt",
                                      "Konzert-Mitschnitt":"Konzert-Mitschnitt",
                                      "Material ohne CD/DVD Vorlage":"Material-ohne-CD-DVD-Vorlage",
                                      "Material mit CD/DVD Vorlage":"Material-mit-CD-DVD-Vorlage"}
                              )
                          }  
                          <div class="col-sm-4" style="margin-bottom: 10px;">
                              <label class="control-label">  Sprache/Land:
                                  <input class="form-control" type="text" name="Fremd-Audio-Freitext" style="width: 75%;" value="{ $Product/*:Titelinfo/*:Fremd-Audio-Freitext/string() }"/>
                              </label>
                          </div>           
                      </div> 
                    </div>
                  </div>
                </div>


              </div>
            </div>            

            <div class="tab-pane" id="tab-7">
              <div class="panel-body">
                <div class="col-sm-12">
                  <h2> Zusatz: Fremd- und Auftragsmedien (konkret): Film/Video </h2>
                </div>
                <div class="row">
                  <div class="col-sm-12">
                    <div class="form-group col-sm-12">
                      <label class=" control-label"> Folgende Medien müssen zum Fremd-Film oder dem Auftrags-Film zusätzlich vorliegen: <br clear="none"/>
                      </label>
                      <div class="i-checks">
                          {
                              ui:checkboxes(
                                  "Zusatz-Fremd-Video",
                                  $Product/*:Titelinfo/*:Zusatz-Fremd-Video/string(),
                                  map{"Plakat":"Plakat",
                                      "Transkript":"Transkript",
                                      "Filmstill:":"Filmstill",
                                      "Audio separat":"Audio-separat",
                                      "Illustration nach Vorlage":"Illustration-nach-Vorlage",
                                      "ScreenShots":"ScreenShots",
                                      "Scan (von Cover DVD)":"Scan"}
                              )
                          }                                 
                      </div>
                    </div>
                    <div class="form-group col-sm-6">
                      <label class=" control-label"> Liegen die Daten bereits vor? <br clear="none"/>
                      </label>
                      <div class="i-checks">
                          {
                              ui:radio(
                                  "Zusatz-Fremd-Video-liegt-vor",
                                  $Product/*:Titelinfo/*:Zusatz-Fremd-Video-liegt-vor/string(),
                                  map{"Ja":"Ja","Nein":"Nein"},
                                  3,
                                  false()
                              )
                          }             
                      </div>   
                    </div>
                  </div>
                </div>
                <div class="col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>
                <div class="col-sm-12">
                  <h2> Zusatz: Fremd- und Auftragsmedien (konkret): Audio </h2>
                </div>
                <div class="row">
                  <div class="col-sm-12">
                    <div class="form-group col-sm-12">
                      <label class=" control-label"> Folgende Medien müssen zum Fremd-Audio oder dem Auftrags-Audio zusätzlich vorliegen: <br clear="none"/>
                      </label>
                      <div class="i-checks">
                          {
                              ui:checkboxes(
                                  "Zusatz-Fremd-Audio",
                                  $Product/*:Titelinfo/*:Zusatz-Fremd-Audio/string(),
                                  map{"Transkript":"Transkript", 
                                      "Scan (Cover von CD)":"Scan-Cover-CD",  
                                      "Scan (Cover vom Buch)":"Scan-Cover-Buch", 
                                      "Foto vom Sprecher(n)":"Foto-vom-Sprecher", 
                                      "Foto vom Autor":"Foto-vom-Autor", 
                                      "Illustration nach Vorlage":"Illustration-nach-Vorlage", 
                                      "Foto(s) nach Vorlage":"Foto-nach-Vorlage"}
                              )
                          }                                 
                      </div>
                    </div>
                    <div class="form-group col-sm-6">
                      <label class=" control-label"> Liegen die Daten bereits vor? <br clear="none"/>
                      </label>
                      <div class="i-checks">
                          {
                              ui:radio(
                                  "Zusatz-Fremd-Audio-liegt-vor",
                                  $Product/*:Titelinfo/*:Zusatz-Fremd-Audio-liegt-vor/string(),
                                  map{"Ja":"Ja","Nein":"Nein"},
                                  3,
                                  false()
                              )
                          }             
                      </div>    
                    </div>
                  </div>
                </div>
                <div class="col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>
                <div class="col-sm-12">
                  <h2> Zusatz: Fremd- und Auftragsmedien (konkret): Fremdtext </h2>
                </div>
                <div class="row">
                  <div class="col-sm-12">
                    <div class="form-group col-sm-12">
                      <label class=" control-label"> Folgende Medien müssen zum Fremd-Text zusätzlich vorliegen: <br clear="none"/>
                      </label>
                      <div class="i-checks">
                          {
                              ui:checkboxes(
                                  "Zusatz-Fremd-Text",
                                  $Product/*:Titelinfo/*:Zusatz-Fremd-Text/string(),
                                  map{"Scan (Cover vom Buch)":"Scan-Cover-Buch", 
                                      "Scan (Cover zum Film vom Buch)":"Scan-Cover-Film-Buch", 
                                      "Illustration(en) neben Text":"Illustration-neben-Text", 
                                      "Grafik neben Text":"Grafik-neben-Text", 
                                      "Foto neben Text":"Foto-neben-Text", 
                                      "Foto vom Autor":"Foto-vom-Autor", 
                                      "Infos zum Autor":"Infos-zum-Autor"}
                              )
                          }                                 
                      </div>
                    </div>
                    <div class="form-group col-sm-6">
                      <label class=" control-label"> Liegen die Daten bereits vor? <br clear="none"/>
                      </label>
                      <div class="i-checks">
                          {
                              ui:radio(
                                  "Zusatz-Fremd-Text-liegt-vor",
                                  $Product/*:Titelinfo/*:Zusatz-Fremd-Text-liegt-vor/string(),
                                  map{"Ja":"Ja","Nein":"Nein"},
                                  3,
                                  false()
                              )
                          }             
                      </div>                       
                    </div>
                  </div>
                </div>
                <div class="col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>
                <div class="col-sm-12">
                  <h2> Zusatz: WERBUNG </h2>
                </div>
                <div class="row">
                  <div class="col-sm-12">
                    <div class="form-group col-sm-12">
                      <label class=" control-label"> Neben der Erlaubnis den Titel mit dem Cover zu bewerben und verkleiner verbunden darzustellen: <br clear="none"/>
                      </label>
                      <div class="i-checks">
                          {
                              ui:checkboxes(
                                  "Zusatz-Werbung",
                                  $Product/*:Titelinfo/*:Zusatz-Werbung/string(),
                                  map{"Übungsblätter gratis":"Übungsblätter-gratis", 
                                      "Film-Teaser":"Film-Teaser",
                                      "Kommentierter Vorabdruck":"Kommentierter-Vorabdruck",
                                      "Audio-Teaser":"Audio-Teaser",
                                      "Werbung mit Auftrags-Models":"Werbung-mit-Auftrags-Models",
                                      "Werbung mit Auftrags-Illustration (z.B.: König)":"Werbung-mit-Auftrags-Illustration",
                                      "Werbung mit Spielelementen":"Werbung-mit-Spielelementen",
                                      "Prüfauflage":"Prüfauflage"}
                              )
                          } 
                          <div class="col-sm-4" style="margin-bottom: 10px;">
                              <label class="control-label"> Andere:
                                  <input class="form-control" type="text" name="Zusatz-Werbung-Freitext" style="width: 75%;" value="{ $Product/*:Titelinfo/*:Zusatz-Werbung-Freitext/string() }"/>
                              </label>
                          </div>                                
                      </div>   
                    </div>
                  </div>
                  <div class="col-sm-12">
                    <div class="hr-line-dashed"/>
                  </div>
                  <div class="col-sm-12">
                    <h2> Folgendes Vorgehen wurde vereinbart: </h2>
                  </div>
                  <div class="row">
                    <div class="col-sm-6">
                      <div class="form-group col-sm-12">
                        <label class=" control-label"> Weitere Informationen werden vom Redakteur eingeholt? <br clear="none"/>
                        </label>
                        <div class="i-checks">
                            {
                                ui:radio(
                                    "Weitere-Informationen-holt-Redakteur",
                                    $Product/*:Titelinfo/*:Weitere-Informationen-holt-Redakteur/string(),
                                    map{"Ja":"Ja","Nein":"Nein"},
                                    3,
                                    false()
                                )
                            }             
                        </div>
                      </div>
                    </div>

                    <div class="col-sm-6">
                      <div class="form-group col-sm-12">
                        <label class=" control-label"> Anmerkung: </label>
                        <div class="">
                          <textarea name="Anmerkung-Weitere-Informationen-holt-Redakteur" class="form-control">{ $Product/*:Titelinfo/*:Anmerkung-Weitere-Informationen-holt-Redakteur/string() }</textarea>
                        </div>
                      </div>

                    </div>
                  </div>
                  <div class="col-sm-12">
                    <div class="hr-line-dashed"/>
                  </div>
                  <div class="row">
                    <div class="col-sm-6">
                      <div class="form-group col-sm-12">
                        <label class=" control-label"> Weitere Informationen werden von L&amp;R eingeholt? <br clear="none"/>
                        </label>
                        <div class="i-checks">
                            {
                                ui:radio(
                                    "Weitere-Informationen-holt-LR",
                                    $Product/*:Titelinfo/*:Weitere-Informationen-holt-LR/string(),
                                    map{"Ja":"Ja","Nein":"Nein"},
                                    3,
                                    false()
                                )
                            }             
                        </div>                        
                      </div>
                    </div>
                    <div class="col-sm-6">
                      <div class="form-group col-sm-12">
                        <label class=" control-label"> Anmerkung: </label>
                        <div class="">
                          <textarea name="Anmerkung-Weitere-Informationen-holt-LR" class="form-control">{ $Product/*:Titelinfo/*:Anmerkung-Weitere-Informationen-holt-LR/string() }</textarea>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-sm-12">
                    <div class="hr-line-dashed"/>
                  </div>
                  <div class="row">
                    <div class="col-sm-6">
                      <div class="form-group col-sm-12">
                        <label class=" control-label"> An folgendem Datum wird L&amp;R die Bestell-Assetliste zur Verfügung gestellt: </label>
                        <div class="col-sm-6" id="data_2">
                          <div class="input-group date">
                            <span class="input-group-addon">
                              <i class="fa fa-calendar"/>
                            </span>
                            <input name="Datum-Bestell-Assetliste-LR" type="text" class="form-control" value="{ $Product/*:Titelinfo/*:Datum-Bestell-Assetliste-LR/string() }"/>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="col-sm-6">
                      <div class="form-group col-sm-12">
                        <label class=" control-label"> Anmerkung: </label>
                        <div class="">
                          <textarea name="Anmerkung-Datum-Bestell-Assetliste-LR" class="form-control">{ $Product/*:Titelinfo/*:Anmerkung-Datum-Bestell-Assetliste-LR/string() }</textarea>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-sm-12">
                    <div class="hr-line-dashed"/>
                  </div>
                  <div class="row">
                    <div class="col-sm-6">
                      <div class="form-group col-sm-12">
                        <label class=" control-label"> L&amp;R wird bis zu folgendem Datum eine zeitliche Struktur erstellen: </label>
                        <div class="col-sm-6" id="data_2">
                          <div class="input-group date">
                            <span class="input-group-addon">
                              <i class="fa fa-calendar"/>
                            </span>
                            <input name="Datum-zeitl-Struktur-LR" type="text" class="form-control" value="{ $Product/*:Titelinfo/*:Datum-zeitl-Struktur-LR/string() }"/>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="col-sm-6">
                      <div class="form-group col-sm-12">
                        <label class=" control-label"> Anmerkung: </label>
                        <div class="">
                          <textarea name="Anmerkung-Datum-zeitl-Struktur-LR" class="form-control">{ $Product/*:Titelinfo/*:Anmerkung-Datum-zeitl-Struktur-LR/string() }</textarea>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-sm-12">
                    <div class="hr-line-dashed"/>
                  </div>
                  <div class="row">
                    <div class="col-sm-12">
                      <div class="form-group col-sm-12">
                        <label class=" control-label"> Auf folgende Dinge wurde durch L&amp;R aufmerksam gemacht: <br clear="none"/>
                        </label>
                        <div class="i-checks">
                          {
                              ui:checkboxes(
                                  "LR-Hinweise",
                                  $Product/*:Titelinfo/*:LR-Hinweise/string(),
                                  map{"Grundsätzliche Strategie-Übersicht":"Strategie-Übersicht",
                                      "Hinweise zu Pressefotos":"Pressefotos",
                                      "Hinweise zu WORD-Dokumenten":"WORD-Dokumenten",
                                      "Hinweise zu VG-Meldungen":"VG-Meldungen",
                                      "Hinweise zum Streaming und Off-line Client":"Streaming",
                                      "Hinweise zur Materialleiste scook für Schüler":"Materialleiste-scook",
                                      "Hinweise zu Wiederverwendungen":"Wiederverwendungen",
                                      "Checkpoint Erinnerungsliste":"Checkpoint-Erinnerungsliste"}
                              )
                          }                                 
                      </div>
                      </div>
                      <div class="form-group col-sm-6">
                        <label class=" control-label"> Anmerkung: </label>
                        <div class="">
                          <textarea name="Anmerkung-LR-Hinweise" class="form-control">{ $Product/*:Titelinfo/*:Anmerkung-LR-Hinweise/string() }</textarea>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>
              </div>
            </div-->

          </div>
          
        </div>
        <script class="rxq-js-eval" src="{$ui:path}js/plugins/iCheck/icheck.min.js"/>
        <script class="rxq-js-eval" src="{$ui:path}js/plugins/validate/jquery.validate.min.js"/>
        <script class="text/javascript" src="{$_:staticPath}/js/messages_de.js"/>

        <script class="rxq-js-eval" src="{$ui:path}js/plugins/chosen/chosen.jquery.js"/>
        <script class="rxq-js-eval" src="{$ui:path}js/plugins/datapicker/bootstrap-datepicker.js"/>

        <script type="text/javascript" src="{$_:staticPath}/js/form-magic.js"/>

      </form>
       {plugin:lookup("token/button/bar")!.($Token)}
    </div>

  </div>
};


(: Cancel-Button :)
declare %plugin:provide("token/button/cancel/url","UserTask_01uxb16") 
function _:token-button-cancel-url($Token as element(Token)){
  let $instance := plugin:lookup("instance")!.($Token/@ProcessInstanceId)
  return
  $global:solutionName||"dashboard-beschaffung/product/title/form/cancel/"||$instance/@ProductId||"?tid="||$Token/@Id
};
(: /Cancel-Button :)


declare %plugin:provide("token/button/navigation","UserTask_01uxb16")
function _:token-button-next($Token as element(Token)){
  if($Token/@Status/string()=plugin:lookup("token/statuses/inactive")!.()) then
    <a class="btn btn-outline btn-primary"
       href="{$global:solutionName}/dashboard-beschaffung"
       data-i18n="cancel"><i class="fa fa-chevron-left" aria-hidden="true"></i>&#160;Produktübersicht</a>
  else ()
};


(: handler for complete :) 
declare %plugin:provide("bpmn/token/complete/active","UserTask_01uxb16") 
function _:submit-title-info-form($Token as element(Token), $ProcessInstance as element(ProcessInstance), $Params as map(*)) {
  let $productId := $ProcessInstance/@ProductId/string()
  let $titleInfo :=
    <Produkt>
        {
            for $product in plugin:lookup("prisma/product")($productId)
            return $product/node()
        }
        <Titelinfo>
            {
                for $parameterName in map:keys($Params)
                return
                    element {$parameterName} {map:get($Params, $parameterName)}
            }
        </Titelinfo>
        <Meta>
          {
              element {"Process-Definitions-Id"} {$_:definitionId},
              element {"Process-Instance-Id"} {$ProcessInstance/@Id},
              element {"Aenderungs-Datum"} {current-dateTime()}
          }
        </Meta>
    </Produkt>
  return 
    (
      plugin:lookup('dataobject/put')($Token, $_:dataObjectIdForTitleInfo, $titleInfo)
      ,ui:info("Das Formular für die Titelinformation wurde abgeschickt.")
    )
};

