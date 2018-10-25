class Utente < ApplicationRecord
  has_many :libri
  has_many :prestito

  validates :cognome, presence: true, uniqueness: true
  validates :password, presence: false, uniqueness: false, allow_blank: true

  has_secure_password
end
