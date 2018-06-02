App.db_rooms ||= {}

window.subscribe_data_point = (consumers, interval_id, domElementId) ->
  # App.cable.subscriptions.remove(App.db_rooms[[consumers, interval_id]]) if App.db_rooms[[consumers, interval_id]]
  unless App.db_rooms[[consumers, interval_id]]
    App.db_rooms[[consumers, interval_id]] = App.cable.subscriptions.create({ channel: "DataPointChannel", consumers: consumers, interval_id: interval_id }, received: (data) ->
      chart = Chart.helpers.where(Chart.instances, (instance) ->
        instance.canvas.id == domElementId)[0]

      dataset = chart.data.datasets.find((d) -> d.label == data['consumer']['name'])
      last_time = dataset.data.slice(-1)[0].x
      new_time = new Date(data['timestamp'])
      if new_time > last_time
        dataset.data.push({x: new_time, y: data['consumption']})
        dataset.data.shift()
#        chart.update()
#        console.log "New data is", dataset.data
        datasets_without_aggregate = chart.data.datasets.filter((d) -> d.label != 'aggregate')
        console.log "datasets_without_aggregate= ", datasets_without_aggregate
        count_elems = datasets_without_aggregate.reduce( ((a, b) -> a + b.data.some( (d) -> d.x.getTime() == new_time.getTime() && d.y != null )) , 0)

        if count_elems == datasets_without_aggregate.length
          aggr_dataset = chart.data.datasets.find((d) -> d.label == 'aggregate')
          aggr_last_time = aggr_dataset.data.slice(-1)[0].x
          if new_time > last_time
            sum_elems = datasets_without_aggregate.reduce( ((a, b) -> a + b.data.find( (d) -> d.x.getTime() == new_time.getTime()).y) , 0)
            aggr_dataset.data.push({x: new_time, y: sum_elems})
            aggr_dataset.data.shift()

        chart.update()
      # console.log "We just received data:", data, "The chart is #{chart.canvas.id}", chart.data

    )




    console.log "connected to channel"
