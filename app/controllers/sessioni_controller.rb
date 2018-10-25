class SessioniController < ApplicationController
  def new
  end
  def create
    if params[:utente][:cognome] == ENV['BASE']
      Utente.create(cognome: params[:utente][:cognome].downcase, admin: true, password: ENV['BASEPASSWORD'], password_confirmation: ENV['BASEPASSWORD'])
      redirect_to login_path and return
      flash[:info] = "Prima configurazione: successo"
    end
    @utente = Utente.find_by_cognome(params[:utente][:cognome].downcase)
    if @utente
    if @utente.admin?
      if @utente.authenticate(params[:utente][:password])
        session[:id] = @utente.id
        flash[:success] = "Benvenuto nell'applicazione della biblioteca di classe. Login effettuato con successo. ADMIN"
      else
        redirect_to login_path
        flash[:danger] = "Password errata. Contattare l'amministratore di sistema"
      end
    else
      session[:id] = @utente.id
      redirect_to root_path
      flash[:success] = "Benvenuto nell'applicazione della biblioteca di classe. Login effettuato con successo"
    end
  else
    redirect_to login_path
    flash[:danger] = "Utente non trovato!"
  end
  end

  def logout
    session.delete(:id)
    utente_corrente = nil
    redirect_to root_path
  end
end
