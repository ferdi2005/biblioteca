Rails.application.routes.draw do
  root "libri#index"

  get 'registrazione', to: 'utenti#new'
  #TODO: mettere nella navbar solo admin
  post 'registrazione', to: 'utenti#create'

  get 'richiedi', to: 'prestiti#create'
  delete 'logout', to: 'sessioni#logout'

  get 'login', to: 'sessioni#new'
  post 'login', to: 'sessioni#create'

  get 'approvare', to: 'libri#approvare'
  #TODO: mettere in navbar solo admin
  get 'approva', to: 'libri#approva'

  resources :libri
  resources :prestiti, only: [:show, :index]

  get 'consegna', to: 'prestiti#consegna'

  #TODO: Metterlo nella navbar come sottovoce di prestiti
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
