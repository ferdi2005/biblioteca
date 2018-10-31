class Libro < ApplicationRecord
  belongs_to :utente
  has_many :prestito
  has_one_attached :immagine

  validates :titolo, presence: true, uniqueness: true
  validates :autore, presence: true
  validates :pagine, presence: true
  validates :genere, presence: true

  def self.search(search, genere = nil, pagine = nil)
    if !genere.nil?
      where("(lower(titolo) LIKE lower(?) OR lower(autore) LIKE lower(?)) AND lower(genere) = lower(?) AND stato = 1", "%#{search}%", "%#{search}%", "#{genere}")
    elsif !pagine.nil?
      where("(lower(titolo) LIKE lower(?) OR lower(autore) LIKE lower(?)) AND lower(pagine) = lower(?) AND stato = 1", "%#{search}%", "%#{search}%", "#{pagine}")
    elsif !genere.nil? && !pagine.nil?
      where("(lower(titolo) LIKE lower(?) OR lower(autore) LIKE lower(?)) AND lower(genere) = lower(?) AND lower(pagine) = lower(?) AND stato = 1", "%#{search}%", "%#{search}%", "#{genere}", "#{pagine}")
    else
      where("(lower(titolo) LIKE lower(?) OR lower(autore) LIKE lower(?)) AND stato = 1", "%#{search}%", "%#{search}%")
    end
  end
end
