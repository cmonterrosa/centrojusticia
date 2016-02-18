class AddDomicilioLaboral < ActiveRecord::Migration
  def self.up
    add_column :participantes, :domicilio_laboral, :string
    add_column :participantes, :referencias_domiciliares_laboral, :string
  end

  def self.down
    remove_column :participantes, :domicilio_laboral
    remove_column :participantes, :referencias_domiciliares_laboral
  end
end
