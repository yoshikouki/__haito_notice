require 'rails_helper'

RSpec.describe Company, type: :model do
  it 'Comnay Modelのテストデータ' do
    company = FactoryBot.create(:company)
    expect(company).to be_valid
  end

  it 'Comnay Modelのテストデータ複数' do
    FactoryBot.create(:companies, :more_companies)
    expect(Company.count).to eq 51
  end
end
