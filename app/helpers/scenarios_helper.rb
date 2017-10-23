module ScenariosHelper
  def format_datetime(datetime)
    datetime.localtime.strftime("%F %H:%M %Z")
  end
end
