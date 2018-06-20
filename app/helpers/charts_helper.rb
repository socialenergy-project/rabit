module ChartsHelper
  def chart_cookies(entity = Clustering.first)
    initParams(entity).map do |k,v|
      [k, session[k] = (params[k] || session[k] || v)&.send(paramTypes[k])]
    end.to_h
  end

  def initParams(entity = Clustering.first)
    params = entity.initDates
  end

  def quicklinks(entity)
    realtime_links = [{
                          name: "Past 15 minutes",
                          params: {
                              'duration': 15.minutes.to_i,
                              'type': "Real-time",
                              'interval_id': Interval.find_by(duration: 60).id,
                          }
                      },{
                          name: "Past hour",
                          params: {
                              'duration': 60.minutes.to_i,
                              'type': "Real-time",
                              'interval_id': Interval.find_by(duration: 300).id,
                          }
                      },{
                          name: "Past two hours",
                          params: {
                              'duration': 2.hours.to_i,
                              'type': "Real-time",
                              'interval_id': Interval.find_by(duration: 300).id,
                          }
                      },{
                          name: "Past day",
                          params: {
                              'duration': 1.day.to_i,
                              'type': "Real-time",
                              'interval_id': Interval.find_by(duration: 900).id,
                          }
                      },{
                          name: "Past week",
                          params: {
                              'duration': 1.week.to_i,
                              'type': "Real-time",
                              'interval_id': Interval.find_by(duration: 3600).id,
                          }
                      },{
                          name: "Past month",
                          params: {
                              'duration': 1.month.to_i,
                              'type': "Real-time",
                              'interval_id': Interval.find_by(duration: 86400).id,
                          }
                      }]

    start_2015 = DateTime.now.change(year: 2015)

    historical_links = [{
                          name: "1 day",
                          params: {
                              'start_date': start_2015,
                              'end_date': start_2015 + 1.day,
                              'type': "Historical",
                              'interval_id': Interval.find_by(duration: 900).id,
                          }
                      },{
                          name: "1 week",
                          params: {
                              'start_date': start_2015,
                              'end_date': start_2015 + 1.week,
                              'type': "Historical",
                              'interval_id': Interval.find_by(duration: 3600).id,
                          }
                      },{
                          name: "1 month",
                          params: {
                              'start_date': start_2015,
                              'end_date': start_2015 + 1.month,
                              'type': "Historical",
                              'interval_id': Interval.find_by(duration: 86400).id,
                          }
                      },{
                            name: "1 year",
                            params: {
                                'start_date': '2015-01-01T00:00:00Z'.to_datetime,
                                'end_date': '2015-12-31T00:00:00Z'.to_datetime,
                                'type': "Historical",
                                'interval_id': Interval.find_by(duration: 86400).id,
                            }
                        }]

    if entity.realtime
      realtime_links.map do |link|
        {
            name: link[:name],
            link: path_for_entity(entity, link[:params])
        }
      end
    else
      historical_links.map do |link|
        {
            name: link[:name],
            link: path_for_entity(entity, link[:params])
        }
      end
    end
  end

  private
  def paramTypes
    {
        start_date:  :to_datetime,
        end_date:    :to_datetime,
        interval_id: :to_i,
        duration:    :to_i,
        type:        :to_s,
    }
  end

  def path_for_entity(entity, params)
    case entity
    when Clustering
      clustering_path(entity, params)
    when Community
      community_path(entity, params)
    when Consumer
      consumer_path(entity, params)
    end
  end
end
