class AddPublishToPost < ActiveRecord::Migration
  def change
    add_column :posts, :publish, :boolean
  end
end
