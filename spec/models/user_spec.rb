require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { described_class.new(params) }
  let(:params) do
    { name: 'テスト太郎',
      email: "example@email.com",
      password: "password",
      password_confirmation: "password" }
  end

  it "Userは有効" do
    expect(user).to be_valid
  end

  it "不正なUserインスタンスは保存できない" do
    params.clear
    expect(user.save).to be_falsey
  end

  describe "Userのパラメータが不正な場合" do
    it "User.nameは必須" do
      params[:name] = ""
      expect(user).to be_invalid
    end

    it "User.nameは50文字以内"
    it "User.emailは必須" do
      params[:email] = ""
      expect(user).to be_invalid
    end

    it "User.emailは255文字以内"
    it "User.passwordは必須" do
      params[:password] = ""
      expect(user).to be_invalid
    end

    it "User.password_confirmationは必須" do
      params[:password_confirmation] = ""
      expect(user).to be_invalid
    end

    it "User.password_confirmationとpasswordは一致" do
      params[:password_confirmation] = "wrongPassword"
      expect(user).to be_invalid
    end
  end
end
