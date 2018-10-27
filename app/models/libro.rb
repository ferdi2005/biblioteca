class Libro < ApplicationRecord
  belongs_to :utente
  has_many :prestito
  has_one_attached :immagine

  validates :titolo, presence: true
  validates :autore, presence: true
  validates :pagine, presence: true
  validates :genere, presence: true 
end
