Rails.application.routes.draw do
  get 'statistiche/stat'
  root "libri#index"

  get 'registrazione', to: 'utenti#new'
  post 'registrazione', to: 'utenti#create'

  get 'richiedi', to: 'prestiti#create'
  delete 'logout', to: 'sessioni#logout'

  get 'login', to: 'sessioni#new'
  post 'login', to: 'sessioni#create'

  get 'approvare', to: 'libri#approvare'
  get 'approva', to: 'libri#approva'

  resources :libri
  resources :prestiti, only: [:show, :index]

  get 'consegna', to: 'prestiti#consegna'
  get 'restituisci', to: 'prestiti#restituisci'
  post 'restituisci', to: 'prestiti#restituzione'

  get 'newisbn', to: "libri#newisbn"
  post 'postisbn', to: "libri#postisbn"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
