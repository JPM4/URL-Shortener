class User < ActiveRecord::Base
  validates :email, :presence => true, :uniqueness => true

  has_many(
    :submitted_urls,
    class_name: "ShortenedUrl",
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many(:visited_urls, -> { distinct }, through: :visits, source: :url)

end
