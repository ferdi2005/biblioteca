class Utente < ApplicationRecord
  has_many :libri
  has_many :prestito

  validates :cognome, presence: true, uniqueness: true
  
  has_secure_password
end
