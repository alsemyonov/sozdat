class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name, :title, :path
      t.boolean :editor, :browser, :server, :autotest
    end
  end

  def self.down
    drop_table :projects
  end
end
