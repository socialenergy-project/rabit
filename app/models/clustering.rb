class Clustering < ApplicationRecord
  has_many :communities, dependent: :destroy

  validates_associated :communities, message: ->(_class_obj, obj){ p "community OBJ is ", obj[:value]; obj[:value].map(&:errors).map(&:full_messages).join(',') }

  has_one :cl_scenario, dependent: :nullify

  def get_icon_index(prosumer)
    self.communities.index(self.communities.select do |tc|
      tc.consumers.include? prosumer
    end.first) || "N"
  end

  def getData(chart_cookies)
    logger.debug "I am here, my params are #{chart_cookies}"

    # if Interval.find(chart_cookies[:interval_id]).timestamps(chart_cookies[:start_date], chart_cookies[:end_date]).count < 700
      # Parallel.map(communities, in_threads: communities.count) do |c|
      communities.map do |c|
        c.getData(chart_cookies)
      end.reduce(&:merge)
=begin
    else
      DataPoint.joins(consumer: {communities: :clustering})
          .where('clusterings.id': self.id,
                 timestamp: chart_cookies[:start_date] .. chart_cookies[:end_date],
                 interval_id: chart_cookies[:interval_id])
          .group('communities.id').group('timestamp')
          .order(timestamp: :asc)
          .select('communities.id as com, timestamp, sum(consumption) as cons')
          .each_with_object({}) do |d,a|
        a[d.com] ||= {"aggregate" => []}
        a[d.com]["aggregate"] << [d.timestamp, d.cons]
      end
    end
=end





=begin

    res = {}
    DataPoint.joins(consumer: {communities: :clustering} )
        .where('clusterings.id': self,
               timestamp: chart_cookies[:start_date] .. chart_cookies[:end_date],
               interval_id: chart_cookies[:interval_id])
        .group('communities.id')
        .group('consumers.id')
        .select('communities.id as com, consumers.name as con',
                'array_agg(timestamp ORDER BY data_points.timestamp asc) as tims',
                'array_agg(consumption ORDER BY data_points.timestamp ASC) as cons')
        .each do |d|
      res[d.com] ||= {}
      res[d.com][d.con] = d.tims.zip(d.cons)
      res[d.com]["aggregate"] ||= d.tims.map{|t| [t,0]}
      res[d.com]["aggregate"]  = res[d.com]["aggregate"].zip(d.cons).map{|(a,b),d| [a,(b+d)]}
    end
    res
=end
  end
end
