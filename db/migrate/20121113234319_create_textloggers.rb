class CreateTextloggers < ActiveRecord::Migration
  def change
    create_table :textloggers do |t|
      t.text :content

      t.timestamps
    end
  end
end
