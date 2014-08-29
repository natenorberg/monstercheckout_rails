angular.module("admin-reservation-index", [])
.controller("indexCtrl", function ($scope) {
	
	$scope.test = "Hello world";
});

$(".check").click(function() {
    if (!$('input.check[type=checkbox]:not(:checked)').length) {
        document.getElementById("checkout_button").disabled=false;
	    $("#check_out_comments_field").show();
	}
    else
        document.getElementById("checkout_button").disabled=true;
});

$( document ).ready(function() {
  $("#check_out_comments_field").hide();
  $("#check_in_comments_field").hide();
});