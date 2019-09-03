class Utente < ApplicationRecord
  has_many :libri
  has_many :prestito

  validates :cognome, presence: true, uniqueness: true
  before_create { cognome.downcase! }
  has_secure_password :validations => false
end
