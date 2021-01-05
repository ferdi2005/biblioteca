class LibriController < ApplicationController
  before_action :qualcuno?
  before_action :admin?, only: [:approva, :approvare]

  def new
    if(params[:isbn].blank?)
      @libro = Libro.new
    else
      @libro = Libro.new(titolo: params[:titolo], autore: params[:autore], editore: params[:editore], isbn: params[:isbn], anno: params[:anno].to_i)
    end
  end

  def newisbn
  end

  def postisbn
    url = "http://opac.sbn.it/opacmobilegw/search.json?isbn=" + params[:isbn]
    data = HTTParty.get(url).to_h
    # risposta di esempio 
    # => {"numFound"=>1, "start"=>0, "rows"=>20, "briefRecords"=>[{"progressivoId"=>0, "codiceIdentificativo"=>"IT\\ICCU\\UBO\\4283020", "isbn"=>"978-88-08-52068-5", "autorePrincipale"=>"Carrada, Luisa", "copertina"=>"http://covers.librarything.com/devkey/fd11eebee79ccfcfe2f17d34a92e1011/small/isbn/9788808520685", "titolo"=>"Guida di stile : scrivere e riscrivere con consapevolezza / Luisa Carrada", "pubblicazione"=>"Bologna : Zanichelli, 2017", "livello"=>"Monografia", "tipo"=>"Testo a stampa", "numeri"=>[], "note"=>[], "sommarioAbstract"=>[], "nomi"=>[], "luogoNormalizzato"=>[], "localizzazioni"=>[], "citazioni"=>[]}], "facetRecords"=>[{"facetName"=>"level", "facetLabel"=>"Livello bibliografico", "facetValues"=>[["Monografia", "m", "1"]]}, {"facetName"=>"tiporec", "facetLabel"=>"Tipo di documento", "facetValues"=>[["Testo a stampa", "a", "1"]]}, {"facetName"=>"nomef", "facetLabel"=>"Autore", "facetValues"=>[["carrada, luisa", "carrada, luisa", "1"]]}, {"facetName"=>"soggettof", "facetLabel"=>"Soggetto", "facetValues"=>[["redazione di testi", "redazione di testi", "1"]]}, {"facetName"=>"luogof", "facetLabel"=>"Luogo di pubblicazione", "facetValues"=>[["bologna", "bologna", "1"]]}, {"facetName"=>"lingua", "facetLabel"=>"Lingua", "facetValues"=>[["italiano", "ita", "1"]]}, {"facetName"=>"paese", "facetLabel"=>"Paese", "facetValues"=>[["italia", "it", "1"]]}]}
    if data["numFound"] > 0
      book = data["briefRecords"].first
      autore_from = book["autorePrincipale"].gsub(/<[\d\-\s]*>+/, "").split(",")
      autore = "#{autore_from[1].strip} #{autore_from[0].strip}"
      pubblicazione = book["pubblicazione"].match(/([\w\s]*):\s*([\w*\s*\-*\s*]*)\s*,*\s*(\d*)/i)
      editore = pubblicazione[2].strip
      anno = pubblicazione[3].strip
      redirect_to new_libro_path(titolo: book["titolo"].split("/")[0].strip, autore: autore, editore: editore, isbn: params[:isbn].gsub("-", "").strip, anno: anno)
    else
      flash[:warning] = "Nessun libro trovato sul Catalogo del Servizio Bibliotecario Nazionale (OPAC SBN) con questo ISBN"
      redirect_to newisbn_path
    end

  end

  def create
    if utente_corrente.admin?
      stato = 1
      findutente = Utente.find_by_cognome(params[:libro][:utente].downcase)
      if findutente
        utente = findutente
      else
        utente = utente_corrente
      end
    else
      utente = utente_corrente
      stato = 0
    end
      @libro = Libro.new(parametri_creazione.merge(utente: utente, stato: stato))
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
    @ricerca = Libro.search(params[:cerca], params[:genere], params[:pagine])
      if params[:disponibili].nil?
        @pagy, @libro = pagy(@ricerca)
      elsif params[:disponibili] == '1'
        @librivalidi = []
        @ricerca.each do |libro|
          if !Prestito.where(libro: libro, stato: 1).or(Prestito.where(libro: libro, stato: 0))  .any?
            @librivalidi.push(libro)
          end
        end
        @pagy, @libro = pagy(Libro.where(id: @librivalidi.map(&:id)))
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
    unless utente_corrente.admin? || @libro.utente == utente_corrente
      redirect_to libri_path
      flash[:danger] = 'Non sei admin o il proprietario del libro. Tornatene da dove sei venuto.'
    end
    session[:libro_modifica] = @libro.id
  end

  def destroy
    @libro = Libro.find(params[:id])
    unless utente_corrente.admin? || @libro.utente == utente_corrente
      redirect_to libri_path and return
      flash[:danger] = 'Non sei admin o il proprietario del libro. Tornatene da dove sei venuto.'
    end
      if @libro.destroy
        redirect_to root_path
        flash[:success] = "Libro eliminato con successo."
      end
  end

  def update
    @libro = Libro.find(session[:libro_modifica]) || Libro.find(params[:id])
    unless utente_corrente.admin? || @libro.utente == utente_corrente
      redirect_to libri_path and return
      flash[:danger] = 'Non sei admin o il proprietario del libro. Tornatene da dove sei venuto.'
    end
      if !params[:libro][:utente].blank?
        utente = Utente.find_by_cognome(params[:libro][:utente].downcase)
      else
        utente = @libro.utente
      end
      if @libro.update(parametri_creazione.merge(utente: utente))
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
      params.require(:libro).permit(:titolo, :autore, :utente, :isbn, :trama, :foto, :costo, :immagine, :genere, :pagine, :editore, :anno)
  end
