module namespace _ = "process/beschaffung/auftragsmedien/media/order/form";

import module namespace global = 'influx/global';
import module namespace plugin = 'influx/plugin';
import module namespace ui = 'influx/ui';
import module namespace util = 'influx/ui/process';
import module namespace functx = 'http://www.functx.com';

declare namespace xhtml = "http://www.w3.org/1999/xhtml";

declare variable $_:staticPath := global:generateStaticPath(file:base-dir());

declare function _:render-photo-order-form(
    $Produkt as element(Produkt),
    $Class as xs:string?,
    $Action as item()?)
  as element(xhtml:form){
              <form id="render-photo-order-form" xmlns="http://www.w3.org/1999/xhtml" role="form" class="ajax{if($Class) then ' '||$Class else ()}" method="POST"
              action="{$global:solutionName}/bestellung/{$Produkt/*:Produktnummer}"
              enctype="multipart/form-data">{$Action}
                <h2> Formular zur Erstellung eines Bestellvertrags für Fotografie </h2>
                <div class="form-group col-sm-6">
                  {plugin:lookup('cornelsen/contacts/form/select')!.(plugin:lookup('cornelsen/contacts')("Fotograf"), "Fotograf", ())}
                </div>
                <div class="form-group col-sm-12">
                  <label class="control-label">Rahmenvertrag<br clear="none"/></label>
                  <div class="i-checks">
                    <div class="col-sm-3">
                      <input class="form-control" type="radio"  value="Ja" name="Rahmenvertrag-liegt-vor"/>
                      <label class="control-label">liegt vor</label>

                    </div>
                    <div class="col-sm-9">
                      <input class="form-control" type="radio"  value="Nein" name="Rahmenvertrag-liegt-vor"/>
                      <label class="control-label">muss erstellt werden</label>

                    </div>
                  </div>
                </div>

                <div class="form-group col-sm-12">
                  <label class="control-label">Ausgabesprache<br clear="none"/></label>
                  <div class="i-checks">
                    <div class="col-sm-3">
                      <label class="control-label"> <input class="form-control" type="radio"  value="Deutsch" name="Ausgabesprache"/> Deutsch</label>
                    </div>
                    <div class="col-sm-3">
                      <label class="control-label"> <input class="form-control" type="radio"  value="Englisch" name="Ausgabesprache"/> English</label>
                    </div>
                    <div class="col-sm-3">
                      <label class="control-label"> <input class="form-control" type="radio"  value="Spanisch" name="Ausgabesprache"/> Spanisch</label>
                    </div>
                  </div>
                </div>

                <div class="row col-sm-12">
                  <div class="form-group col-sm-6">
                    <label>Titel der Lehrwerksreihe</label>
                    <input name="Titel-Lehrwerksreihe" type="text" class="form-control" value="{$Produkt//*:Reihe/normalize-space(string())}"/>
                  </div>
                </div>
                <div class="row col-sm-12">
                  <div class="form-group col-sm-6">
                    <label>Genaue Bezeichnung des Einzelwerks</label>
                    <input name="Bezeichung-Einzelwerk" type="text" class="form-control" value="{$Produkt//*:Kurztitel/normalize-space(string())}"/>
                  </div>
                </div>
                <div class="row col-sm-12">
                  <div class="form-group col-sm-offset-6 col-sm-6">
                    <label>ISBN</label>
                    <input name="Produktnummer" type="text" class="form-control" value="{$Produkt/*:Produktnummer/normalize-space(string())}"/>
                  </div>
                  <div class="form-group col-sm-6">
                    <label>PSP-Element</label>
                    <input name="PSP-Element" type="text" class="form-control" value="{$Produkt//*:PSP-Element/string()}"/>
                  </div>
                  <div class="col-sm-12">
                    <div class="hr-line-dashed"/>
                  </div>
                </div>

                <h3 class="col-sm-12">Gegenstand der Beauftragung</h3>
                <div class="form-group col-sm-12">
                  <label class="control-label"> Voraussichtliche Anzahl neu zu erstellender Fotografien: </label>
                  <div class="col-sm-6 input-group m-b">
                    <input name="Anzahl-Fotografien" type="number" min="0" max="100000" class="form-control" style="text-align:right;"/>
                    <span class="input-group-addon"> Foto(s) </span>
                  </div>
                </div>
                <div class="col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>

                <h3 class="col-sm-12">Termine</h3>
                <div class="form-group col-sm-12">
                  <table class="table">
                    <thead>
                      <tr>
                        <th class="col-sm-6">Lieferung</th>
                        <th class="col-sm-6">Datum</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>(Teil) Lieferung 1</td>
                        <td>
                          <div id="data_2" class="input-group date" data-provide="datepicker">
                            <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input type="text" class="form-control" name="Datum-Lieferung-1" value=""/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>(Teil) Lieferung 2</td>
                        <td>
                          <div id="data_2" class="input-group date" data-provide="datepicker">
                            <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input type="text" class="form-control" name="Datum-Lieferung-2" value=""/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>(Teil) Lieferung 3</td>
                        <td>
                          <div id="data_2" class="input-group date" data-provide="datepicker">
                            <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input type="text" class="form-control" name="Datum-Lieferung-3" value=""/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>(Teil) Lieferung 4</td>
                        <td>
                          <div id="data_2" class="input-group date" data-provide="datepicker">
                            <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input type="text" class="form-control" name="Datum-Lieferung-4" value=""/>
                          </div>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <div class="col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>

                <div class="form-group col-sm-12">
                  <label>Dateiformat der Vorlagen</label>
                  <div class="i-checks">
                    <div class="col-sm-3">
                      <p class="form-control-static">
                        <input class="form-control" type="checkbox"  value="jpeg" name="dateiformat"/>
                        <label>.jpeg/.jpg</label>
                      </p>
                    </div>
                    <div class="col-sm-3">
                      <p class="form-control-static">
                        <input class="form-control" type="checkbox"  value="tiff" name="dateiformat"/>
                        <label>.tiff</label>
                      </p>
                    </div>
                    <div class="col-sm-3">
                      <p class="form-control-static">
                        <input class="form-control" type="checkbox"  value="eps" name="dateiformat"/>
                        <label>.eps</label>
                      </p>
                    </div>
                  </div>
                </div>
                <div class="col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>
                <div class="form-group col-sm-12">
                  <h3>Vergütung</h3>
                  <table class="table">
                    <thead>
                      <tr>
                        <th class="col-sm-7">Kategorie</th>
                        <th class="col-sm-5">Anzahl</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>Kategorie 1 = 20,- Euro</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Kategorie-1" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Foto(s) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Kategorie 2 = 40,- Euro</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Kategorie-2" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Foto(s) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Kategorie 3 = 60,- Euro</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Kategorie-3" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Foto(s) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Kategorie 4 = 80,- Euro</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Kategorie-4" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Foto(s) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Kategorie 5 = 100,- Euro</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Kategorie-5" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Foto(s) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Kategorie 6 = 120,- Euro</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Kategorie-6" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Foto(s) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Cover </td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Cover" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Foto(s) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Tagespauschale </td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Tagespauschale" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Foto(s) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Kilometerpauschale</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Kilometerpauschale" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Foto(s) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Materialkosten (via Rechnung)</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Materialkosten" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Foto(s) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Sonstiges</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Sonstiges" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Foto(s) </span>
                          </div>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <div class="form-group col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>

                <div class="form-group col-sm-12">
                  <label class=" control-label"> Anzahl Belegexemplare: </label>
                  <div class="col-sm-6 input-group m-b">
                    <input name="Anzahl-Belegexemplare" type="number" min="0" max="100000" class="form-control" style="text-align:right;"/>
                    <span class="input-group-addon"> Exemplar(e) </span>
                  </div>

                </div>
                <div class="form-group col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>

                <div class="form-group col-sm-12">
                  <h3> Wiederverwendungen </h3>
                  <label class=" control-label"> Werk enthält Wiederverwendungen des Urhebers?
                  </label>
                  <br />
                  <div class="col-sm-12 i-checks">
                    <div class="col-sm-2">
                      <div>
                        <label class="control-label">
                          <input class="form-control" type="radio"  value="Ja" name="Werk-enthaelt-Wiederverwendungen-des-Urhebers"/> Ja </label>
                      </div>
                    </div>
                    <div class="col-sm-3">
                      <div>
                        <label class="control-label">
                          <input class="form-control" type="radio"  value="Nein" name="Werk-enthaelt-Wiederverwendungen-des-Urhebers"/> Nein </label>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="form-group col-sm-12">
                  <label class=" control-label"> Vertrag liegt vor?
                  </label>
                  <br />
                  <div class="col-sm-12 i-checks">
                    <div class="col-sm-2">
                      <div>
                        <label class="control-label">
                          <input class="form-control" type="radio"  value="Ja" name="Vertrag-fuer-Wiederverwendungen-liegt-vor"/> Ja </label>
                      </div>
                    </div>
                    <div class="col-sm-10">
                      <div>
                        <label class="control-label">
                          <input class="form-control" type="radio"  value="Nein" name="Vertrag-fuer-Wiederverwendungen-liegt-vor"/> Nein, daher Nachlizenzierung erforderlich </label>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="form-group col-sm-6">
                  <label class="control-label"> Wie viele Fotos sollen wiederverwendet werden? </label>
                  <div class="col-sm-12 input-group m-b">
                    <input name="Anzahl-Foto-Wiederverwendung" type="number" min="0" max="100000" class="form-control" style="text-align:right;"/>
                    <span class="input-group-addon"> Foto(s) </span>
                  </div>
                </div>
                <div class="form-group col-sm-6">
                  <label> Welche (bitte Motive bereitstellen)? </label>
                  <input name="Motive" type="text" class="form-control" />
                </div>
                <div class="form-group col-sm-12">
                  <label class=" control-label"> Ursprüngliche Rechnung liegt vor (Wenn „ja“, bitte als Anlage beifügen.):
                  </label>
                  <br />
                  <div class="col-sm-6 i-checks">
                    <div class="col-sm-3">
                      <div>
                        <label class="control-label">
                          <input class="form-control" type="radio"  value="Ja" name="urspruengliche-Rechnung-liegt-vor"/> Ja </label>
                      </div>
                    </div>
                    <div class="col-sm-4">
                      <div>
                        <label class="control-label">
                          <input class="form-control" type="radio"  value="Nein" name="urspruengliche-Rechnung-liegt-vor"/> Nein </label>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="form-group col-sm-12">
                  <label> Wo und wann zuerst erschienen? </label>
                </div>
                <div class="form-group col-sm-6">
                  <label> ISBN + Titel des Lehrwerks/ der Lehrwerke </label>
                  <input type="text" class="form-control" value="{$Produkt/*:Produktnummer/normalize-space(string())}+{$Produkt//*:Kurztitel/normalize-space(string())}"/>
                </div>
                <div class="form-group col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>

                <div class="form-group col-sm-12">
                  <div class="col-sm-offset-5 col-sm-6">
                    <a href="dashboard-beschaffung/product/title/form/cancel" class="form-control-static btn btn-outline btn-primary ajax">Abbrechen</a>
                    <input class="form-control-static submit btn btn-primary" type="submit" value="Fotografie beauftragen"/>
                  </div>
                </div>

              </form>

};


