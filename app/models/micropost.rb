class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  before_validation :set_in_reply_to

  validates :content, presence: true, length: {maximum: 140}
  validates :user_id, presence: true  
  validates :in_reply_to, presence: true

  default_scope order: 'microposts.created_at DESC'
  scope :no_replies, where("user_id = in_reply_to")

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                          WHERE follower_id = :user_id"
    where("(user_id IN (#{followed_user_ids}) AND in_reply_to IN (user_id, :user_id))
             OR user_id=:user_id", user_id: user.id)
  end

  protected
    
    def set_in_reply_to
      @reply_username = self.content[/^@(\S+)/,1]

      if @reply_username
        @reply_user = User.where("username = ?",@reply_username)[0]

        if @reply_user
          self.in_reply_to = @reply_user.id
        else
          self.in_reply_to = self.user_id
        end
      else
        self.in_reply_to = self.user_id
      end 
    end 
end
