class AddFinishFieldtoSesion < ActiveRecord::Migration
   def self.up
      add_column :sesions, :concluida, :boolean
      add_column :sesions, :finished_at, :datetime
   end

  def self.down
      remove_columns(:sesions, :concluida)
      remove_columns(:sesions, :finished_at)
  end
end
