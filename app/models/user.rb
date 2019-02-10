class User < ApplicationRecord

  acts_as_token_authenticatable

  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook gsrn]

  before_create :set_name

  has_many :scenarios, dependent: :nullify
  has_and_belongs_to_many :consumers

  has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id, dependent: :nullify
  has_many :received_messages, class_name: 'Message', foreign_key: :recipient_id, dependent: :nullify

  has_many :game_activities, dependent: :destroy
  has_many :lcms_badges, dependent: :destroy
  has_many :lcms_courses, dependent: :destroy
  has_many :lcms_scores, dependent: :destroy

  has_many :user_clustering_parameters, dependent: :destroy
  has_many :user_clustering_results, dependent: :destroy



  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  private
  def set_name
    self.name = self.email[/^[^@]+/].split('.').map(&:capitalize).join(' ')
  end
end
