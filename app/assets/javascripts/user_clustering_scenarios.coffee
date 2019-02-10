# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
getColor = (label, opacity) ->
  switch label
    when 0 then "rgba(0, 123, 255,#{opacity})"  #
    when 1 then "rgba(255, 193, 7,#{opacity})"
    when 2 then "rgba(40, 167, 69,#{opacity})"
    when 3 then "rgba(220, 53, 69,#{opacity})"
    when 4 then "rgba(23, 162, 184,#{opacity})"
    else "rgba(0,123,255,#{opacity})"

prepareData = (data) ->
    data.map (d, i) ->
        console.log d, i
        $.extend({
            showLine: false,
            backgroundColor: getColor(i, 0.2),
            borderColor: getColor(i, 1),
            pointRadius: 5,
            pointBackgroundColor: getColor(i, 0.2 ),
            pointBorderColor: getColor(i, 1),
            pointHoverRadius: 5,
            pointHoverBackgroundColor: getColor(i, 0.2),
            pointHitRadius: 20,
            pointBorderWidth: 2,
        }, d)


window.createScatterChart = (domElementId, dataset, xaxistext = "Time (UTC)", yaxistext = "Consumption (kWh)") ->
    return unless Object.keys(dataset).length > 0
    ctx = document.getElementById(domElementId)
    unless ctx
        return
    chart = Chart.helpers.where(Chart.instances, (instance) ->
        instance.canvas.id == domElementId)[0]
    # console.log "The chart is: ", chart
    if chart
        chart.destroy()

    scatterChart = new Chart(ctx, {
        type: 'scatter',
        data: {
            datasets: prepareData(dataset)
        },
        options: {
            scales: {
                xAxes: [{
                    type: 'linear',
                    position: 'bottom',
                    scaleLabel: {
                        display: true,
                        labelString: xaxistext,
                        fontSize: '15',
                    },
                }],
                yAxes: [{
                    type: 'linear',
                    scaleLabel: {
                        display: true,
                        labelString: yaxistext,
                        fontSize: '15',
                    },
                }]

            }
        }
    })