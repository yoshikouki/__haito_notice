require 'rails_helper'

RSpec.describe Company, type: :model do
  it '企業のテストデータは作られている' do
    FactoryBot.create(:company)
    company = Company.first
    expect(company.local_code).to eq 1001
  end
end
