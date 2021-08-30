 class Comparecencia < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :user
  has_many :participantes
  has_one :expediente
  has_one :etapa

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
         @sexo_involucrado = @involucrados.first.sexo if (@involucrados && @involucrados.first && @involucrados.first.sexo)
        if @involucrados.first.tipopersona_id==1
          cadena= ((@involucrados.first) ? (@involucrados.first.articulo_por_su_genero.downcase + " <b>C. #{@involucrados.first.nombre_completo.mb_chars.downcase.titleize}</b>") : '')
        else
          cadena= "la pesona moral <b>#{@involucrados.first.razon_social.mb_chars.downcase.titleize}</b>"
        end
        @descripcion << cadena
      when 2..15
        #@descripcion << @involucrados.map{|i|(i.articulo_por_su_genero + " C. #{i.nombre_completo}")}.join(" Y ")
        @descripcion << " los <b>CC. "        
        @descripcion << @involucrados.map { |p| p.nombre_completo.mb_chars.downcase.titleize }.to_sentence
        @descripcion << "</b>"      
    else
      @descripcion << "los involucrados"
     end
    end
  end

  def involucrados_full
    @descripcion=""
    if @involucrados = Participante.find(:all, :conditions => ["comparecencia_id = ? AND perfil = 'INVOLUCRADO'", self.id], :order => "created_at")
    case @involucrados.size
      when 1
         @sexo_involucrado = @involucrados.first.sexo if (@involucrados && @involucrados.first && @involucrados.first.sexo)
        if @involucrados.first.tipopersona_id==1
          cadena= ((@involucrados.first) ? (@involucrados.first.articulo_por_su_genero.downcase + " <b>C. #{@involucrados.first.nombre_completo.mb_chars.downcase.titleize}</b>") : '')
        else
          cadena= "la pesona moral <b>#{@involucrados.first.razon_social.mb_chars.downcase.titleize}</b>"
        end
        @descripcion << cadena
      when 2..15
        @descripcion << "los <b>CC. "        
        @descripcion << @involucrados.map { |p| p.nombre_completo.mb_chars.downcase.titleize }.to_sentence
        @descripcion << "</b>"        
    else
      @descripcion << "los involucrados"
     end
    end
  end

  def solicitantes_full
    @descripcion=""
    if @solicitantes = Participante.find(:all, :conditions => ["comparecencia_id = ? AND perfil = 'SOLICITANTE'", self.id], :order => "created_at")
      case @solicitantes.size
        when 1
          @sexo_solicitante = @solicitantes.first.sexo if (@solicitantes && @solicitantes.first && @solicitantes.first.sexo)
          if @solicitantes.first.tipopersona_id==1
            cadena=(@sexo_solicitante == 'F')? "la <b>C.</b>" : "el <b>C.</b>" if @sexo_solicitante
          else
            cadena= "la persona moral"
          end  
          @descripcion << cadena
          @descripcion <<  ((@solicitantes && @solicitantes.first) ? (" <b>#{@solicitantes.first.nombre_completo.mb_chars.downcase.titleize}</b>") : '')
        when 2..15
          @descripcion << "los <b>CC. "
          @descripcion << @solicitantes.map { |p| p.nombre_completo.mb_chars.downcase.titleize }.to_sentence
          @descripcion << "</b>"        
      else
        @descripcion << "los solicitantes"
      end
    end
  end

  def descripcion_solicitantes_con_articulo
    @descripcion=""
    if @solicitantes = Participante.find(:all, :conditions => ["comparecencia_id = ? AND perfil = 'SOLICITANTE'", self.id], :order => "created_at")
      case @solicitantes.size
        when 1
          @sexo_solicitante = @solicitantes.first.sexo if (@solicitantes && @solicitantes.first && @solicitantes.first.sexo)
          if @solicitantes.first.tipopersona_id==1
            cadena=(@sexo_solicitante == 'F')? "de la <b>C.</b>" : "del <b>C.</b>" if @sexo_solicitante
          else
            cadena= "de la persona moral"
          end  
          @descripcion << cadena
          @descripcion <<  ((@solicitantes && @solicitantes.first) ? (" <b>#{@solicitantes.first.nombre_completo.mb_chars.downcase.titleize}</b>") : '')
        when 2..15
          @descripcion << "de los <b>CC. "
          @descripcion << @solicitantes.map { |p| p.nombre_completo.mb_chars.downcase.titleize }.to_sentence
          @descripcion << "</b>"        
      else
        @descripcion << "los solicitantes"
      end
    end
  end



end
