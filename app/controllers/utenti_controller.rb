class UtentiController < ApplicationController
  before_action :admin?, only: [:create, :new]
  def new
    @utente = Utente.new
  end

  def create
      @utente = Utente.new(cognome: params[:utente][:cognome].downcase)
      @utente.password = ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(5).join
      if @utente.save
        redirect_to registrazione_path
        flash[:success] = "Utente creato con successo! Se è amministratore, la password è: #{@utente.password}"
      else
        redirect_to registrazione_path
        flash[:danger] = 'ERRORE'
      end
    end
  end
private
  def parametri_utente
    params.require(:utente).permit(:cognome)
  end
