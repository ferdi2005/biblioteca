class Prestito < ApplicationRecord
  belongs_to :utente
  belongs_to :libro
end
