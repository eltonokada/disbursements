class RenameOrderNetAmount < ActiveRecord::Migration[7.1]
  def change
    rename_column :orders, :net_amount, :disbursed_amount
  end
end
