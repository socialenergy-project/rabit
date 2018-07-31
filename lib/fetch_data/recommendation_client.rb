module FetchData
  class RecommendationClient

    def initialize
      @gsrn_post_recommendation_url = "https://socialenergy.intelen.com/index.php/webservices/postRecommendations"
    end


    def post_message(message)
      result = RestClient.post @gsrn_post_recommendation_url, {
          email: message.recipient.email,
          message: message.content,
          dateFrom: DateTime.now.utc.to_i,
          dateTo: (DateTime.now + 3.years).utc.to_i,
      }
      p "The result is #{result}"

      if (JSON.parse(result)["status"] == "Recommendation added successfully." rescue false)
        message.update_attributes gsrn_status: :posted
      else
        message.update_attributes gsrn_status: :failed
      end
      result
    end

    def post_recommendation(recommendation)
      recommendation.messages.map do |message|
        post_message(message)
      end
    end


  end
end
