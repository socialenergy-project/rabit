class ScenarioJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    #
    while true
      Rails.logger.debug "hello"
      sleep 10
    end
  end
end
