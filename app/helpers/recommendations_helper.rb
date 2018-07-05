module RecommendationsHelper
  def recommendable_id(x)
    "#{x.class}_#{x.id}" if x
  end

  def recommendable_display_name(x)
    "#{x.class}: #{x.name}" if x
  end
end
