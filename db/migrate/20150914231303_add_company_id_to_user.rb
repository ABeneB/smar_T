class AddCompanyIdToUser< ActiveRecord::Migration
  def change
    add_column :users, :company_id, :integer
    remove_column :companies, :user_id
  end
end