class CreateChangelogs < ActiveRecord::Migration[6.1]
  def change
    create_table :changelogs do |t|
      t.text :embed
      t.date :released

      t.timestamps
    end
  end
end
