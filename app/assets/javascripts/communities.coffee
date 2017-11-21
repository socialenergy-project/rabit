# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.disable_consumers = (current_clustering, clustering_communities) ->
  $('#community_consumers option').each () ->
    $(this).attr("disabled", +this.getAttribute("value") in clustering_communities[current_clustering] )

$(document).on "turbolinks:load", ->
  $("#community_clustering_id").change () ->
    disable_consumers(+this.value, window.clustering_info)
  disable_consumers(+$("#community_clustering_id").val(), window.clustering_info)
