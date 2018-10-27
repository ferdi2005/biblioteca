class PrestitiController < ApplicationController
  before_action :qualcuno?
  before_action :admin?, only: [:consegna]
  def create
    unless params[:id]
      redirect_to libri_path
      flash[:warning] = "Non è possibile richiedere un prestito senza specificare quale libro si voglia chiedere in prestito."
    end
    @libro = Libro.find(params[:id].to_i)
    if @prestito = Prestito.find_by(utente: utente_corrente, libro: @libro)
      redirect_to @prestito
      flash[:danger] = "Non è possibile richiedere un prestito per un libro che si ha già letto. Questa è la pagina del prestito con il quale hai letto questo libro."
    elsif Prestito.find_by(libro: @libro, stato: 0) || Prestito.find_by(libro: @libro, stato: 1)
      redirect_to libri_path
      flash[:danger] = "Ci dispiace ma questo libro è stato già richiesto in prestito da altri."
    elsif utente_corrente.id == @libro.utente.id
      redirect_to libri_path
      flash[:danger] = "Ehi tu! Ma questo è il tuo libro! Non puoi richiedere un prestito per il tuo libro stesso, ce l'hai già a casa!"
    else
      @prestito = Prestito.new(utente: utente_corrente, libro: @libro, stato: 0, scadenza: DateTime.now + 15.days)
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
    prestito = Prestito.find(params[:id])
    prestito.update_attributes(stato: 1, consegna: DateTime.now)
  end

  def restituzione

  end

  def index
    if utente_corrente.admin?
      @utenti = Utente.all
    end
    @daconsegnare_pers = []
    utente_corrente.libro.each do |libro|
      a = Prestito.where(stato: 0, libro: libro)
      a.each do |pres|
        @daconsegnare_pers.push(pres)
      end
    end
    @prestiti = utente_corrente.prestito
  end

  def show
    @prestito = Prestito.find(params[:id].to_i)
  end

end
