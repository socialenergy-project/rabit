subscriptions = {}
App.livecharts ||= {}

window.subscribe_smart_plug = (smart_plug, domElementId) ->

    if subscriptions[domElementId]?
      App.cable.subscriptions.remove(subscriptions[domElementId])

    console.log "Subscribing to #{[smart_plug, domElementId]}"
    subscriptions[domElementId] = App.cable.subscriptions.create({ channel: "SmartPlugChannel", smart_plug: smart_plug}, received: (data) ->
      console.log "Just received smart plug event", data
      chart = App.livecharts[domElementId].chart if App.livecharts[domElementId]
#      chart = Chart.helpers.where(Chart.instances, (instance) ->
#        instance.canvas.id == domElementId)[0]
      if !chart
        console.log "The subsciption is ", this
        this.unsubscribe()
        return
      dataset = chart.data.datasets[0]
      console.log "The dataset is #{dataset}"

      last_time = dataset?.data?.slice(-1)[0]?.x || 0
      last_value = dataset?.data?.slice(-1)[0]?.y
      console.log "last_time=#{last_time}"
      new_time = new Date(data['timestamp'])
      console.log "new_time=#{new_time}"
      if new_time > last_time
        dataset.data.push({x: new_time, y: last_value}) if last_value
        dataset.data.push({x: new_time, y: data['consumption']})
        console.log "The dataset is #{dataset}"
        chart.update()
        console.log "Updated chart #{chart}"
    )


