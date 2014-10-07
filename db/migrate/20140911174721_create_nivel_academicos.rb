class CreateNivelAcademicos < ActiveRecord::Migration
  def self.up
    create_table :nivel_academicos do |t|
      t.string :descripcion
    end
    NivelAcademico.create(:descripcion => "primaria")
    NivelAcademico.create(:descripcion => "secundaria")
    NivelAcademico.create(:descripcion => "bachillerato")
    NivelAcademico.create(:descripcion => "licenciatura")
    NivelAcademico.create(:descripcion => "maestria")
    NivelAcademico.create(:descripcion => "especialidad")
    NivelAcademico.create(:descripcion => "doctorado")
  end

  def self.down
    drop_table :nivel_academicos
  end
end
