class PrestitiController < ApplicationController
  before_action :qualcuno?
  def create
    unless params[:id]
      redirect_to libri_path
      flash[:warning] = "Non è possibile richiedere un prestito senza specificare quale libro si voglia chiedere in prestito."
    end
    @libro = Libro.find(params[:id].to_i)
    if utente_corrente.id == @libro.utente.id
      redirect_to libri_path
      flash[:danger] = "Ehi tu! Ma questo è il tuo libro! Non puoi richiedere un prestito per il tuo libro stesso, ce l'hai già a casa!"
      else
      @prestito = Prestito.new(utente: utente_corrente, libro: @libro, stato: 0)
      if @prestito.save
        redirect_to @prestito
        flash[:success] = "Prestito richiesto con successo."
      else
        redirect_to @prestito
        flash[:danger] = "Errore! #{@prestito.errors.each {|errore| puts errore}}"
      end
    end
  end

  def consegna
  end

  def restituzione

  end

  def index
    if utente_corrente.admin?
      @utenti = Utente.all
    end
    @prestiti = utente_corrente.prestiti
  end

  def show
    @prestito = Prestito.find(params[:id].to_i)
  end
end