declare function _:render-illustration-order-form(
    $Produkt as element(Produkt),
    $Class as xs:string?,
    $Action as item()?)
  as element(xhtml:form){
              <form id="render-illustration-order-form" xmlns="http://www.w3.org/1999/xhtml" role="form" class="ajax{if($Class) then ' '||$Class else ()}" method="POST"
              action="{$global:solutionName}/bestellung/{$Produkt/*:Produktnummer}"
              enctype="multipart/form-data">{$Action}
                <h2> Formular zur Erstellung eines Bestellvertrags für Illustration/ Grafik/ Kartografie </h2>
                <div class="form-group col-sm-6">
                  {plugin:lookup('cornelsen/contacts/form/select')!.(plugin:lookup('cornelsen/contacts')("Illustrator"), "Illustrator", ())}
                </div>
                <div class="form-group col-sm-12">
                  <label class="control-label">Rahmenvertrag<br clear="none"/></label>
                  <div class="i-checks">
                    <div class="col-sm-3">
                      <input class="form-control" type="radio"  value="Ja" name="Rahmenvertrag-liegt-vor"/>
                      <label class="control-label">liegt vor</label>

                    </div>
                    <div class="col-sm-9">
                      <input class="form-control" type="radio"  value="nein" name="Rahmenvertrag-liegt-vor"/>
                      <label class="control-label">muss erstellt werden</label>

                    </div>
                  </div>
                </div>

                <div class="form-group col-sm-12">
                  <label class="control-label">Ausgabesprache<br clear="none"/></label>
                  <div class="i-checks">
                    <div class="col-sm-3">
                      <label class="control-label"> <input class="form-control" type="radio"  value="deutsch" name="Ausgabesprache"/> Deutsch</label>
                    </div>
                    <div class="col-sm-3">
                      <label class="control-label"> <input class="form-control" type="radio"  value="englisch" name="Ausgabesprache"/> English</label>
                    </div>
                  </div>
                </div>

                <div class="row col-sm-12">
                  <div class="form-group col-sm-6">
                    <label>Titel der Lehrwerksreihe</label>
                    <input name="Titel-Lehrwerksreihe" type="text" class="form-control" value="{$Produkt//*:Reihe/normalize-space(string())}"/>
                  </div>
                </div>
                <div class="row col-sm-12">
                  <div class="form-group col-sm-6">
                    <label>Genaue Bezeichnung des Einzelwerks</label>
                    <input name="Bezeichung-Einzelwerk" type="text" class="form-control" value="{$Produkt//*:Kurztitel/normalize-space(string())}"/>
                  </div>
                </div>
                <div class="row col-sm-12">
                  <div class="form-group col-sm-6">
                    <label>ISBN</label>
                    <input name="Produktnummer" type="text" class="form-control" value="{$Produkt/*:Produktnummer/normalize-space(string())}"/>
                  </div>
                  <div class="form-group col-sm-6">
                    <label>PSP-Element</label>
                    <input type="text" class="form-control" value="{$Produkt//*:PSP-Element/string()}"/>
                  </div>
                  <div class="col-sm-12">
                    <div class="hr-line-dashed"/>
                  </div>
                </div>

                <h3 class="col-sm-12">Gegenstand der Beauftragung</h3>

                <div class="form-group col-sm-9">
                  <label class=" control-label"> Voraussichtliche Anzahl neu zu erstellender
                    Illustrationen/Grafiken </label>
                  <div class="">
                    <div class="input-group m-b">
                      <span class="input-group-addon"> Vierfarbig ca. </span>
                      <input type="number" min="0" class="form-control" style="text-align:right;"/>
                      <span class="input-group-addon"> Illustration(en)/Grafik(en) </span>
                    </div>
                    <div class="input-group m-b">
                      <span class="input-group-addon"> Graustufen ca. </span>
                      <input type="number" min="0" class="form-control" style="text-align:right;"/>
                      <span class="input-group-addon"> Illustration(en)/Grafik(en) </span>
                    </div>
                    <div class="input-group m-b">
                      <span class="input-group-addon"> Strich ca. </span>
                      <input type="number" min="0" class="form-control" style="text-align:right;"/>
                      <span class="input-group-addon"> Illustration(en)/Grafik(en) </span>
                    </div>
                  </div>
                </div>
                <div class="form-group col-sm-9">
                  <label class=" control-label"> Voraussichtliche Anzahl neu zu erstellender Karten </label>
                  <div class="">
                    <div class="input-group m-b">
                      <span class="input-group-addon"> Vierfarbig ca. </span>
                      <input type="number" min="0" class="form-control" style="text-align:right;"/>
                      <span class="input-group-addon"> Karte(n) </span>
                    </div>
                    <div class="input-group m-b">
                      <span class="input-group-addon"> Graustufen ca. </span>
                      <input type="number" min="0" class="form-control" style="text-align:right;"/>
                      <span class="input-group-addon"> Karte(n) </span>
                    </div>
                    <div class="input-group m-b">
                      <span class="input-group-addon"> Strich ca. </span>
                      <input type="number" min="0" class="form-control" style="text-align:right;"/>
                      <span class="input-group-addon"> Karte(n) </span>
                    </div>
                  </div>
                </div>

                <div class="form-group col-sm-12">
                  <label class="control-label"> Sonstiges (z.B. Bearbeitung vorhandener Grafiken etc.): </label>
                  <div class="col-sm-6 input-group">
                    <input name="Anzahl-Fotografien" type="number" min="0" max="100000" class="form-control" style="text-align:right;"/>
                  </div>
                </div>
                <div class="col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>

                <h3 class="col-sm-12">Termine</h3>
                <div class="form-group col-sm-12">
                  <table class="table">
                    <thead>
                      <tr>
                        <th class="col-sm-6">Lieferung</th>
                        <th class="col-sm-6">Datum</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>(Teil) Lieferung 1</td>
                        <td>
                          <div id="data_2" class="input-group date" data-provide="datepicker">
                            <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input type="text" class="form-control" name="Datum-Lieferung-1" value=""/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>(Teil) Lieferung 2</td>
                        <td>
                          <div id="data_2" class="input-group date" data-provide="datepicker">
                            <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input type="text" class="form-control" name="Datum-Lieferung-2" value=""/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>(Teil) Lieferung 3</td>
                        <td>
                          <div id="data_2" class="input-group date" data-provide="datepicker">
                            <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input type="text" class="form-control" name="Datum-Lieferung-3" value=""/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>(Teil) Lieferung 4</td>
                        <td>
                          <div id="data_2" class="input-group date" data-provide="datepicker">
                            <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input type="text" class="form-control" name="Datum-Lieferung-4" value=""/>
                          </div>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <div class="col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>

                <div class="form-group col-sm-12">
                  <label>Beschaffenheit der Vorlagen</label>
                  <div class="i-checks">
                    <div class="col-sm-3">
                      <p class="form-control-static">
                        <input class="form-control" type="checkbox"  value="jpeg" name="Beschaffenheit"/>
                        <label>digital</label>
                      </p>
                    </div>
                    <div class="col-sm-3">
                      <p class="form-control-static">
                        <input class="form-control" type="checkbox"  value="tiff" name="Beschaffenheit"/>
                        <label>analog</label>
                      </p>
                    </div>
                  </div>
                </div>
                <div class="form-group col-sm-12">
                  <label class="control-label"> Sonstiges (z.B. Bearbeitung vorhandener Grafiken etc.): </label>
                  <div class="col-sm-6 input-group">
                    <input name="Beschaffenheit-Sonstiges" type="number" min="0" max="100000" class="form-control" style="text-align:right;"/>
                  </div>
                </div>
                <div class="col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>
                <div class="form-group col-sm-12">
                  <h3>Vergütung</h3> <!-- TODO: ZWEI HALBE TABELLEN DARAUS MACHEN???? -->
                  <table class="table">
                    <thead>
                      <tr>
                        <th class="col-sm-7">Kategorie</th>
                        <th class="col-sm-5">Anzahl</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>1/1 Seite 4c (inkl. Grauwerte)</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-Seiten-4c" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>1/1 Seite s/w</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-Seiten-s-w" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>½ Seite 4c (inkl. Grauwerte)</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-halbe-Seiten-4c" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td> ½ Seite s/w </td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-halbe-Seiten-s-w" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td> 1/3 Seite 4c (inkl. Grauwerte) </td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-drittel-Seiten-4c" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td> 1/3 Seite s/w </td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-drittel-Seiten-s-w" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td> ¼ Seite 4c (inkl. Grauwerte) </td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-viertel-Seiten-4c" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td >¼ Seite s/w </td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-viertel-Seiten-s-w" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td> 1/8 Seite 4c (inkl. Grauwerte) </td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-viertel-Seiten-4c" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td> 1/8 Seite s/w </td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-achtel-Seiten-s-w" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Vignette</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-Vignette" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Kategorie 1</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-Kategorie-1" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Kategorie 2</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-Kategorie-2" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Kategorie 3</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-Kategorie-3" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Kategorie 4</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-Kategorie-4" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Kategorie 5</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-Kategorie-5" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Kategorie 6</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-Kategorie-6" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Kategorie 7</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-Kategorie-7" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Kategorie 8</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-Kategorie-8" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Kategorie 9</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Anzahl-Kategorie-9" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td> Einzelhonorar (z.B. Cover) </td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Vergütung-Einzelhonorar" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td> Pauschalhonorar </td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Vergütung-Pauschalhonorar" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Stundensatz</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Vergütung-Stundensatz" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>Sonstiges</td>
                        <td>
                          <div class="input-group m-b">
                            <input name="Vergütung-Sonstiges" type="number" min="0" class="form-control" style="text-align:right;"/>
                            <span class="input-group-addon"> Illustration(en) </span>
                          </div>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <div class="form-group col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>

                <div class="form-group col-sm-12">
                  <label class=" control-label"> Anzahl Belegexemplare: </label>
                  <div class="col-sm-6 input-group m-b">
                    <input name="Anzahl-Belegexemplare" type="number" min="0" max="100000" class="form-control" style="text-align:right;"/>
                    <span class="input-group-addon"> Exemplar(e) </span>
                  </div>

                </div>
                <div class="form-group col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>

                <div class="form-group col-sm-6">
                  <label>Sonstige Vereinbarung</label>
                  <textarea name="Vereinbarung-Sonstiges" class="col-sm-12 form-control" rows="4"/>
                </div>
                <div class="form-group col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>

                <div class="form-group col-sm-12">
                  <h3> Wiederverwendungen </h3>
                  <label class=" control-label"> Werk enthält Wiederverwendungen des Urhebers?
                  </label>
                  <br />
                  <div class="col-sm-12 i-checks">
                    <div class="col-sm-2">
                      <div>
                        <label class="control-label">
                          <input class="form-control" type="radio"  value="Ja" name="Werk-enthaelt-Wiederverwendungen-des-Urhebers"/> Ja </label>
                      </div>
                    </div>
                    <div class="col-sm-3">
                      <div>
                        <label class="control-label">
                          <input class="form-control" type="radio"  value="Nein" name="Werk-enthaelt-Wiederverwendungen-des-Urhebers"/> Nein </label>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="form-group col-sm-12">
                  <label class=" control-label"> Vertrag liegt vor?
                  </label>
                  <br />
                  <div class="col-sm-12 i-checks">
                    <div class="col-sm-2">
                      <div>
                        <label class="control-label">
                          <input class="form-control" type="radio"  value="Ja" name="Vertrag-fuer-Wiederverwendungen-liegt-vor"/> Ja </label>
                      </div>
                    </div>
                    <div class="col-sm-10">
                      <div>
                        <label class="control-label">
                          <input class="form-control" type="radio"  value="Nein" name="Vertrag-fuer-Wiederverwendungen-liegt-vor"/> Nein, daher Nachlizenzierung erforderlich </label>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="form-group col-sm-6">
                  <label class="control-label"> Wie viele Illustrationen sollen wiederverwendet werden? </label>
                  <div class="col-sm-12 input-group m-b">
                    <input name="Anzahl-Illustrationen-Wiederverwendung" type="number" min="0" max="100000" class="form-control" style="text-align:right;"/>
                    <span class="input-group-addon"> Illustration(en) </span>
                  </div>
                </div>
                <div class="form-group col-sm-6">
                  <label> Welche (bitte Motive bereitstellen)? </label>
                  <input name="Motive" type="text" class="form-control" />
                </div>
                <div class="form-group col-sm-12">
                  <label class=" control-label"> Ursprüngliche Rechnung liegt vor (Wenn „ja“, bitte als Anlage beifügen.):
                  </label>
                  <br />
                  <div class="col-sm-6 i-checks">
                    <div class="col-sm-3">
                      <div>
                        <label class="control-label">
                          <input class="form-control" type="radio"  value="Ja" name="Urspruengliche-Rechnung-liegt-vor"/> Ja </label>
                      </div>
                    </div>
                    <div class="col-sm-4">
                      <div>
                        <label class="control-label">
                          <input class="form-control" type="radio"  value="Nein" name="Urspruengliche-Rechnung-liegt-vor"/> Nein </label>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="form-group col-sm-12">
                  <label> Wo und wann zuerst erschienen? </label>
                </div>
                <div class="form-group col-sm-6">
                  <label> ISBN + Titel des Lehrwerks/ der Lehrwerke </label>
                  <input type="text" class="form-control" value="{$Produkt/*:Produktnummer/normalize-space(string())}+{$Produkt//*:Kurztitel/normalize-space(string())}"/>
                </div>
                <div class="form-group col-sm-12">
                  <div class="hr-line-dashed"/>
                </div>

                <div class="form-group col-sm-12">
                  <div class="col-sm-offset-5 col-sm-6">
                    <a href="dashboard-beschaffung/product/title/form/cancel" class="form-control-static btn btn-outline btn-primary ajax">Abbrechen</a>
                    <input class="form-control-static submit btn btn-primary" type="submit" value="Illustration beauftragen"/>
                  </div>
                </div>

              </form>

};

