module ChartsHelper
  def chart_cookies(entity = Clustering.first)
    initParams(entity).map do |k,v|
      [k, session[k] = (params[k] || session[k] || v)&.send(paramTypes[k])]
    end.to_h
  end

  def initParams(entity = Clustering.first)
    entity.initDates
  end

  def quicklinks(entity)
    realtime_links = [{
                          name: "Past 15 minutes, 1 minute interval",
                          params: {
                              'duration': 15.minutes.to_i,
                              'type': "Real-time",
                              'interval_id': Interval.find_by(duration: 60).id,
                          }
                      },{
                          name: "Past hour, 5 minute interval",
                          params: {
                              'duration': 60.minutes.to_i,
                              'type': "Real-time",
                              'interval_id': Interval.find_by(duration: 300).id,
                          }
                      },{
                          name: "Past two hours, 5 minute interval",
                          params: {
                              'duration': 2.hours.to_i,
                              'type': "Real-time",
                              'interval_id': Interval.find_by(duration: 300).id,
                          }
                      },{
                          name: "Past day, 15 minute interval",
                          params: {
                              'duration': 1.day.to_i,
                              'type': "Real-time",
                              'interval_id': Interval.find_by(duration: 900).id,
                          }
                      },{
                          name: "Past week, 1 hour interval",
                          params: {
                              'duration': 1.week.to_i,
                              'type': "Real-time",
                              'interval_id': Interval.find_by(duration: 3600).id,
                          }
                      },{
                          name: "Past month, 1 day interval",
                          params: {
                              'duration': 1.month.to_i,
                              'type': "Real-time",
                              'interval_id': Interval.find_by(duration: 86400).id,
                          }
                      }]

    start_2015 = DateTime.now
    start_2015 = (start_2015.change(year: entity.reference_year) rescue (start_2015-1.day).change(year: entity.reference_year)) if entity.reference_year

    historical_links = [{
                          name: "1 day, 15 minute interval",
                          params: {
                              'start_date': start_2015,
                              'end_date': start_2015 + 1.day,
                              'type': "Historical",
                              'interval_id': Interval.find_by(duration: 900).id,
                          }
                      },{
                          name: "1 week, 1 hour interval",
                          params: {
                              'start_date': start_2015,
                              'end_date': start_2015 + 1.week,
                              'type': "Historical",
                              'interval_id': Interval.find_by(duration: 3600).id,
                          }
                      },{
                          name: "1 month, 1 day interval",
                          params: {
                              'start_date': start_2015,
                              'end_date': start_2015 + 1.month,
                              'type': "Historical",
                              'interval_id': Interval.find_by(duration: 86400).id,
                          }
                      },{
                            name: "1 year, 1 day interval",
                            params: {
                                'start_date': "#{entity.reference_year}-01-01T00:00:00Z".to_datetime,
                                'end_date': "#{entity.reference_year}-12-31T00:00:00Z".to_datetime,
                                'type': "Historical",
                                'interval_id': Interval.find_by(duration: 86400).id,
                            }
                        }]

    if entity.reference_year.nil?
      realtime_links
    else
      historical_links
    end.map do |link|
      {
        name: link[:name],
        link: path_for_entity(entity, format_datetime(link[:params]))
      }
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
    when EccType
      ecc_type_path(entity, params)
    end
  end
end
