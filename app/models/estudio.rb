class Estudio < ActiveRecord::Base
  belongs_to :nivel_academico
  acts_as_tree :order => "descripcion"

  def descripcion_jerarquica
    string=[]
    string<<self.descripcion if self.descripcion
    parent=self.parent if self.parent_id
    while (parent)
      string << parent.descripcion if parent.descripcion
      parent=parent.parent
    end
    (string) ? string.reverse.join(" > ") : " "
  end
  
end
