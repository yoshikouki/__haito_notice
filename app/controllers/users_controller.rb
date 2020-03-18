class UsersController < ApplicationController
  before_action :set_user,  only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user,  only: [:show, :edit, :update, :destroy, :mypage]
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
        # ユーザーを有効化するメールを送信。一時取消
        #@user.send_activation_email
        # メッセージを作成
        #flash[:info] = '登録確認用のメールを送信いたしました。メールを確認し、アカウントを有効化してください'
        flash.now[:info] = 'ご登録ありがとうございます！'
        format.html { redirect_to root_url }
        # format.html { redirect_to @user, notice: 'User was successfully created.' }
        # format.json { render :show, status: :created, location: @user }
      else
        flash[:danger] = 'アカウントの作成に失敗しました。'
        format.html { render :new }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
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
        flash.now[:success] = '変更は正常に保存されました。'
        format.html { render :mypage }
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
      flash.now[:info] = 'ユーザーは削除されました。'
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # GET /mypage
  def mypage
    @user = @current_user
    correct_user
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
