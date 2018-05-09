module ChartsHelper
  def chart_cookies
    initParams.map do |k,v|
      [k, session[k] = (params[k] || session[k] || v).send(paramTypes[k])]
    end.to_h
  end

  def initParams
    {
        start_date:  (DateTime.now - 7.days).to_datetime.change(year: 2015),
        end_date:    DateTime.now.change(year: 2015),
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
