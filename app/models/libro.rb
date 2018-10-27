class Libro < ApplicationRecord
  belongs_to :utente
  has_many :prestito
  has_one_attached :immagine

  validates :titolo, presence: true
  validates :autore, presence: true
  validates :pagine, presence: true
  validates :genere, presence: true

  def self.search(search, genere = nil, pagine = nil)
      where("titolo LIKE ?", "%#{search}%").or(where("autore LIKE ?", "%#{search}%")).where(genere: genere, pagine: pagine, stato: 1)
  end
end
