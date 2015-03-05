class ShortenedUrl < ActiveRecord::Base
  validates :short_url, uniqueness: true, presence: true
  validates :long_url, presence: true
  validates :user_id, presence: true

  has_many(
    :visits,
    class_name: "Visit",
    foreign_key: :shortened_url_id,
    primary_key: :id
  )

  belongs_to(
    :submitter,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many(
    :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :visitor
  )

  def self.create_for_user_and_long_url!(user, long_url)
    short_url = random_code
    while exists?(:short_url => short_url)
      short_url = random_code
    end

    ShortenedUrl.create!(
      short_url: short_url,
      user_id: user.id,
      long_url: long_url
    )
  end

  def self.random_code
    SecureRandom.urlsafe_base64(16)
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    visitors.where("visits.created_at > ?", 10.minutes.ago).count
  end
end
