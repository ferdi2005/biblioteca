class LibriController < ApplicationController
  before_action :qualcuno?
  def new
    @libro = Libro.new
  end

  def create
    if utente_corrente.admin?
      utente = Utente.find_by_cognome(params[:utente].downcase)
      @libro = Libro.new(titolo: params[:libro][:titolo], autore: params[:libro][:autore], utente: utente)
    else
      @libro = Libro.new(titolo: params[:libro][:titolo], autore: params[:libro][:autore], utente: utente_corrente)
    end
    if @libro.save
      redirect_to @libro
      flash[:success] = "Grazie per aver deciso di condividere questo libro con la classe, #{utente_corrente.cognome}"
    else
      redirect_to new_libro_path
      flash[:danger] = "#{@libro.errors.each {|errore| puts errore.to_s }}"
    end
  end

  def index
    unless loggato?
      redirect_to login_path
    end
    @libro = Libro.all
  end

  def show
    @libro = Libro.find(params[:id])
  end
end
private
def parametri_creazione
  params.require(:libro).permit(:titolo, :autore)
end
