App.chart_view ||= {}
App.chart_view.ajax_params ||= []


hide_and_show = ->
  if $('#type-selector').val() == 'Real-time'
    $('.historical').hide()
    $('.real-time').show()
  else
    $('.historical').show()
    $('.real-time').hide()
  return

refresh_charts = (ch_params) ->
  # console.log 'ajax_params=',  App.chart_view.ajax_params
  for k of  App.chart_view.ajax_params
    v = App.chart_view.ajax_params[k]
    # console.log 'v=', v
    getdata v.dom_id, v.entity, ch_params
  return

get_search_path = ->
  search_str = location.search.substring(1)
  # console.log 'search_str:', search_str
  if search_str then JSON.parse('{"' + decodeURIComponent(search_str.replace(/"/g, '\"').replace(/&/g, '","').replace(RegExp('=', 'g'), '":"')) + '"}') else {}

strip_date = (x) ->
  x.replace(/[ ]/, 'T').substring(0,16)

equal_params = (current_search, ch_params) ->
  if current_search.type != ch_params.type or `current_search.interval_id != ch_params.interval_id`
    false
  else if current_search.type == 'Historical'
    strip_date(current_search.end_date) == strip_date(ch_params.end_date) and
      strip_date(current_search.start_date) == strip_date(ch_params.start_date)
  else
    `current_search.duration == ch_params.duration`

update_hisory = (ch_params) ->
  # console.log 'OLD state: ', window.location, 'New params:', ch_params
  new_params = '?' + $.param(ch_params)
  current_search = get_search_path()
  # console.log 'current_search:', current_search
  if _.isEqual(current_search, {})
    # console.log 'Replaced'
    window.history.replaceState {
      turbolinks: true
      url: new_params
    }, '', new_params
  else if !equal_params(current_search, ch_params)
    # console.log 'Pushed'
    window.history.pushState {
      turbolinks: true
      url: new_params
    }, '', new_params
  else
    # console.log ("Did nothing")

  # console.log 'New state: ', window.location
  return

update_form = (params) ->
  $('#dates-form *').filter(':input').each (k, v) ->
    val = params[v.name]
    if val
      # console.log val
      $(this).val val
    return
  return

$(document).on 'turbolinks:load', ->
  hide_and_show()

  $('#type-selector').change ->
  hide_and_show()

  $('#setDates').click (event) ->
    params = $('#dates-form').serializeArray().reduce(((o, e) ->
      if e.name != 'utf8'
        o[e.name] = e.value
      o
    ), {})
    # console.log "The params are ", params
    refresh_charts params
    update_hisory params

  $('#resetDates').click ->
    App.chart_view.change_location App.chart_view.initParams

App.chart_view.change_location = (chart_vars) ->
    refresh_charts chart_vars
    update_form chart_vars
    update_hisory chart_vars
    hide_and_show()
  

App.chart_view.init_graphs = (chart_vars) ->
  # console.log ("init_graphs  init_graphs init_graphs init_graphs init_graphs init_graphs init_graphs  CALLLED!!!")
  refresh_charts chart_vars
  hide_and_show()
  update_hisory chart_vars
