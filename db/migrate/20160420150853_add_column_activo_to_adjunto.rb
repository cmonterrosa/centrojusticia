class AddColumnActivoToAdjunto < ActiveRecord::Migration
  def self.up
      add_column :adjuntos, :activo, :boolean
      add_index :adjuntos, [:activo], :name => "adjuntos_activo"

      Adjunto.reset_column_information
      Adjunto.find(:all).each do |a|
         puts("=> Searching: #{File.join(a.file_path, a.file_name)}" )
          if  File.exists?(File.join(a.file_path, a.file_name))
            a.update_attributes!(:activo => true)
            puts("=> Actualice registro")
          end
      end
  end

  def self.down
      remove_column :adjuntos, :activo
      remove_index :adjuntos, :adjuntos_activo
  end
end
