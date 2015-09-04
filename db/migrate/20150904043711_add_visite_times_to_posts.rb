class AddVisiteTimesToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :visite_times, :integer, default: 0
  end
end
