class UsersController < ApplicationController
  before_action :set_user,  only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user,  only: [:show, :edit, :update, :destroy, :mypage, :feed, :watchlist]
  before_action :correct_user,  only: [:show, :edit, :update, :destroy]
  before_action :logged_out_user,  only: [:new, :create]

  
  # GET /users
  def index
    @users = User.page(params[:page]).per(50)
  end
  
  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        # メーラー（SendGrid）の不具合により、有効化ステップを再度一時停止
        # ユーザーを有効化するメールを送信
        @user.send_activation_email
        # メッセージを作成
        flash[:info] = '登録確認用のメールを送信しました。メールを確認し、アカウントを有効化してください'
        # @user.activate
        # log_in @user
        # flash[:info] = 'ご登録ありがとうございます！'
        format.html { redirect_to root_url }
      else
        flash[:danger] = 'アカウントの作成に失敗しました。'
        format.html { render :new }
      end
    end
  end
  
  # GET /users/1
  # GET /users/1.json
  def show
    redirect_to mypage_path
  end
  
  # GET /users/1/edit
  def edit
  end
  
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = '変更は正常に保存されました。'
        format.html { redirect_to mypage_path }
        format.json { render :mypage, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      flash[:info] = 'ユーザーは削除されました。'
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  # GET /mypage
  def mypage
    @user = current_user
    # ウォッチリスト登録されている企業のTD情報を取得
    lcs = []
    wls = @user.watchlists
    if wls.empty?
      @tds = []
    else
      wls.each{ |wl| lcs << wl[:local_code] }
      ticker_symbol = lcs.join("-")
      get_tds(ticker_symbol, 3)
    end
  end

  # GET /feed
  def feed
    @user = current_user
    # ウォッチリスト登録されている企業のTD情報を取得
    lcs = []
    wls = @user.watchlists
    if wls.empty?
      @tds = []
    else
      wls.each{ |wl| lcs << wl[:local_code] }
      ticker_symbol = lcs.join("-")
      get_tds(ticker_symbol, 30)
    end
  end

  # GET /feed/watchlist
  def watchlist
    @user = current_user
    lcs = []
    wls = @user.watchlists
    if wls.empty?
      @companies = []
    else
      wls.each{|wl| lcs << wl[:local_code] }
      @companies = Company.where(local_code: lcs).page(params[:page])
    end
  end

  private
    # 操作するユーザーを取り出す
    def set_user
      @user = User.find(params[:id])
    end

    # StrongParameters（マスアサインメントの脆弱性対策）
    def user_params
      params.require(:user).permit( :name, 
                                    :email, 
                                    :password, 
                                    :password_confirmation)
    end

    # 正しいユーザーかどうかの確認
    def correct_user
      unless current_user?(@user)
        flash[:danger] = 'アカウントが不正です。'
        redirect_to(root_url) 
      end
    end
end
