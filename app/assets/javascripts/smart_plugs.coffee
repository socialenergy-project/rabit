# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
    console.log "We have #{$('canvas[id^="smart_plug_"').length} smart plugs"
    $('canvas[id^="smart_plug_"').each (i, sp) ->
        console.log "This one is #{sp}"
        chart = Chart.helpers.where(Chart.instances, (instance) ->
            instance.canvas.id == sp.id)[0]
      # console.log "The chart is: ", chart
        if chart
            chart.destroy()

        chart = new Chart(sp, {
            type: 'scatter',
            responsive: true,
            maintainAspectRatio: false,
            data: {
                datasets: [{
                    label: "power",
                    lineTension: 0,
                    backgroundColor: "rgba(2,117,216,0.2)",
                    borderColor: "rgba(2,117,216,1)",
                    pointRadius: 5,
                    pointBackgroundColor: "rgba(2,117,216,1)",
                    pointBorderColor: "rgba(255,255,255,0.8)",
                    pointHoverRadius: 5,
                    pointHoverBackgroundColor: "rgba(2,117,216,1)",
                    pointHitRadius: 20,
                    pointBorderWidth: 2,
                    data: []
                }],
            },
            options: {
                scales: {
                    xAxes: [{
                        display: true,
                        time: {
                            unit: 'date'
                        },
                        gridLines: {
                            display: true,
                        },
                        scaleLabel: {
                            display: true,
                            labelString: "Time (UTC)",
                            fontSize: '15',
                        },
                        afterTickToLabelConversion: (scaleInstance) ->
                            # set the first and last tick to null so it does not display
                            # note, ticks[0] is the last tick and ticks[length - 1] is the first
                            # need to do the same thing for this similiar array which is used internally
                            # console.log scaleInstance
                            if scaleInstance.ticksAsNumbers[0] == scaleInstance.min
                                scaleInstance.ticks[0] = null
                                scaleInstance.ticksAsNumbers[0] = null

                            if scaleInstance.ticksAsNumbers[scaleInstance.ticks.length - 1] == scaleInstance.max
                                scaleInstance.ticks[scaleInstance.ticks.length - 1] = null
                                scaleInstance.ticksAsNumbers[scaleInstance.ticksAsNumbers.length - 1] = null

                        ticks: Object.assign {
            #                min: Date.parse("2017-10-10T12:00:00.000Z"),
            #                 max: Date.parse("2017-10-18T11:00:00.000Z"),
                            maxTicksLimit: 5,
                            maxRotation: 0,
                            minRotation: 0,
                            userCallback: (label, index, labels) ->
                                new Date(label).toISOString().split("T")
                        }
                    }],
                    yAxes: [{
                        gridLines: {
                            color: "rgba(0, 0, 0, .125)",
                        },
                        scaleLabel: {
                            display: true,
                            labelString: "Watt",
                            fontSize: '15',
                        }
                    }],
                },
                legend: {
                    display: false
                }
                tooltips: {
                    enabled: true,
                    mode: 'nearest',
                    position: 'nearest',
                    callbacks: {
                        label: (tooltipItems, data) ->
                            [data.datasets[tooltipItems.datasetIndex].label, new Date(tooltipItems.xLabel).toISOString().split("T"), tooltipItems.yLabel].flat()
                    }
                },
            }
        })
        App.livecharts[sp.id] = {chart: chart, duration: 300 * 1000}
