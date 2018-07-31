module FetchData
  class RecommendationClient

    def initialize
      @gsrn_post_recommendation_url = "https://socialenergy.intelen.com/index.php/webservices/postRecommendations"
    end


    def post_message(message)
      result = RestClient.post @gsrn_post_recommendation_url, {
          email: message.recipient.email,
          message: message.content,
          dateFrom: nil,
          dateTo: nil,
      }
      p "The result is #{result}"

      result
    end

    def post_recommendation(recommendation)
      recommendation.messages.map do |message|
        post_message(message)
      end
    end


  end
end
