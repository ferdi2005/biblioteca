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
      where("(titolo LIKE ? OR autore LIKE ?) AND genere = ?", "%#{search}%", "%#{search}%", "#{genere}")
    elsif !pagine.nil?
      where("(titolo LIKE ? OR autore LIKE ?) AND pagine = ?", "%#{search}%", "%#{search}%", "#{pagine}")
    elsif !genere.nil? && !pagine.nil?
      where("(titolo LIKE ? OR autore LIKE ?) AND genere = ? AND pagine ", "%#{search}%", "%#{search}%", "#{genere}", "#{pagine}")
    else
      where("titolo LIKE ? OR autore LIKE ?", "%#{search}%", "%#{search}%")
    end
  end
end
