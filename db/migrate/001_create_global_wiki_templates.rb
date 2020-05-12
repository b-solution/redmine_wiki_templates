class CreateGlobalWikiTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :global_wiki_templates do |t|
      t.string :title
      t.string :wiki_title
      t.integer :author_id
      t.string :note
      t.text :description
      t.boolean :enabled
      t.integer :position
      t.timestamp :created_on
      t.timestamp :updated_on
    end
    add_index :global_wiki_templates, :author_id
    add_column :global_wiki_templates, :checklist_json, :text
    change_column :global_wiki_templates, :enabled, :boolean, default: false, null: false
    add_column :global_wiki_templates, :is_default, :boolean, default: false, null: false
    add_column :global_wiki_templates, :related_link, :text
    add_column :global_wiki_templates, :link_title, :text
    add_column :global_wiki_templates, :builtin_fields_json, :text
  end

  def self.down
    remove_index :global_wiki_templates, :author_id
    remove_index :global_wiki_templates, :tracker_id
    drop_table :global_wiki_templates
  end
end
