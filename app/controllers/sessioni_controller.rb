class SessioniController < ApplicationController
  def new
  end
  def create
    @utente = Utente.find_by_cognome(params[:utente][:cognome].downcase)
    if @utente
      if !@utente.admin && ENV['ADMIN'] && ENV['ADMIN'].downcase.split(',').include?(@utente.cognome.downcase)
        @utente.update_attribute(:admin, true)
      end
    if @utente.admin?
      if @utente.authenticate(params[:utente][:password])
        session[:id] = @utente.id
      else
        redirect_to login_path
        flash[:danger] = "Password errata. Contattare l'amministratore di sistema"
      end
    else
      session[:id] = @utente.id
    end
  else
    redirect_to login_path
    flash[:danger] = "Utente non trovato!"
  end
  end

  def logout
    if loggato?
      session.delete(:id)
      @utente_corrente = nil
      utente_corrente = nil
      redirect_to login_path
    end
  end
end
