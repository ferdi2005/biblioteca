class Prestito < ApplicationRecord
  belongs_to :utente
  belongs_to :libro

  def self.scadenza
      where("scadenza < ?", "%#{DateTime.now}%").where(stato: 1)
  end
end
