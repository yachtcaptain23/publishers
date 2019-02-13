class RemoveIpTrackingFromPublishers < ActiveRecord::Migration[5.2]
  def change
    remove_column :publishers, :current_sign_in_ip, :inet
    remove_column :publishers, :last_sign_in_ip, :inet
  end
end