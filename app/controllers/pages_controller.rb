class PagesController < ApplicationController
  def home
    @cards = [
      { message: "#{Message.where(recipient: current_user).count} Messages",
        color: 'bg-primary', link: messages_path, image: 'fa-comments' },
      { message: "#{Consumer.count} Consumers", color: 'bg-warning',
        link: consumers_path, image: 'fa-line-chart' },
      { message: "#{Community.count} Communities", color: 'bg-success',
        link: communities_path, image: 'fa-handshake-o' },
      { message: "#{Clustering.count} Clusterings", color: 'bg-danger',
        link: clusterings_path, image: 'fa-sitemap' },
      { message: "#{ClScenario.count} Clustering Algorithm Scenarios",
        color: 'bg-info', link: cl_scenarios_path, image: 'fa-sitemap' },
      { message: "#{Recommendation.count} Recommendations", color: 'bg-primary',
        link: recommendations_path, image: 'fa-money' },
      { message: "#{Scenario.count} Energy Program Scenarios",
        color: 'bg-warning', link: scenarios_path, image: 'fa-plug' },
      { message: "#{UserClusteringScenario.count} User Clustering Scenarios",
        color: 'bg-success', link: user_clustering_scenarios_path, image: 'fa-users' }
    ]

    now = DateTime.now
    today_in_2015 = (begin
                       now.change(year: 2015)
                     rescue StandardError
                       (now - 1.day).change(year: 2015)
                     end)

    today_in_2018 = (begin
                       now.change(year: 2018)
                     rescue StandardError
                       (now - 1.day).change(year: 2018)
                     end)

    @charts = [{
      dom_id: :real_time_15_min_chart,
      title: 'Real time data for past 15 minutes',
      community: Community.find(1),
      path_method: method(:community_path),
      params: {
        'duration': 15.minutes.to_i,
        'interval_id': Interval.find_by(duration: 60).id,
        'type': 'Real-time'
      }
    }, {
      dom_id: :real_time_day_chart,
      title: 'Real time data for past day',
      community: Community.find(1),
      path_method: method(:community_path),
      params: {
        'duration': 24.hours,
        'interval_id': Interval.find_by(duration: 900).id,
        'type': 'Real-time'
      }
    }, {
      dom_id: :real_time_week_chart,
      title: 'Real time data for past week',
      community: Community.find(1),
      path_method: method(:community_path),
      params: {
        'duration': 1.week,
        'interval_id': Interval.find_by(duration: 3600).id,
        'type': 'Real-time'
      }
    }, {
      dom_id: :consumer_with_devices,
      title: 'Consumer with devices',
      community: Consumer.find(7),
      path_method: method(:consumer_path),
      params: {
        'duration': 15.minutes.to_i,
        'interval_id': Interval.find_by(duration: 60).id,
        'type': 'Real-time'
      }
    }, {
      dom_id: :flex_day_chart,
      title: 'Flexgrid data for 1 day',
      community: Community.find(12),
      path_method: method(:community_path),
      params: {
        'start_date': helpers.format_datetime(today_in_2018),
        'end_date': helpers.format_datetime(today_in_2018 + 1.day),
        'interval_id': Interval.find_by(duration: 900).id,
        'type': 'Historical'
      }
    }, {
      dom_id: :flex_week_chart,
      title: 'Flexgrid data for 1 week',
      community: Community.find(12),
      path_method: method(:community_path),
      params: {
        'start_date': helpers.format_datetime(today_in_2018),
        'end_date': helpers.format_datetime(today_in_2018 + 1.week),
        'interval_id': Interval.find_by(duration: 3600).id,
        'type': 'Historical'
      }
    }, {
      dom_id: :flex_year_chart,
      title: 'Flexgrid data for 1 month',
      community: Community.find(12),
      path_method: method(:community_path),
      params: {
        'start_date': helpers.format_datetime(today_in_2018),
        'end_date': helpers.format_datetime(today_in_2018 + 1.month),
        'interval_id': Interval.find_by(duration: 86_400).id,
        'type': 'Historical'
      }
    }, {
      dom_id: :historical_day_chart,
      title: 'Historical residential data for 1 day',
      community: Community.find(105),
      path_method: method(:community_path),
      params: {
        'start_date': helpers.format_datetime(today_in_2015),
        'end_date': helpers.format_datetime(today_in_2015 + 1.day),
        'interval_id': Interval.find_by(duration: 900).id,
        'type': 'Historical'
      }
    }, {
      dom_id: :historical_professional_chart,
      title: 'Historical professional data for 1 month',
      community: Community.find(103),
      path_method: method(:community_path),
      params: {
        'start_date': helpers.format_datetime(today_in_2015),
        'end_date': helpers.format_datetime(today_in_2015 + 1.month),
        'interval_id': Interval.find_by(duration: 86_400).id,
        'type': 'Historical'
      }
    }]
  end
end
