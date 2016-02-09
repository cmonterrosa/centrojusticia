class Procedencia < ActiveRecord::Base
  has_many :extraordinarias
  has_many :users
end
