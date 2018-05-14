# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $("input.datetimepicker").datetimepicker({
    format: 'yyyy-mm-dd hh:ii z',
    minuteStep: 15,
    autoclose: true,
  });
  $("#run_algorithm").click (e) ->
    $(this).html("<i class=\"fa fa-spinner\" aria-hidden=\"true\"></i> Running algorithm, please wait...").prop('disabled', true);
    $(this).parents('form').submit()

getColor = (label, opacity) ->
  switch label
    when "RTP (no DR)" then "rgba(220,53,69,#{opacity})"
    when "Real-time pricing" then "rgba(0,123,255,#{opacity})"
    when "Personal Real-time pricing" then "rgba(40,167,69,#{opacity})"
    when "Community Real-time pricing" then "rgba(255, 193, 7,#{opacity})"
    when "aggregate" then "rgba(220,53,69,#{opacity})"
    else "rgba(0,123,255,#{opacity})"

prepareData = (dataset) ->
  keys = Object.keys(dataset)
  showPoints = dataset[keys[0]].length < 60
  keys.map (k) ->
    {
      label: k,
      data: dataset[k].map (d) ->
        # console.log("x=",d[0],"y=",d[1])
        {x: new Date(d[0]), y: d[1]}
      fill: false
      lineTension: 0.3,
      lineColor: getColor(k, 1),
      backgroundColor: getColor(k, 0.2),
      borderColor: getColor(k, 1),
      pointRadius: if showPoints then 5 else 0,
      pointBackgroundColor: getColor(k, 0.2 ),
      pointBorderColor: getColor(k, 1),
      pointHoverRadius: 5,
      pointHoverBackgroundColor: getColor(k, 0.2),
      pointHitRadius: 20,
      pointBorderWidth: 2,
    }

window.clearAllCharts = () ->
  Chart.helpers.each Chart.instances, (instance) ->
    console.log instance
    instance.chart.destroy()

window.createChart = (domElementId, dataset, legendId = null, startFromZero = true) ->
  return unless Object.keys(dataset).length > 0
  ctx = document.getElementById(domElementId)
  disp_legend = !legendId;
  myLineChart = new Chart(ctx, {
    type: 'scatter',
    data: {
      datasets: prepareData dataset
      ###datasets: [{
        label: "Sessions",
        lineTension: 0.3,
        backgroundColor: "rgba(2,117,216,0.2)",
        borderColor: "rgba(2,117,216,1)",
        pointRadius: 5,
        pointBackgroundColor: "rgba(2,117,216,1)",
        pointBorderColor: "rgba(255,255,255,0.8)",
        pointHoverRadius: 5,
        pointHoverBackgroundColor: "rgba(2,117,216,1)",
        pointHitRadius: 20,
        pointBorderWidth: 2,
        data: prepareData dataset
      }],###
    },
    options: {
      scales: {
        xAxes: [{
          display: false,
          time: {
            unit: 'date'
          },
          gridLines: {
            display: false
          },
          ticks: {
      #      min: Date.parse("2017-10-10T12:00:00.000Z"),
      #      max: Date.parse("2017-10-18T11:00:00.000Z"),
      #       maxTicksLimit: 15,
             userCallback: (label, index, labels) ->
               new Date(label).toISOString()
          }
        }],
        yAxes: [{
          ticks: if startFromZero then   {
            min: 0,
            # max: 40000,
            maxTicksLimit: 5
          } else {

            maxTicksLimit: 5
          },
          gridLines: {
            color: "rgba(0, 0, 0, .125)",
          }
        }],
      },
      legend: {
        display: disp_legend
      }
      tooltips: {
        enabled: true,
        mode: 'single',
        callbacks: {
          label: (tooltipItems, data) ->
            [data.datasets[tooltipItems.datasetIndex].label, new Date(tooltipItems.xLabel), tooltipItems.yLabel]
        }
      },
    }
  })
