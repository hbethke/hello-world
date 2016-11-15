module namespace _="process/beschaffung/standardmedien";
import module namespace global  ='influx/global';
import module namespace plugin='influx/plugin';
import module namespace ui    ='influx/ui';

declare namespace html = "http://www.w3.org/1999/xhtml";


declare %plugin:provide('side-navigation')
  function _:nav-item() 
  as element(html:li) {
  <li xmlns="http://www.w3.org/1999/xhtml" data-parent="/config" data-sortkey="process-beschaffung-standardmedien">
      <a href="{$global:solutionName}/config/process-beschaffung-standardmedien"><i class="fa fa-cogs"></i> <span class="nav-label">Beschaffung Standardmedien</span></a>
  </li>
};
