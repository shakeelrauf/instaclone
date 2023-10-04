class CreateAttachments < ActiveRecord::Migration[7.0]
  def change
    create_table :attachments do |t|
      t.references :attacheble, polymorphic: true, null: false

      t.timestamps
    end
  end
end
