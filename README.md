# Biblioteca di Classe
![](https://user-images.githubusercontent.com/19609180/47618091-31007880-dacf-11e8-8a2e-66c30eedb934.png)
[Biblioteca di classe](http://ferdinando.xyz/0216e3d204f3) è una piccola applicazione scritta con Ruby on Rails che serve a gestire una biblioteca di classe.
I libri possono trovarsi anche presso gli alunni, dato che tutti i passaggi vengono eseguiti online e sono visibili dall'alunno.
## Installazione
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/ferdi2005/biblioteca)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fferdi2005%2Fbiblioteca.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fferdi2005%2Fbiblioteca?ref=badge_shield)

Biblioteca di classe può essere installato direttamente su Heroku (con il tasto qui sopra) oppure manualmente (è un'app Rails 5.2.1 con Ruby 2.5.1). Per il funzionamento dell'applicazione sono necessari le variabili `ENV['BASE']` ed `ENV['BASEPASSWORD']` che corrispondono praticamente all'username ("cognome") ed alla password dell'utente admin di base, che verrà creato al primo accesso e potrà creare altri admin. Per scelta, solo gli admin hanno la password, mentre gli utenti (per semplificare) possono usare il loro cognome.

Come ogni applicazione Rails, ricordatevi sempre di fare un bel `bundle install` e `rails db:migrate`.
## Come funziona
Tutte le eventuali guide si troveranno nella [wiki Github del progetto](https://github.com/ferdi2005/biblioteca/wiki).
## Contribuire
Tutti i contributi sono ben accetti! Aspetto i vostri suggerimenti e consigli.


## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fferdi2005%2Fbiblioteca.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fferdi2005%2Fbiblioteca?ref=badge_large)