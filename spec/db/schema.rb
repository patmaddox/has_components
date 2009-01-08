ActiveRecord::Schema.define(:version => 0) do
  create_table :frames, :force => true do |t|
    t.column :name, :string
  end

  create_table :lenses, :force => true do |t|
    t.column :name, :string
  end

  create_table :cases, :force => true do |t|
    t.column :name, :string
  end

  create_table :component_relations, :force => true do |t|
    t.column :first_id, :integer
    t.column :second_id, :integer
    t.column :type, :string
  end
end
