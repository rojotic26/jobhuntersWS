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
      t.timestamps
    end
    create_table :citcat do |t|
      t.string :city
      t.string :category
      t.timestamps
    end
  end

  def self.down
    drop_table :offers
    drop_table :categories
    drop_table :citcat
  end
end
