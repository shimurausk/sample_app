class Micropost < ActiveRecord::Base

  has_attached_file :avatar, 
  :styles => { :medium => "300x300>", :thumb => "100x100>" },
   :default_url => "/images/:style/missing.png"
   validates_attachment_content_type :avatar, :content_type => %w(image/jpeg image/jpg image/png)
   
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  # 与えられたユーザーがフォローしているユーザー達のマイクロポストを返す。
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end