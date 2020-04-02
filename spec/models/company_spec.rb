require 'rails_helper'

RSpec.describe Company, type: :model do
  it '企業のテストデータは作られている' do
    FactoryBot.create(:company)
    company = Company.first
    expect(company.local_code).to eq 1001
  end

  it '企業のテストデータは複数保持している' do
    FactoryBot.create(:company, :more_companies)
    expect(Company.count).to eq 51
  end
end
