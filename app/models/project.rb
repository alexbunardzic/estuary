class Project < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  #mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :name, presence: true
  validates :description, presence: true
end
