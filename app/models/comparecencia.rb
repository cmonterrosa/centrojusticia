class Comparecencia < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :user
  has_many :participantes
  has_one :expediente

  #validates_uniqueness_of :tramite_id

  def before_save
#    self.asunto.upcase! if self.asunto
#    self.caracter.upcase! if self.caracter
#    self.datos.upcase! if self.datos
#    self.dia_preferencia.upcase if self.dia_preferencia
#    self.hora_preferencia.upcase if self.hora_preferencia
#    self.procedencia.upcase! if self.procedencia
  end

  def solicitante
    return (Participante.find(:first, :conditions => ["comparecencia_id = ? AND perfil = 'SOLICITANTE'", self.id]))
  end

  def solicitantes
    @solicitantes = Participante.find(:all, :conditions => ["comparecencia_id = ? AND perfil = 'SOLICITANTE'", self.id])
    (@solicitantes) ? @solicitantes.map{|x|x.nombre_completo}.join(", ") : nil
  end

  def involucrados
    @involucrados = Participante.find(:all, :conditions => ["comparecencia_id = ? AND perfil = 'INVOLUCRADO'", self.id])
    (@involucrados) ? @involucrados.map{|x|x.nombre_completo}.join(", ") : nil
  end

  def descripcion_involucrados_con_articulo
    @descripcion=""
    if @involucrados = Participante.find(:all, :conditions => ["comparecencia_id = ? AND perfil = 'INVOLUCRADO'", self.id], :order => "created_at")
    case @involucrados.size
      when 1
        cadena= ((@involucrados.first) ? (@involucrados.first.articulo_por_su_genero + " C. #{@involucrados.first.nombre_completo}") : '')
        @descripcion << cadena
      when 2
        @descripcion << @involucrados.map{|i|(i.articulo_por_su_genero + " C. #{i.nombre_completo}")}.join(" Y ")
      when 3..10
        @descripcion << @involucrados.map{|i|(i.articulo_por_su_genero + " C. #{i.nombre_completo}")}.join(" , ")
    else
      @descripcion << "LOS INVOLUCRADOS"
     end
    end
  end

  def descripcion_solicitantes_con_articulo
    @descripcion=""
    if @solicitantes = Participante.find(:all, :conditions => ["comparecencia_id = ? AND perfil = 'SOLICITANTE'", self.id], :order => "created_at")
      case @solicitantes.size
        when 1
          @sexo_solicitante = @solicitantes.first.sexo if (@solicitantes && @solicitantes.first)
          cadena=(@sexo_solicitante == 'F')? "DE LA " : "DEL " if @sexo_solicitante
          @descripcion << cadena
          @descripcion <<  ((@solicitantes && @solicitantes.first) ? ("C. #{@solicitantes.first.nombre_completo}") : '')
        when 2..9
          @descripcion << "DE "
          @descripcion << @solicitantes.map{|i|("C. #{i.nombre_completo}")}.join(" Y ")
      else
        @descripcion << "LOS SOLICITANTES"
      end
    end
  end



end
