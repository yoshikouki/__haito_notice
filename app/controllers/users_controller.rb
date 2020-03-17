class UsersController < ApplicationController
  before_action :logged_in_user,  only: [ :edit, :update, :destroy]
  
  
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
        # ユーザーを有効化するメールを送信
        # @user.send_activation_email
        # メッセージを作成
        # flash[:info] = '登録確認用のメールを送信いたしました。メールを確認し、アカウントを有効化してください'
        
        format.html { redirect_to root_url }
        # format.html { redirect_to @user, notice: 'User was successfully created.' }
        # format.json { render :show, status: :created, location: @user }
      else
        flash[:danger] = 'アカウントの作成に失敗しました。入力内容をお確かめの上、再度実行してください'
        format.html { render :new }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /users/1
  # GET /users/1.json
  def show
  end
  
  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end
  
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
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
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # 操作するユーザーを取り出す
    def set_user
      @user = User.find(params[:id])
    end

    # StrongParameters（マスアサインメントの脆弱性対策）
    def user_params
      params.require(:user).permit(:name, 
                                    :email, 
                                    :password, 
                                    :password_confirmation)
    end
end
