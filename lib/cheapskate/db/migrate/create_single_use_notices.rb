class CreateSingleUseNotices < ActiveRecord::Migration
  def self.change
    create_table :single_use_notices do |t|
      t.string :message
      t.string :token
    end

    add_index :single_use_notices, :token
  end
end
