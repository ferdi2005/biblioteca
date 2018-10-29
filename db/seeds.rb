# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
30.times do
  genere = ["Storico", "fantascienza", "fantasy", "avventura", "horror", "azione", "thriller", "giallo", "rosa", "umoristico", "fiaba", "biografia", "diario", "divulgativo-argomentativo", "poesia"].sample
  pagine = ["0-100", "100-200", "200-300", "300+"].sample
  titolo = Faker::Book.title
  autore = Faker::Book.author
  u = Utente.first

  Libro.create!(titolo: titolo, autore: autore,genere: genere ,pagine: pagine,utente_id: 1, stato: 1)
end
