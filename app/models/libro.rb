class Libro < ApplicationRecord
  belongs_to :utente
  has_many :prestito
  has_one_attached :immagine

  validates :titolo, presence: true
  validates :autore, presence: true
  validates :pagine, presence: true
  validates :genere, presence: true

  def self.search(search, genere = nil, pagine = nil)
    if !genere.nil?
      where("(titolo LIKE ? OR autore LIKE ?) AND genere = ? AND stato = 1", "%#{search}%", "%#{search}%", "#{genere}")
    elsif !pagine.nil?
      where("(titolo LIKE ? OR autore LIKE ?) AND pagine = ? AND stato = 1", "%#{search}%", "%#{search}%", "#{pagine}")
    elsif !genere.nil? && !pagine.nil?
      where("(titolo LIKE ? OR autore LIKE ?) AND genere = ? AND pagine = ? AND stato = 1", "%#{search}%", "%#{search}%", "#{genere}", "#{pagine}")
    else
      where("(titolo LIKE ? OR autore LIKE ?) AND stato = 1", "%#{search}%", "%#{search}%")
    end
  end
end
