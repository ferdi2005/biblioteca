module PrestitiHelper
  def statoprestito(prestito)
    case prestito.stato
      when 0
        s = 'prestito richiesto'
      when 1
        s = 'libro consegnato'
          if Date.today > prestito.scadenza
            s = 'IN RITARDO SULLA RESTITUZIONE'
          end
      when 2
        s = 'libro restituito'
    end
    return s
  end
end
