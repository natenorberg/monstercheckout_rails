angular.module("admin-reservation-index", [])
.controller("indexCtrl", function ($scope) {
	
	$scope.test = "Hello world";
});

$(".check").click(function() {
    if (!$('input.check[type=checkbox]:not(:checked)').length) {
        document.getElementById("submit_button").disabled=false;
	    $("#comments_field").show();
	}
    else
        document.getElementById("submit_button").disabled=true;
});

$( document ).ready(function() {
  $("#comments_field").hide();
  $("#comments_field").hide();
});