declare function _:render-audio-order-form(
    $Produkt as element(Produkt),
    $Class as xs:string?,
    $Action as item()?)
  as element(xhtml:form) {
  <form id="render-audio-order-form" xmlns="http://www.w3.org/1999/xhtml" role="form" class="ajax{if($Class) then ' '||$Class else ()}"
  method="POST"
  action="{$global:solutionName}/bestellung/{$Produkt/*:Produktnummer}"
  enctype="multipart/form-data">{$Action}

    <h2>Formular zur Erstellung eines Bestellvertrags für Audios</h2>
    <div class="form-group col-sm-6">
      {plugin:lookup('cornelsen/contacts/form/select')!.(plugin:lookup('cornelsen/contacts')("Tonstudio"), "Tonstudio", ())}
    </div>
    <div class="form-group col-sm-12">
      <label class="control-label">Rahmenvertrag<br clear="none"/></label>
      <div class="i-checks">
        <div class="col-sm-6">
          <p class="form-control-static">
            <input class="form-control" type="radio"  value="ja" name="Rahmenvertrag-liegt-vor"/>
            <label>liegt vor</label>
          </p>
        </div>
        <div class="col-sm-6">
          <p class="form-control-static">
            <input class="form-control" type="radio"  value="Nein" name="Rahmenvertrag-liegt-vor"/>
            <label>muss erstellt werden</label>
          </p>
        </div>
      </div>
    </div>

    <div class="form-group col-sm-12">
      <label class="control-label">Ausgabesprache<br clear="none"/></label>
      <div class="i-checks">
        <div class="col-sm-6">
          <p class="form-control-static">
            <input class="form-control" type="radio"  value="Deutsch" name="Ausgabesprache"/>
            <label>Deutsch</label>
          </p>
        </div>
        <div class="col-sm-6">
          <p class="form-control-static">
            <input class="form-control" type="radio"  value="Englisch" name="Ausgabesprache"/>
            <label>English</label>
          </p>
        </div>
      </div>
    </div>

    <div class="form-group col-sm-12">
      <label>Genaue Bezeichnung des Einzelwerks (Titel)</label>
      <textarea class="form-control" rows="4"/>
    </div>

    <div class="form-group col-sm-12">
      <div class="col-sm-6">
        <label>ISBN</label>
        <input name="Produktnummer" type="text" class="form-control"/>
      </div>
      <div class="col-sm-6">
        <label>PSP-Element</label>
        <input name="PSP-Element" type="text" class="form-control"/>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <div class="form-group col-sm-12">
      <label >Gegenstand der Beauftragung</label>
      <div class="col-sm-6">
        <p class="form-control-static col-sm-12">voraussichtliche Anzahl der Tracks</p>
      </div>
      <div class="col-sm-6">
        <input name="Anzahl-Tracks" type="text" class="form-control"/>
      </div>

      <div class="col-sm-6">
        <p class="form-control-static">voraussichtliche Anzahl der Minuten (insgesamt)</p>
      </div>
      <div class="col-sm-6">
        <input name="Anzahl-Minuten" type="text" class="form-control"/>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <div class="form-group col-sm-12">
      <h3>Termine</h3>
      <div class="col-sm-6">
        <p class="form-control-static col-sm-12">Erscheinungstermin</p>
      </div>
      <div class="col-sm-offset-3 col-sm-3">
        <input name="SOLL-Erscheinungstermin" type="text" class="form-control"/>
      </div>

      <div class="col-sm-6">
        <p class="form-control-static col-sm-12">Abnahme der Endfassung durch die Redaktion</p>
      </div>
      <div class="col-sm-offset-3 col-sm-3">
        <input name="Abnahme-Endfassung" type="text" class="form-control"/>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <div class="form-group col-sm-12">
      <label class="col-sm-12">Sprecher</label>
      <div class="col-sm-6">
        <p class="form-control-static col-sm-12">Anzahl der Sprecher</p>
      </div>
      <div class="col-sm-offset-3 col-sm-3">
        <input name="Anzahl-Sprecher" type="text" class="form-control"/>
      </div>

      <div class="col-sm-6">
        <p class="form-control-static col-sm-12">davon Kinder / Jugendliche</p>
      </div>
      <div class="col-sm-offset-3 col-sm-3">
        <input type="text" class="form-control"/>
      </div>

      <div class="col-sm-7">
        <p class="form-control-static col-sm-12">Die Beauftragung der Sprecher erfolgt durch</p>
      </div>
      <div class="i-checks">
        <div class="col-sm-2">
          <p class="form-control-static">
            <input class="form-control" type="radio"  value="Verlag" name="Beauftragung-der-Sprecher-durch"/>
            <label>den Verlag</label>
          </p>
        </div>
        <div class="col-sm-3">
          <p class="form-control-static">
            <input class="form-control" type="radio"  value="Tonstudio" name="Beauftragung-der-Sprecher-durch"/>
            <label>das Tonstudio</label>
          </p>
        </div>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <div class="form-group col-sm-12">
      <label>sonstige Vereinbarungen</label>
      <div class="col-sm-7">
        <p class="form-control-static col-sm-12">Anfertigung eines Manuskripts für Tonaufnahmen</p>
      </div>
      <div class="i-checks">
        <div class="col-sm-2">
          <p class="form-control-static">
            <input class="form-control" type="radio"  value="ja" name="anfertigung-eines-Manuskripts-fuer-tonaufnahmen"/>
            <label>ja</label>
          </p>
        </div>
        <div class="col-sm-3">
          <p class="form-control-static">
            <input class="form-control" type="radio"  value="nein" name="anfertigung-eines-Manuskripts-fuer-tonaufnahmen"/>
            <label>nein</label>
          </p>
        </div>
      </div>

      <div class="col-sm-7">
        <p class="form-control-static col-sm-12">Komposition von Musik</p>
      </div>
      <div class="i-checks">
        <div class="col-sm-2">
          <p class="form-control-static">
            <input class="form-control" type="radio"  value="ja" name="komposition-von-musik"/>
            <label>ja</label>
          </p>
        </div>
        <div class="col-sm-3">
          <p class="form-control-static">
            <input class="form-control" type="radio"  value="nein" name="komposition-von-musik"/>
            <label>nein</label>
          </p>
        </div>
      </div>

      <div class="col-sm-7">
        <p class="form-control-static col-sm-12">Verwendung von Spezialeffekten (Geräusche, Sound)</p>
      </div>
      <div class="i-checks">
        <div class="col-sm-2">
          <p class="form-control-static">
            <input class="form-control" type="radio"  value="ja" name="verwendung-von-spezialeffekten"/>
            <label>ja</label>
          </p>
        </div>
        <div class="col-sm-3">
          <p class="form-control-static">
            <input class="form-control" type="radio"  value="nein" name="verwendung-von-spezialeffekten"/>
            <label>nein</label>
          </p>
        </div>
      </div>

      <div class="col-sm-7">
        <p class="form-control-static col-sm-12">Externe Regieleistung</p>
      </div>
      <div class="i-checks">
        <div class="col-sm-2">
          <p class="form-control-static">
            <input class="form-control" type="radio"  value="ja" name="externe-regieleistung"/>
            <label>ja</label>
          </p>
        </div>
        <div class="col-sm-3">
          <p class="form-control-static">
            <input class="form-control" type="radio"  value="nein" name="externe-regieleistung"/>
            <label>nein</label>
          </p>
        </div>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <div class="form-group col-sm-12">
      <div class="col-sm-12">
        <label class="control-label">Nutzungsbereich<br clear="none"/></label>
        <div class="col-sm-12">
          <div class="i-checks">
            <p class="form-control-static">
              <input class="form-control" type="checkbox"  value="audio-cd" name="Ausgabesprache"/>
              <label>Audio-CD</label>
            </p>
            <p class="form-control-static">
              <input class="form-control" type="checkbox"  value="cd-dvd" name="Ausgabesprache"/>
              <label>CD-ROM / DVD-ROM</label>
            </p>
            <p class="form-control-static">
              <input class="form-control" type="checkbox"  value="video-dvd" name="Ausgabesprache"/>
              <label>Video-DVD</label>
            </p>
            <p class="form-control-static">
              <input class="form-control" type="checkbox"  value="online" name="Ausgabesprache"/>
              <label>Online (Streaming)</label>
            </p>
            <p class="form-control-static">
              <input class="form-control" type="checkbox"  value="offline" name="Ausgabesprache"/>
              <label>Offline (nach Download)</label>
            </p>
            <p class="form-control-static">
              <input class="form-control" type="checkbox"  value="app" name="Ausgabesprache"/>
              <label>App</label>
            </p>
          </div>
        </div>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <div class="form-group col-sm-12">
      <h3>Vergütung</h3>
      <div class="col-sm-12" style="margin-bottom:10px;">
        <p class="form-control-static col-sm-7">Vergütung gemäß Rahmenvertrag von insgesamt voraussichtlich</p>
        <div class="col-sm-offset-2 col-sm-3">
          <div class="input-group">
            <input type="text" class="form-control"/>
            <span class="input-group-addon"><i class="fa fa-eur" aria-hidden="true"></i></span>
          </div>
        </div>
      </div>
      <div class="col-sm-12">
        <p class="form-control-static col-sm-7">davon ggf. Regiehonorar:</p>
        <div class="col-sm-offset-2 col-sm-3">
          <div class="input-group">
            <input type="text" class="form-control"/>
            <span class="input-group-addon"><i class="fa fa-eur" aria-hidden="true"></i></span>
          </div>
        </div>
      </div>
      <div class="col-sm-12">
        <p class="form-control-static col-sm-7">Sprecherhonorar:</p>
        <div class="col-sm-offset-2 col-sm-3">
          <div class="input-group">
            <input type="text" class="form-control"/>
            <span class="input-group-addon"><i class="fa fa-eur" aria-hidden="true"></i></span>
          </div>
        </div>
      </div>
      <div class="col-sm-12">
        <p class="form-control-static col-sm-7">sonstige Leistung:</p>
        <div class="col-sm-offset-2 col-sm-3">
          <div class="input-group">
            <input type="text" class="form-control"/>
            <span class="input-group-addon"><i class="fa fa-eur" aria-hidden="true"></i></span>
          </div>
        </div>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <div class="form-group col-sm-12">
      <label class="col-sm-12">Master-Erstellung</label>
      <div class="col-sm-7">
        <p class="form-control-static col-sm-12">Ist eine Master-Erstellung durch Fa. FKW-Medien geplant?</p>
      </div>
      <div class="i-checks">
        <div class="col-sm-2">
          <p class="form-control-static">
            <input class="form-control" type="radio"  value="ja" name="master-erstellung-durch-fkw-medien-geplant"/>
            <label>ja</label>
          </p>
        </div>
        <div class="col-sm-3">
          <p class="form-control-static">
            <input class="form-control" type="radio"  value="nein" name="master-erstellung-durch-fkw-medien-geplant"/>
            <label>nein</label>
          </p>
        </div>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <div class="form-group col-sm-6">
      <label>Anmerkungen</label>
      <textarea class="col-sm-12 form-control" rows="4"/>
    </div>
    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <div class="form-group col-sm-12">
      <label class="col-sm-12">Anlagen</label>
      <div class="col-sm-12">
        <p class="form-control-static col-sm-12">Bitte fügen Sie dem Formular per Mail unbedingt folgende Anlagen bei:</p>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <div class="form-group col-sm-12">
      <!--      <div class="col-sm-6">
        <input type="text" class="form-control"/>
        <span class="help-block m-b-none">Datum, Name Redakteur/in, Geschäftsbereich</span>
      </div>-->
      <div class="col-sm-offset-6 col-sm-6">
        <div class="pull-right">
          <a href="dashboard-beschaffung/product/title/form/cancel" class="form-control-static btn btn-outline btn-primary  ajax">Abbrechen</a>
          <input class="submit btn btn-primary" type="submit" value="Audiomedien beauftragen"/>
        </div>
      </div>
    </div>
  </form>
};


