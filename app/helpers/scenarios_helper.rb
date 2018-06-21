module ScenariosHelper
  def format_datetime(obj)
    if obj.class == DateTime
      obj&.localtime&.strftime("%F %H:%M %Z")
    elsif obj.class == Hash
      obj.map do |k,v|
        [k, format_datetime(v)]
      end.to_h
    else
      obj
    end
  end
end
