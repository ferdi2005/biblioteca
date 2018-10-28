class Prestito < ApplicationRecord
  belongs_to :utente
  belongs_to :libro

  def self.scadenza
      where("scadenza < ?", "#{Date.today}").where(stato: 1)
  end
end