declare function _:render-video-order-form(
    $Produkt as element(Produkt),
    $Class as xs:string?,
    $Action as item()?)
  as element(xhtml:form) {
  <form id="render-video-order-form" xmlns="http://www.w3.org/1999/xhtml" role="form" class="ajax" method="POST"
  action="{$global:solutionName}/bestellung/{$Produkt/*:Produktnummer}"
  enctype="multipart/form-data">
    <h2> Formular zur Erstellung eines Bestellvertrags für Videos </h2>
    <div class="form-group col-sm-6">
      {plugin:lookup('cornelsen/contacts/form/select')!.(plugin:lookup('cornelsen/contacts')("Agentur"), "Agentur", ())}
    </div>
    <div class="form-group col-sm-12">
      <label class="control-label">Rahmenvertrag<br clear="none"/></label>
      <div class="i-checks">
        <div class="col-sm-3">
          <input class="form-control" type="radio"  value="Ja" name="Rahmenvertrag-liegt-vor"/>
          <label class="control-label">liegt vor</label>

        </div>
        <div class="col-sm-9">
          <input class="form-control" type="radio"  value="nein" name="Rahmenvertrag-liegt-vor"/>
          <label class="control-label">muss erstellt werden</label>

        </div>
      </div>
    </div>

    <div class="form-group col-sm-12">
      <label class="control-label">Ausgabesprache<br clear="none"/></label>
      <div class="i-checks">
        <div class="col-sm-3">
          <label class="control-label"> <input class="form-control" type="radio"  value="deutsch" name="Ausgabesprache"/> Deutsch</label>
        </div>
        <div class="col-sm-3">
          <label class="control-label"> <input class="form-control" type="radio"  value="englisch" name="Ausgabesprache"/> English</label>
        </div>
        <div class="col-sm-3">
          <label class="control-label"> <input class="form-control" type="radio"  value="spanisch" name="Ausgabesprache"/> Spanisch</label>
        </div>
      </div>
    </div>

    <div class="row col-sm-12">
      <div class="form-group col-sm-6">
        <label>Titel der Lehrwerksreihe</label>
        <input name="Titel-Lehrwerksreihe" type="text" class="form-control" value="{$Produkt//*:Reihe/normalize-space(string())}"/>
      </div>
    </div>
    <div class="row col-sm-12">
      <div class="form-group col-sm-6">
        <label>Genaue Bezeichnung des Einzelwerks</label>
        <input name="Bezeichung-Einzelwerk" type="text" class="form-control" value="{$Produkt//*:Kurztitel/normalize-space(string())}"/>
      </div>
    </div>
    <div class="row col-sm-12">
      <div class="form-group col-sm-offset-6 col-sm-6">
        <label>ISBN</label>
        <input name="Produktnummer" type="text" class="form-control" value="{$Produkt/*:Produktnummer/normalize-space(string())}"/>
      </div>
      <div class="form-group col-sm-6">
        <label>PSP-Element</label>
        <input type="text" class="form-control" value="{$Produkt//*:PSP-Element/string()}"/>
      </div>
      <div class="col-sm-12">
        <div class="hr-line-dashed"/>
      </div>
    </div>

    <h3 class="col-sm-12">Gegenstand der Beauftragung</h3>
    <div class="form-group col-sm-12">
      <table id="dynamicTable" class="table">
        <thead>
          <tr>
            <th class="col-sm-4"> Clip Nr. </th>
            <th class="col-sm-4"> Dauer in Minuten </th>
            <th class="col-sm-4"> Actions </th>
          </tr>
        </thead>
        <tbody id="dynamicTableBody">
          <tr>
            <td>
              <div class="input-group">
                <input name="" type="text" class="form-control"/>
              </div>
            </td>
            <td>
              <div class="input-group">
                <input name="K" type="text" class="form-control" />
              </div>
            </td>
            <td>
              <button type="button" class="btn btn-xs btn-primary" onclick="addRow();">
                <span class="glyphicon glyphicon-plus"></span> Hinzufügen
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <h3 class="col-sm-12">Termine</h3>
    <div class="row col-sm-12">
      <div class="form-group col-sm-6">
        <label class="control-label">Erscheinungstermin</label>
        <div class="" id="data_2">
          <div class="input-group date">
            <span class="input-group-addon">
              <i class="fa fa-calendar"/>
            </span>
            <input name="SOLL-Erscheinungstermin" type="text" class="form-control" value="{
              if ($Produkt/*:Erscheinungstermine/*:SollErscheinung/string()) then
                let $unformattedDate := tokenize($Produkt/*:Erscheinungstermine/*:SollErscheinung/string(), '-')
                let $year := $unformattedDate[1]
                let $month := $unformattedDate[2]
                let $day := $unformattedDate[3]
                let $date := functx:date($year, $month, $day)
                return fn:format-date($date, "[D01].[M01].[Y0001]")
              else ()
            }" />
          </div>
        </div>
      </div>
    </div>

    <div class="form-group col-sm-6">
      <label class=" control-label">Termin Sichtung Rohfassung</label>
      <div class="" id="data_2">
        <div class="input-group date">
          <span class="input-group-addon">
            <i class="fa fa-calendar"/>
          </span>
          <input name="Termin-Sichtung-Rohfassung" type="text" class="form-control" />
        </div>
      </div>
    </div>
    <div class="form-group col-sm-6">
      <label class=" control-label">Termin Sichtung Endfassung</label>
      <div class="" id="data_2">
        <div class="input-group date">
          <span class="input-group-addon">
            <i class="fa fa-calendar"/>
          </span>
          <input name="Termin-Sichtung-Endfassung" type="text" class="form-control" />
        </div>
      </div>
    </div>
    <div class="form-group col-sm-6">
      <label>Drehzeit / -periode / -ort</label>
      <textarea class="col-sm-12 form-control" rows="4"/>
    </div>
    <div class="form-group col-sm-12">
      <label class=" control-label"> Drehbuch liegt vor?
      </label>
      <br />
      <div class="col-sm-12 i-checks">
        <div class="col-sm-2">
          <div>
            <label class="control-label">
              <input class="form-control" type="radio"  value="Ja" name="Drehbuch-liegt-vor"/> Ja </label>
          </div>
        </div>
        <div class="col-sm-10">
          <div>
            <label class="control-label">
              <input class="form-control" type="radio"  value="Nein" name="Drehbuch-liegt-vor"/> Nein, daher Nachlizenzierung erforderlich </label>
          </div>
        </div>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <label class=" control-label"> Drehplan liegt vor? (Wenn „ja“, bitte als Anlage beifügen.)
      </label>
      <br />
      <div class="col-sm-12 i-checks">
        <div class="col-sm-2">
          <div>
            <label class="control-label">
              <input class="form-control" type="radio"  value="Ja" name="Drehplan-liegt-vor"/> Ja </label>
          </div>
        </div>
        <div class="col-sm-3">
          <div>
            <label class="control-label">
              <input class="form-control" type="radio"  value="Nein" name="Drehplan-liegt-vor"/> Nein </label>
          </div>
        </div>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <h3 class="col-sm-12"> Darsteller </h3>
    <div class="form-group col-sm-12">
      <label class=" control-label"> Anzahl der Darsteller: </label>
      <div class="col-sm-6 input-group m-b">
        <input name="Anzahl-Belegexemplare" type="number" min="0" max="100000" class="form-control" style="text-align:right;"/>
        <span class="input-group-addon"> Darsteller </span>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <label class=" control-label"> Darunter Anzahl der Erwachsenen: </label>
      <div class="col-sm-6 input-group m-b">
        <input name="Anzahl-Belegexemplare" type="number" min="0" max="100000" class="form-control" style="text-align:right;"/>
        <span class="input-group-addon"> Erwachsene(r) </span>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <label class=" control-label"> Darunter Anzahl der Kinder von 3 bis 6 Jahren: </label>
      <div class="col-sm-6 input-group m-b">
        <input name="Anzahl-Belegexemplare" type="number" min="0" max="100000" class="form-control" style="text-align:right;"/>
        <span class="input-group-addon"> Kind(er) </span>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <label class=" control-label"> Darunter Anzahl der Kinder unter 3 Jahren unter den Darstellern: </label>
      <div class="col-sm-6 input-group m-b">
        <input name="Anzahl-Belegexemplare" type="number" min="0" max="100000" class="form-control" style="text-align:right;"/>
        <span class="input-group-addon"> Kleinkind(er) </span>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <label class=" control-label"> Darunter Anzahl der Kinder von 6 Jahren und Jugendlichen bis zur Beendigung der Vollzeitschulpflicht: </label>
      <div class="col-sm-6 input-group m-b">
        <input name="Anzahl-Belegexemplare" type="number" min="0" max="100000" class="form-control" style="text-align:right;"/>
        <span class="input-group-addon"> Erwachsene(r) </span>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <label class=" control-label"> Darunter Anzahl der Kinder / Jugendliche, die die Vollzeitschulpflicht beendeten, aber noch nicht 18 Jahre alt sind: </label>
      <div class="col-sm-6 input-group m-b">
        <input name="Anzahl-Belegexemplare" type="number" min="0" max="100000" class="form-control" style="text-align:right;"/>
        <span class="input-group-addon"> Erwachsene(r) </span>
      </div>
    </div>

    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>
    <h3 class="col-sm-12"> Filmstab </h3>
    <div class="row col-sm-12">
      <div class="form-group col-sm-6">
        <label class="control-label"> Drehbuchautor </label>
        <div class="col-sm-12 input-group m-b">
          <input name="Drehbuchautor" type="text" class="form-control"/>
        </div>
      </div>
      <div class="form-group col-sm-6">
        <label class="control-label">Nennungspflichtig?<br clear="none"/></label>
        <div class="i-checks">
          <div class="col-sm-3">
            <input class="form-control" type="radio"  value="Ja" name="Drehbuchautor-nennungspflichtig"/>
            <label class="control-label">Ja</label>

          </div>
          <div class="col-sm-9">
            <input class="form-control" type="radio"  value="nein" name="Drehbuchautor-nennungspflichtig"/>
            <label class="control-label">Nein</label>

          </div>
        </div>
      </div>
    </div>
    <div class="row col-sm-12">
      <div class="form-group col-sm-6">
        <label class="control-label"> Regie </label>
        <div class="col-sm-12 input-group m-b">
          <input name="Regie" type="text" class="form-control"/>
        </div>
      </div>
      <div class="form-group col-sm-6">
        <label class="control-label">Nennungspflichtig?<br clear="none"/></label>
        <div class="i-checks">
          <div class="col-sm-3">
            <input class="form-control" type="radio"  value="Ja" name="Regie-nennungspflichtig"/>
            <label class="control-label">Ja</label>

          </div>
          <div class="col-sm-9">
            <input class="form-control" type="radio"  value="nein" name="Regie-nennungspflichtig"/>
            <label class="control-label">Nein</label>

          </div>
        </div>
      </div>
    </div>
    <div class="row col-sm-12">
      <div class="form-group col-sm-6">
        <label class="control-label"> Kamera </label>
        <div class="col-sm-12 input-group m-b">
          <input name="Kamera" type="text" class="form-control"/>
        </div>
      </div>
      <div class="form-group col-sm-6">
        <label class="control-label">Nennungspflichtig?<br clear="none"/></label>
        <div class="i-checks">
          <div class="col-sm-3">
            <input class="form-control" type="radio"  value="Ja" name="Kamera-nennungspflichtig"/>
            <label class="control-label">Ja</label>

          </div>
          <div class="col-sm-9">
            <input class="form-control" type="radio"  value="nein" name="Kamera-nennungspflichtig"/>
            <label class="control-label">Nein</label>

          </div>
        </div>
      </div>
    </div>
    <div class="row col-sm-12">
      <div class="form-group col-sm-6">
        <label class="control-label"> Schnitt </label>
        <div class="col-sm-12 input-group m-b">
          <input name="Schnitt" type="text" class="form-control"/>
        </div>
      </div>
      <div class="form-group col-sm-6">
        <label class="control-label">Nennungspflichtig?<br clear="none"/></label>
        <div class="i-checks">
          <div class="col-sm-3">
            <input class="form-control" type="radio"  value="Ja" name="Schnitt-nennungspflichtig"/>
            <label class="control-label">Ja</label>

          </div>
          <div class="col-sm-9">
            <input class="form-control" type="radio"  value="nein" name="Schnitt-nennungspflichtig"/>
            <label class="control-label">Nein</label>

          </div>
        </div>
      </div>
    </div>
    <div class="row col-sm-12">
      <div class="form-group col-sm-6">
        <label class="control-label"> Aufnahmeleiter </label>
        <div class="col-sm-12 input-group m-b">
          <input name="Drehbuchautor" type="text" class="form-control"/>
        </div>
      </div>
      <div class="form-group col-sm-6">
        <label class="control-label">Nennungspflichtig?<br clear="none"/></label>
        <div class="i-checks">
          <div class="col-sm-3">
            <input class="form-control" type="radio"  value="Ja" name="Aufnahmeleiter-nennungspflichtig"/>
            <label class="control-label">Ja</label>

          </div>
          <div class="col-sm-9">
            <input class="form-control" type="radio"  value="nein" name="Aufnahmeleiter-nennungspflichtig"/>
            <label class="control-label">Nein</label>

          </div>
        </div>
      </div>
    </div>

    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>
    <div class="form-group col-sm-12">
      <label class=" control-label"> Nutzungsbereich <br clear="none"/>
      </label>
      <div class="">
        <div class="i-checks">
          <div class="col-sm-4">
            <label class="control-label"> <input class="form-control" type="checkbox"  value="CD" name="Nutzungsbereich"/> CD </label>
          </div>
          <div class="col-sm-4">
            <label class="control-label"> <input class="form-control" type="checkbox"  value="DVD" name="Nutzungsbereich"/> DVD </label>
          </div>
          <div class="col-sm-4">
            <label class="control-label"> <input class="form-control" type="checkbox"  value="UMA-auf-CD-DVD" name="Nutzungsbereich"/> UMA auf CD/DVD </label>
          </div>
          <div class="col-sm-4">
            <label class="control-label"> <input class="form-control" type="checkbox"  value="UMA-scook-Streaming" name="Nutzungsbereich"/> UMA/scook – Streaming </label>
          </div>
          <div class="col-sm-4">
            <label class="control-label"> <input class="form-control" type="checkbox"  value="UMA-scook-Download" name="Nutzungsbereich"/> UMA/scook – Download </label>
          </div>
          <div class="col-sm-4">
            <label class="control-label"> <input class="form-control" type="checkbox"  value="Offline-Client" name="Nutzungsbereich"/> Offline Client </label>
          </div>
          <div class="col-sm-4">
            <label class="control-label"> <input class="form-control" type="checkbox"  value="Materialspalte-Schüler" name="Nutzungsbereich"/> Materialspalte Schüler </label>
          </div>
          <div class="col-sm-4">
            <label class="control-label"> <input class="form-control" type="checkbox"  value="Download" name="Nutzungsbereich"/> Download cornelsen.de </label>
          </div>
          <div class="col-sm-4" style="margin-bottom: 10px;">
            <label class="control-label"> Sonstiges (z.B. App):
              <input class="col-sm-offset-2 form-control" type="text" name="Zusatz-Werbung" style="width: 75%;"/>
            </label>
          </div>
        </div>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <div class="form-group col-sm-12">
      <h3> Budget </h3>
      <label class="control-label"> Höhe des Gesamtbudgets für die Leistungen des Auftragnehmers: </label>
      <div class="col-sm-6 input-group">
        <input name="Anzahl-Fotografien" type="number" min="0" max="100000" class="form-control" style="text-align:right;"/>
        <span class="input-group-addon"><i class="fa fa-eur" aria-hidden="true"></i></span>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <label class=" control-label"> Kalkulation liegt vor?
      </label>
      <br />
      <div class="col-sm-12 i-checks">
        <div class="col-sm-2">
          <div>
            <label class="control-label">
              <input class="form-control" type="radio"  value="Ja" name="Kalkulation-liegt-vor"/> Ja </label>
          </div>
        </div>
        <div class="col-sm-10">
          <div>
            <label class="control-label">
              <input class="form-control" type="radio"  value="Nein" name="Kalkulation-liegt-vor"/> Nein </label>
          </div>
        </div>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <div class="form-group col-sm-12">
      <h3> Vergütung </h3>
      <label class="control-label"> Gemäß vereinbarter Kalkulation und auf Grundlage des Rahmenvertrages Vergütung von insgesamt voraussichtlich: </label>
      <div class="col-sm-6 input-group">
        <input name="Vergütung" type="number" min="0" max="100000" class="form-control" style="text-align:right;"/>
        <span class="input-group-addon"><i class="fa fa-eur" aria-hidden="true"></i></span>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <div class="form-group col-sm-6">
      <label>Hinweise zum Material (Abweichung zu der Rahmenvertragsvereinbarung)</label>
      <textarea class="col-sm-12 form-control" rows="4"/>
    </div>
    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <div class="form-group col-sm-12">
      <h3> Referenzverwendung </h3>
      <label class=" control-label"> Soll eine Referenzverwendung gestattet werden?
      </label>
      <br />
      <div class="col-sm-12 i-checks">
        <div class="col-sm-2">
          <div>
            <label class="control-label">
              <input class="form-control" type="radio"  value="Ja" name="Referenzverwendung"/> Ja </label>
          </div>
        </div>
        <div class="col-sm-10">
          <div>
            <label class="control-label">
              <input class="form-control" type="radio"  value="Nein" name="Referenzverwendung"/> Nein </label>
          </div>
        </div>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <div class="form-group col-sm-12">
      <label class=" control-label"> Anzahl der Belegexemplare: </label>
      <div class="col-sm-6 input-group m-b">
        <input name="Anzahl-Belegexemplare" type="number" min="0" max="100000" class="form-control" style="text-align:right;"/>
        <span class="input-group-addon"> Exemplar(e) </span>
      </div>
    </div>
    <div class="row col-sm-6">
      <div class="form-group col-sm-12">
        <label class=" control-label">  Produktionsfirma bekannt?
        </label>
        <br />
        <div class="col-sm-3">
          <div class="i-checks">
            <div>
              <label class="control-label"> <input class="form-control" type="radio"  value="Ja" name="Produktionsfirma-bekannt"/> Ja </label>
            </div>
          </div>
        </div>
        <div class="col-sm-4">
          <div class="i-checks">
            <div>
              <label class="control-label"> <input class="form-control" type="radio"  value="Nein" name="Produktionsfirma-bekannt"/> Nein </label>
            </div>
          </div>
        </div>
        <label class=" control-label">  </label>
      </div>
      <div class="form-group col-sm-12">
        <label class="control-label"> Name der Produktionsfirma: </label>
        <div class="col-sm-12 input-group m-b">
          <input name="Produktionsfirma" type="text" class="form-control"/>
        </div>
      </div>
    </div>
    <div class="row col-sm-6">
      <div class="form-group col-sm-12">
        <label class=" control-label">  Mitwirkende/Schauspieler bekannt?
        </label>
        <br />
        <div class="col-sm-3">
          <div class="i-checks">
            <div>
              <label class="control-label"> <input class="form-control" type="radio"  value="Ja" name="Mitwirkende-bekannt"/> Ja </label>
            </div>
          </div>
        </div>
        <div class="col-sm-4">
          <div class="i-checks">
            <div>
              <label class="control-label"> <input class="form-control" type="radio"  value="Nein" name="Mitwirkende-bekannt"/> Nein </label>
            </div>
          </div>
        </div>
        <label class=" control-label">  </label>
      </div>
      <div class="form-group col-sm-12">
        <label class="control-label"> Namen der Mitwirkenden/Schauspieler: </label>
        <div class="col-sm-12 input-group m-b">
          <input name="Mitwirkende" type="text" class="form-control"/>
        </div>
      </div>
    </div>
    <div class="form-group col-sm-12">
      <div class="hr-line-dashed"/>
    </div>

    <div class="form-group col-sm-12">
      <div class="col-sm-offset-5 col-sm-6">
        <a href="dashboard-beschaffung/product/title/form/cancel" class="form-control-static btn btn-outline btn-primary ajax">Abbrechen</a>
        <input class="form-control-static submit btn btn-primary" type="submit" value="Video beauftragen"/>
      </div>
    </div>
    <script type="text/javascript" src="{$_:staticPath}/js/dynamic-table.js"/>
  </form>
};