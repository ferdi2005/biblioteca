class Libro < ApplicationRecord
  belongs_to :utente
  has_many :prestito

  validates :titolo, presence: true
  validates :autore, presence: true
end
