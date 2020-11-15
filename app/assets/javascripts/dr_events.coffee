App.dr_event_form ||= {}

$(document).on 'turbolinks:load', ->
  $('#new_dr_target').click ->
    $('#dr_target_fieds').append(App.dr_event_form.new_field)
    console.log($('input[name^="dr_event[dr_targets_attributes]"]'))       
    # $
    #         ;
    
    # console.log("I got", res.name)
    $('input[name="dr_event[ts_offset]"]')
      .attr("id","dr_event_dr_targets_attributes_#{App.dr_event_form.num_rows}_ts_offset")
      .attr("name","dr_event[dr_targets_attributes][#{App.dr_event_form.num_rows}][ts_offset]")
      .attr("value",App.dr_event_form.num_rows)

    $('input[name="dr_event[ts_offset]"]').siblings("label").first()
      .attr("for", "dr_event_dr_targets_attributes_#{App.dr_event_form.num_rows}_volume")    

    $('input[name="dr_event[volume]"]')
      .attr("id","dr_event_dr_targets_attributes_#{App.dr_event_form.num_rows}_volume")
      .attr("name","dr_event[dr_targets_attributes][#{App.dr_event_form.num_rows}][volume]")
      

    # $('input[name="dr_event[ts_offset]"]')
    #   .attr("name","dr_event[dr_targets_attributes][#{App.dr_event_form.num_rows}1][ts_offset]")
    App.dr_event_form.num_rows += 1 
    return false
