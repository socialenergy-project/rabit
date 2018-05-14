class PagesController < ApplicationController
  def home
    @cards = [{message: "#{Message.where(recipient: current_user).count} Messages", color: "bg-primary", link: messages_path, image: "fa-comments"},
              {message: "#{Consumer.count} Consumers", color: "bg-warning", link: consumers_path, image: "fa-line-chart"},
              {message: "#{Community.count} Communities", color: "bg-success", link: communities_path, image: "fa-handshake-o"},
              {message: "#{Clustering.count} Clusterings", color: "bg-danger", link: clusterings_path, image: "fa-sitemap"},
              {message: "#{ClScenario.count} Clustering Algorithm Scenarios", color: "bg-info", link: cl_scenarios_path, image: "fa-sitemap"},
              {message: "#{Recommendation.count} Recommendations", color: "bg-primary", link: recommendations_path, image: "fa-money"},
              {message: "#{Scenario.count} Energy Program Scenarios", color: "bg-warning", link: scenarios_path, image: "fa-plug"}]
  end
end
