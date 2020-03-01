class User < ApplicationRecord
  
  # コールバック
  before_save :downcase_email
  before_create :create_activation_digest

  # 仮想属性の宣言
  has_secure_password

  
  # バリデーション
  validates :name,      presence: true, 
                        length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,     presence: true, 
                        length: { maximum: 255 },
                        format: { with: VALID_EMAIL_REGEX },
                        uniqueness: { case_sensitive: false }
  validates :password,  presence: true, 
                        length: { minimum: 6 },
                        allow_nil: true


  # 文字列をハッシュ化
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  private
    # emailを全て小文字化
    def downcase_email
      self.email.downcase!
    end

end
