# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $("input.datetimepicker").datetimepicker({
    format: 'yyyy-mm-dd hh:ii z',
    minuteStep: 15,
    autoclose: true,
  });
  $("select.select2").select2();

