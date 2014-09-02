$('#select_all_equipment').click ->
	$('.equipment_select').prop('checked', $('#select_all_equipment').is(':checked'));

$('#select_all_users').click ->
	$('.user-select').prop('checked', $('#select_all_users').is(':checked'));