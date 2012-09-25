class CreateHorarios < ActiveRecord::Migration
  def self.up
    create_table :horarios do |t|
      t.integer :hora
      t.integer :minutos
      t.string :descripcion, :limit => 30
      t.integer :sala_id
      t.boolean :activo
    end


    horarios = %w{9:00 10:30 12:00 13:30 15:00 16:30 17:30 18:30}
    Sala.all.each do |sala|
      horarios.each do |horario|
        hora, minutos = horario.split(":")
        Horario.create(:hora => hora, :minutos => minutos, :descripcion => "", :sala_id => sala.id, :activo => true)
      end
    end
  end

  def self.down
    drop_table :horarios
  end
end
