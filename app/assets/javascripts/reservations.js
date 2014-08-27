angular.module("admin-reservation-index", [])
.controller("indexCtrl", function ($scope) {
	
	$scope.test = "Hello world";
});

$(".check").click(function() {
    if (!$('input.check[type=checkbox]:not(:checked)').length)
        document.getElementById("checkout_button").disabled=false;
    else
        document.getElementById("checkout_button").disabled=true;
});