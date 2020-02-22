class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :company_name
      t.integer :local_code
      t.string :market_division
      t.integer :tsi_code
      t.string :topix_sector_indices
      t.integer :t17_code
      t.string :topix_17
      t.integer :sc_code
      t.string :size_classification
      t.integer :pub_date

      t.timestamps
    end
  end
end
