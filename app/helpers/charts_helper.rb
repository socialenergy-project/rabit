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

  private
  def paramTypes
    {
        start_date:  :to_datetime,
        end_date:    :to_datetime,
        interval_id: :to_i,
    }
  end
end
