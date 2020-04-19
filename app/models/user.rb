class User < ApplicationRecord
  
  has_many :watchlists, dependent: :destroy

  # コールバック
  before_save :downcase_email
  before_create :create_activation_digest

  # 仮想属性の宣言
  has_secure_password
  attr_accessor :remember_token, :activation_token, :reset_token
  
  # バリデーション
  validates :name,      presence: true, 
                        length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password,
            presence: true,
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

  # 渡されたトークンがダイジェストと一致したらtrue
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # (remember_me) 永続セッションのためにユーザーをデータベースに記憶
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 永続セッションを破棄。ログアウト時
  def forget
    update_attribute(:remember_digest, nil)
  end

  # 有効化用のメールを送信
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # アカウントを有効化
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # パスワードリセット用のメールを、準備工程後に送信。
  def send_reset_email
    create_reset_digest
    UserMailer.password_reset(self).deliver_now
  end

  # パスワードリセットトークンとダイジェストを作成および代入する
  def create_reset_digest
    self.reset_token  = User.new_token
    self.reset_digest = User.digest(reset_token)
    self.reset_sent_at = Time.zone.now
    self.save
  end

  # 企業をWatchlistに登録する
  def watch(company)
    if watching?(company)
      false
    else
      w = Watchlist.new(local_code: company.local_code)
      watchlists << w
    end
  end

  # 企業をWatchlistから解除する
  def unwatch(company)
    if watching?(company)
      watchlists.find_by(local_code: company.local_code).destroy
    else
      false
    end
  end
  
  # 企業がWatchlistに登録されていたらtrue
  def watching?(company)
    !watchlists.where(local_code: company.local_code).empty?
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
