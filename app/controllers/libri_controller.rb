class LibriController < ApplicationController
  before_action :qualcuno?
  before_action :admin?, only: [:approva, :approvare, :edit, :update, :destroy]
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
    if !params[:cerca].blank?
      @pagy, @libro = pagy(Libro.search(params[:cerca]))
    elsif !params[:genere].blank?
      @pagy, @libro = pagy(Libro.search(params[:cerca], params[:genere]))
    elsif !params[:pagine].blank?
      @pagy, @libro = pagy(Libro.search(params[:cerca], nil, params[:pagine]))
    elsif !params[:genere].blank? && !params[:pagine].blank?
      @pagy, @libro = pagy(Libro.search(params[:cerca], params[:genere], params[:pagine]))
    else
      @pagy, @libro = pagy(Libro.where(stato: 1))
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

  def edit
    @libro = Libro.find(params[:id])
    session[:libro_modifica] = @libro.id
  end

  def destroy
    @libro = Libro.find(params[:id])
      if @libro.destroy
        redirect_to root_path
        flash[:success] = "Libro eliminato con successo."
      end
  end

  def update
    @libro = Libro.find(session[:libro_modifica]) || Libro.find(params[:id])
      if !params[:libro][:utente].blank?
        utente = Utente.find_by_cognome(params[:libro][:utente])
      else
        utente = @libro.utente
      end
      if @libro.update_attributes(parametri_creazione.merge(utente: utente))
        redirect_to @libro
        flash[:success] = "Informazioni del libro modificate con successo."
      else
        render 'edit'
        flash[:danger] = "Errore #{@libro.errors.each { |error| puts error}}"
      end
  end

end

private
  def parametri_creazione
      params.require(:libro).permit(:titolo, :autore, :utente, :isbn, :trama, :foto, :costo, :immagine, :genere, :pagine)
  end
