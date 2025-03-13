class CreateInitialSchema < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :locality
      t.string :postal_code
      t.string :administrative_area
      t.string :country
      t.timestamps
    end

    create_table :people do |t|
      t.string :username
      t.string :lastname
      t.string :firstname
      t.string :email
      t.string :phone_number
      t.string :status
      t.string :type
      t.string :iban
      t.timestamps
    end

    create_table :rooms do |t|
      t.string :name
      t.timestamps
    end

    create_table :sections do |t|
      t.string :name
      t.text :description
      t.timestamps
    end

    create_table :classes do |t|
      t.string :uid
      t.string :name
      t.timestamps
    end

    create_table :courses do |t|
      t.string :name
      t.text :description
      t.string :status
      t.timestamps
    end

    create_table :specializations do |t|
      t.string :name
      t.text :description
      t.timestamps
    end

    create_table :examinations do |t|
      t.string :title
      t.date :expected_date
      t.timestamps
    end

    create_table :grades do |t|
      t.integer :value
      t.date :effective_date
      t.timestamps
    end

    create_table :schedules do |t|
      t.time :start_time
      t.time :end_time
      t.integer :week_day
      t.timestamps
    end

    create_table :periods do |t|
      t.date :start_date
      t.date :end_date
      t.timestamps
    end

    create_table :promotion_asserments do |t|
      t.date :effective_date
      t.string :condition
      t.timestamps
    end
  end
end
