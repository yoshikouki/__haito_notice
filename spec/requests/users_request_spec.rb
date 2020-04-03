require 'rails_helper'

RSpec.describe "Users", type: :request do
  it 'マイページのアクセスにはログインが必要' do
    get mypage_path
    expect(response).to redirect_to login_path
  end
end
