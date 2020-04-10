require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
    user = FactoryBot.create(:user)
  end

  it ""
end
