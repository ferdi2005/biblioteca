class Libro < ApplicationRecord
  belongs_to :utente
  has_many :prestito
  has_one_attached :immagine

  validates :titolo, presence: true, uniqueness: true
  validates :autore, presence: true
  validates :pagine, presence: true
  validates :genere, presence: true

  def self.search(search = '', genere = '', pagine = '')
      a = where("1 = ?", '1')
      if !search.blank?
        a = a.where("(lower(titolo) LIKE lower(?) OR lower(autore) LIKE lower(?)) AND stato = 1", "%#{search.strip}%", "%#{search.strip}%")
      end
      if !pagine.blank?
        a = a.where('pagine = ?', "#{pagine.strip}")
      end
      if !genere.blank?
        a = a.where('genere = ?', "#{genere.strip}")
      end
      return a
  end
end
