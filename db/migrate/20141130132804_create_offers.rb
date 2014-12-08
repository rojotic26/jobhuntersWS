class CreateOffers < ActiveRecord::Migration
  def self.up
    create_table :offers do |t|
      t.string :title
      t.date :date
      t.string :city
      t.text :details
      t.timestamps
    end
    create_table :categories do |t|
      t.string :description
      t.string :category
      t.string :city
      t.timestamps
    end

  end

  def self.down
    drop_table :offers
    drop_table :categories
  end
end
