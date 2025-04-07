class AddRoleToAdmins < ActiveRecord::Migration[8.0]
  def change
    # Add `role` column with a default value of `power_user`
    add_column :admins, :role, :string, null: false, default: "power_user"
  end
end
