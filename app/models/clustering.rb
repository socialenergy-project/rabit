class Clustering < ApplicationRecord
  has_many :clusters, :dependent => :destroy
end
