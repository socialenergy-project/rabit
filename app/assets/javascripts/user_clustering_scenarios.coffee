# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
getColor = (label, opacity) ->
  switch label
    when 1 then "rgba(220,53,69,#{opacity})"
    when 2 then "rgba(0,123,255,#{opacity})"
    when 3 then "rgba(40,167,69,#{opacity})"
    when 4 then "rgba(255, 193, 7,#{opacity})"
    when 5 then "rgba(220,53,69,#{opacity})"
    else "rgba(0,123,255,#{opacity})"



window.createScatterChart = (domElementId, dataset, legendId = null, startFromZero = true, yaxistext= "Consumption (kWh)") ->
    return unless Object.keys(dataset).length > 0
    ctx = document.getElementById(domElementId)
    unless ctx
        return
    disp_legend = !legendId
    chart = Chart.helpers.where(Chart.instances, (instance) ->
        instance.canvas.id == domElementId)[0]
    # console.log "The chart is: ", chart
    if chart
        chart.destroy()

    scatterChart = new Chart(ctx, {
        type: 'scatter',
        data: {
            datasets: [{
                label: 'Scatter Dataset',
                data: [{
                    x: -10,
                    y: 0
                }, {
                    x: 0,
                    y: 10
                }, {
                    x: 10,
                    y: 5
                }],
                showLine: false,
                backgroundColor: getColor(1, 0.2),
                borderColor: getColor(1, 1),
                pointRadius: 5,
                pointBackgroundColor: getColor(1, 0.2 ),
                pointBorderColor: getColor(1, 1),
                pointHoverRadius: 5,
                pointHoverBackgroundColor: getColor(1, 0.2),
                pointHitRadius: 20,
                pointBorderWidth: 2,
            },{
                label: 'Scatter Dataset',
                data: [{
                    x: -5,
                    y: 1
                }, {
                    x: 2,
                    y: 5
                }, {
                    x: 1,
                    y: 4
                }],
                showLine: false,
                backgroundColor: getColor(2, 0.2),
                borderColor: getColor(2, 1),
                pointRadius: 5,
                pointBackgroundColor: getColor(2, 0.2 ),
                pointBorderColor: getColor(2, 1),
                pointHoverRadius: 5,
                pointHoverBackgroundColor: getColor(2, 0.2),
                pointHitRadius: 20,
                pointBorderWidth: 2,

            }]
        },
        options: {
            scales: {
                xAxes: [{
                    type: 'linear',
                    position: 'bottom',
                    scaleLabel: {
                        display: true,
                        labelString: "Time (UTC)",
                        fontSize: '15',
                    },
                }],
                yAxes: [{
                    type: 'linear',
                    scaleLabel: {
                        display: true,
                        labelString: "Time (UTC)",
                        fontSize: '15',
                    },
                }]

            }
        }
    })