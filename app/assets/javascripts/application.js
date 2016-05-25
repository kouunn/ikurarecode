// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks

//= require paper/loader
//= require paper/bootswatch

//= require nprogress
//= require nprogress-turbolinks

//汇率计算
function rmbtojpy(str)
{
if (str.length==0)
  { 
  document.getElementById("exchanginput").innerHTML="";
  return;
  }

result = document.getElementById("exchangerate").innerHTML*str/100;
document.getElementById("exchanginput").innerHTML=result.toFixed(2)+"元";
}

function jpytormb(str)
{
if (str.length==0)
  { 
  document.getElementById("exchanginput").innerHTML="";
  return;
  }

result = str*100/document.getElementById("exchangerate").innerHTML;
document.getElementById("exchanginput").innerHTML=result.toFixed(2)+"日元";
}