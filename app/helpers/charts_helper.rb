module ChartsHelper
  def chart_cookies(entity = Clustering.first)
    initParams(entity).map do |k,v|
      [k, session[k] = (params[k] || session[k] || v).send(paramTypes[k])]
    end.to_h
  end

  def initParams(entity = Clustering.first)
    params = entity.initDates
    {
        start_date:  params[:start],
        end_date:    params[:end],
        interval_id: Interval.find_by(duration: 3600).id,
    }
  end

  def quicklinks(entity)
    now = DateTime.now

    realtime_links = [{
                          name: "Past 15 minutes",
                          params: {
                              'start_date': now - 15.minutes,
                              'end_date': now + 30.minutes,
                              'interval_id': Interval.find_by(duration: 60).id,
                          }
                      },{
                          name: "Past hour",
                          params: {
                              'start_date': now - 60.minutes,
                              'end_date': now + 30.minutes,
                              'interval_id': Interval.find_by(duration: 300).id,
                          }
                      },{
                          name: "Past two hours",
                          params: {
                              'start_date': now - 2.hours,
                              'end_date': now + 30.minutes,
                              'interval_id': Interval.find_by(duration: 300).id,
                          }
                      },{
                          name: "Past day",
                          params: {
                              'start_date': now - 1.day,
                              'end_date': now + 30.minutes,
                              'interval_id': Interval.find_by(duration: 900).id,
                          }
                      },{
                          name: "Past week",
                          params: {
                              'start_date': now - 1.week,
                              'end_date': now + 30.minutes,
                              'interval_id': Interval.find_by(duration: 3600).id,
                          }
                      },{
                          name: "Past month",
                          params: {
                              'start_date': now - 1.month,
                              'end_date': now + 30.minutes,
                              'interval_id': Interval.find_by(duration: 86400).id,
                          }
                      }]

    start_2015 = now.change(year: 2015)

    historical_links = [{
                          name: "1 day",
                          params: {
                              'start_date': start_2015,
                              'end_date': start_2015 + 1.day,
                              'interval_id': Interval.find_by(duration: 900).id,
                          }
                      },{
                          name: "1 week",
                          params: {
                              'start_date': start_2015,
                              'end_date': start_2015 + 1.week,
                              'interval_id': Interval.find_by(duration: 3600).id,
                          }
                      },{
                          name: "1 month",
                          params: {
                              'start_date': start_2015,
                              'end_date': start_2015 + 1.month,
                              'interval_id': Interval.find_by(duration: 86400).id,
                          }
                      },{
                            name: "1 year",
                            params: {
                                'start_date': '2015-01-01T00:00:00Z'.to_datetime,
                                'end_date': '2015-12-31T00:00:00Z'.to_datetime,
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
