App.map ||= {}
App.map.register = (map_hash) ->
  $.ready ->
    $("#reset-map").click ->
      if map_hash.fitBounds
        map.fitBounds bounds
      else
        map.setView new L.LatLng map_hash.center.latlng, map_hash.center.zoom
      false