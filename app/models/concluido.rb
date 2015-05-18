class Concluido < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :user
  belongs_to :motivo_conclusion
  validates_uniqueness_of :motivo_conclusion_id, :scope => :tramite_id
end
