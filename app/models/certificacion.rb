class Certificacion < ActiveRecord::Base
  belongs_to :empleado

   def generar_folio
     unless self.folio
       maximo=  Certificacion.maximum(:folio)
        folio = 1 unless maximo
        folio ||= maximo.to_i + 1
        self.folio = folio
     end
   end

end
