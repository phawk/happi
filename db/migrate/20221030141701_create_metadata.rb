class CreateMetadata < ActiveRecord::Migration[7.0]
  def change
    create_table :metadata do |t|
      t.string :key
      t.text :value

      t.timestamps
    end

    add_index :metadata, :key
  end
end
