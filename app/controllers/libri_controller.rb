class LibriController < ApplicationController
  before_action :qualcuno?
  before_action :admin?, only: [:approva, :approvare]
  def new
    @libro = Libro.new
  end

  def create
    if utente_corrente.admin?
      findutente = Utente.find_by_cognome(params[:libro][:utente].downcase)
      if findutente
        utente = findutente
      else
        utente = utente_corrente
      end
      valore = 1
    else
      utente = utente_corrente
      valore = 0
    end
      @libro = Libro.new(parametri_creazione.merge(utente: utente, stato: valore))
    if @libro.save
      redirect_to @libro
      flash[:success] = "Grazie per aver deciso di condividere questo libro con la classe, #{utente_corrente.cognome.capitalize}"
    else
      redirect_to new_libro_path
      flash[:danger] = "#{@libro.errors.each {|errore| puts errore.to_s }}"
    end
  end

  def index
    unless loggato?
      redirect_to login_path
    end
    if params[:cerca]
      cerca = params[:cerca]
      @libro = Libro.where.has { (:nome =~ "#{cerca}") & (:stato == 1) | (:autore =~ "#{cerca}") & (:stato == 1)}
      if !params[:genere].blank?
        @libro = Libro.where.has { (:nome =~	params[:cerca]) & (:genere == params[:genere]) & (:stato == 1) | (:autore =~	params[:cerca]) & (:genere == params[:genere]) & (:stato == 1)}
      elsif !params[:pagine].blank?
        @libro = Libro.where.has{(:nome =~	params[:cerca]) & (:pagine == params[:pagine]) & (:stato == 1) | (:autore =~	params[:cerca]) & (:pagine == params[:pagine]) & (:stato == 1)}
      elsif !params[:genere].blank? && !params[:pagine].blank?
        @libro = Libro.where.has{(:nome =~	params[:cerca]) & (:pagine == params[:pagine]) & (:genere == params[:genere]) & (:stato == 1)| (:autore =~	params[:cerca]) & (:pagine == params[:pagine]) & (:genere == params[:genere]) & (:stato == 1)}
      end
    else
      @libro = Libro.where(stato: 1)
    end
  end

  def show
    @libro = Libro.find(params[:id].to_i)
  end

  def approvare
    @libri = Libro.where(stato: 0)
  end

  def approva
    @libro = Libro.find(params[:id].to_i)
    if utente_corrente.admin?
      @libro.update_attribute(:stato, 1)
      redirect_to root_path
      flash[:success] = 'Libro approvato'
    else
      redirect_to root_path
      flash[:danger] = "Non sei amministratore. Tornatene da dove sei venuto."
    end
  end

end
private
def parametri_creazione
    params.require(:libro).permit(:titolo, :autore, :utente, :isbn, :trama, :foto, :costo, :immagine, :genere, :pagine)
end
