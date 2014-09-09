# Initialization
$(document).ready ->
  $('#comments_field').hide()
  toggleSubItems()

# Initialize timepickers
$('#reservation_out_time').datetimepicker();
$('#reservation_in_time').datetimepicker();

# Block out dates on paired timepickers so that they can't overlap
$("#reservation_out_time").on "dp.change", (e) ->
  $("#reservation_in_time").data("DateTimePicker").setMinDate e.date
  return

$("#reservation_in_time").on "dp.change", (e) ->
  $("#reservation_out_time").data("DateTimePicker").setMaxDate e.date
  return

# If the user clicks on the checkbox for a kit, show/hide additional options
$('.kit-checkbox').click ->
  toggleSubItems()

  targetId = '#sub_item_list_' + this.value
  if this.checked
    $(targetId).show()
  else
    $(targetId).hide()

# Check if there are any kits checked and handle the expanding and collapsing
toggleSubItems = ->
  if $('input.kit-checkbox[type=checkbox]:checked').length
    $('#equipment_list').addClass('col-sm-7')
    $('#sub_item_list').show()
  else
    $('#equipment_list').removeClass('col-sm-7')
    $('#sub_item_list').hide()

# Don't let the lab monitor check out things without going through the checklist
$(".check").click ->
  unless $("input.check[type=checkbox]:not(:checked)").length
    document.getElementById("submit_button").disabled = false
    $("#comments_field").show()
  else
    document.getElementById("submit_button").disabled = true
  return