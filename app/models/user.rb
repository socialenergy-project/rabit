class User < ApplicationRecord

  acts_as_token_authenticatable

  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :set_name

  has_many :scenarios, dependent: :nullify
  has_and_belongs_to_many :consumers

  private
  def set_name
    self.name = self.email[/^[^@]+/].split('.').map(&:capitalize).join(' ')
  end
end
