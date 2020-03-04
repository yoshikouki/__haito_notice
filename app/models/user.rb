class User < ApplicationRecord
  
  # コールバック
  before_save :downcase_email
  before_create :create_activation_digest

  # 仮想属性の宣言
  has_secure_password
  attr_accessor :remember_token, :activation_token
  
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
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す。
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 有効化用のメールを送信
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # アカウントを有効化
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
  
  # 渡されたトークンがダイジェストと一致したらtrue
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  private
    # emailを全て小文字化
    def downcase_email
      self.email.downcase!
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
