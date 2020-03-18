class Watchlist < ApplicationRecord

  belongs_to :user, class_name: "User"

  validates :user_id,    presence: true
  validates :local_code, presence: true

end
