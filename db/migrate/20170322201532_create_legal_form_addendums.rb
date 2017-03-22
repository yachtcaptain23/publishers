class CreateLegalFormAddendums < ActiveRecord::Migration[5.0]
  def change
    create_table :legal_form_addendums, id: :uuid do |t|
      t.references :publisher_legal_form, type: :uuid, index: true, null: false
      t.string :encrypted_s3_key
      t.string :encrypted_s3_key_iv
      t.integer :addendum_number, null: false
      t.jsonb :fields, null: false
      t.timestamps
    end
  end
end
