class PrestitiController < ApplicationController
  before_action :qualcuno?
  before_action :admin?, only: [:consegna, :restituisci, :restituzione]

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
    prestito = Prestito.find(params[:id])
    if prestito.stato == 0
      prestito.update_attributes(stato: 1, consegna: Date.today, scadenza: Date.today + 15.days)
      redirect_to prestito
      flash[:success] = "La consegna del libro è stata registrata con successo, la data di scadenza è stata inserita."
    else
      redirect_to prestito
      flash[:danger] = "Un prestito consegnato o chiuso non può essere registrato nuovamente come consegnato."
    end
  end

  def restituisci
    @prestito = Prestito.find(params[:id])
    session[:id_prestito] = params[:id]
  end

  def restituzione
    unless session[:id_prestito]
      redirect_to libri_path
      flash[:danger] = "Non è possibile restituire un prestito senza prima aver premuto il tasto di restituzione sul prestito giusto o aver indicato l'ID"
    end
    @prestito = Prestito.find(session[:id_prestito])
    if @prestito.stato == 1
      @prestito.update_attributes(recensione: params[:prestito][:recensione], voto: params[:prestito][:ranking], note: params[:prestito][:note], stato: 2, restituzione: Date.today)
      p = Prestito.where(libro_id: @prestito.libro.id)
      @prestito.libro.update_attribute(:voto, p.average(:voto).to_i)
      redirect_to libri_path
      flash[:success] = "Restituzione del libro effettuata con successo"
    else
      redirect_to restituisci_path(id: session[:id_prestito])
      flash[:warning] = "Uno o più parametri non sono stati compilati o non sono stati compilati correttamente."
    end
  end

  def index
    if utente_corrente.admin?
      @utenti = Utente.all
    end
    @prestitiscaduti_usr = Prestito.scadenza.where(utente: utente_corrente)
    @daconsegnare_pers = []
    utente_corrente.libri.each do |libro|
      a = Prestito.where(stato: 0, libro: libro)
      a.each do |pres|
        @daconsegnare_pers.push(pres)
      end
    end
    @pagyuno, @prestiti = pagy(utente_corrente.prestito)
  end

  def show
    @prestito = Prestito.find(params[:id].to_i)
  end

end
