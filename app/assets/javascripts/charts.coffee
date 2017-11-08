$(document).on "turbolinks:load", ->
  $("#resetDates").click () ->
    window.location = window.location.pathname + "?" + $.param(initParams)
  # console.log consumptionData