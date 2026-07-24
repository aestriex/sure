class CreateIntegrations < ActiveRecord::Migration[7.2]
  def change
    create_table :integrations, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.string :source_type, null: false
      t.boolean :enabled, null: false, default: false
      t.jsonb :settings, null: false, default: {}

      t.timestamps
    end

    add_index :integrations, [:account_id, :source_type], unique: true
  end
end
