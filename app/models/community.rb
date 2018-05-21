class Community < ApplicationRecord
  belongs_to :clustering
  has_and_belongs_to_many :consumers

  validate :consumer_belongs_to_only_one_community_per_clustering

  def consumer_belongs_to_only_one_community_per_clustering
    (clustering.communities - [self]).each do |community|
      collisions = consumer_ids.select{|c| community.consumer_ids.include? c }
      if collisions.count > 0
        errors.add(:consumer_ids, "Consumers \"#{Consumer.find(collisions).map(&:name).join(", ")}\" are in " \
                   "community \"#{community.name}\", which is also in clustering \"#{clustering.name}\".")
      end
    end if clustering
  end

  def getData(chart_cookies)
    FetchData::FetchData.new(self.consumers, chart_cookies).sync
    if Interval.find(chart_cookies[:interval_id]).timestamps(chart_cookies[:start_date], chart_cookies[:end_date]).count < 700
      aggr = []
      res = DataPoint.joins(consumer: :communities)
                .where('communities.id': self,
                       timestamp: chart_cookies[:start_date] .. chart_cookies[:end_date],
                       interval_id: chart_cookies[:interval_id])
                .group('communities.id')
                .group('consumers.name')
                .select('consumers.name as con',
                        'array_agg(timestamp ORDER BY data_points.timestamp asc) as tims',
                        'array_agg(consumption ORDER BY data_points.timestamp ASC) as cons')
                .map do |d|
        aggr = d.tims.map{|t| [t,0]} if aggr.size == 0
        aggr = aggr.zip(d.cons).map{|(a,b),d| [a,((b.nil? or d.nil?) ? nil : b+d)]}
        [d.con, d.tims.zip(d.cons)]
      end.to_h
      res["aggregate"] = aggr
      {
          id => res
      }
    else
      {
          self.id => {
              "aggregate" => DataPoint.joins(consumer: :communities)
                                 .where('communities.id': self,
                                        timestamp: chart_cookies[:start_date] .. chart_cookies[:end_date],
                                        interval_id: chart_cookies[:interval_id])
                                 .group('communities.id')
                                 .group('timestamp')
                                 .order(timestamp: :asc)
                                 .select('communities.id as com, timestamp, case when sum(case when consumption is null then 1 else 0 end) > 0 then null else sum(consumption) end as cons')
                                 .map{|d| [d.timestamp, d.cons] }
          }
      }
    end

  end

  def initDates
    (consumers.first || Consumer.first)&.initDates
  end
end
