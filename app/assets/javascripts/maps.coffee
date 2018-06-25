App.map ||= {}
App.map.register = (map_hash) ->
  $(document).on "turbolinks:load", ->
    $("#reset-map").off('click').click (event) ->
      if map_hash.fitbounds
        map.fitBounds map_hash.fitbounds
      else
        map.setView map_hash.center.latlng, map_hash.center.zoom
      false