require 'rails_helper'

RSpec.describe Company, type: :model do
  FactoryBot.create(:company)
  it '企業のテストデータは作られている' do
    company = Company.first
    expect(company.local_code).to eq 1001
  end

  it '企業のテストデータは複数保持している' do
    expect(Company.count).to be >= 51
  end
end
