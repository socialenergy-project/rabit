module ChartsHelper
  def chart_cookies
    initParams.map do |k,v|
      [k, session[k] = (params[k] || session[k] || v).send(paramTypes[k])]
    end.to_h
  end

  def initParams
    {
        start_date:  (DateTime.now - 7.days).to_datetime,
        end_date:    DateTime.now,
        interval_id: 2,
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
