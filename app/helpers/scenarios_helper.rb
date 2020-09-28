module ScenariosHelper
  def format_datetime(obj)
    if obj&.respond_to? :localtime
      obj.localtime&.strftime("%FT%H:%M:%S%z")
    elsif obj.class == Hash
      obj.map do |k,v|
        [k, format_datetime(v)]
      end.to_h
    else
      obj
    end
  end
end
