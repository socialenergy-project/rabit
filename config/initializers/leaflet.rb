
Leaflet.tile_layer = "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=#{ENV['MAPBOX_API_KEY']}"
# You can also use any other tile layer here if you don't want to use Cloudmade - see http://leafletjs.com/reference.html#tilelayer for more
Leaflet.attribution = 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>'
Leaflet.max_zoom = 18
# Leaflet.tile_layer = "http://{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png"
Leaflet.subdomains = ['otile1', 'otile2', 'otile3', 'otile4']
# Leaflet.tileSize = 512
# Leaflet.zoomOffset = -1
