module RecommendationsHelper
  def recommendable_string(x)
    "#{x.class}_#{x.id}" if x
  end
end
