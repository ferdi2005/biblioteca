module SessioniHelper
  def utente_corrente
    utente_corrente = Utente.find_by(session[:id])
  end

  def loggato?
    !utente_corrente.nil?
  end
end
