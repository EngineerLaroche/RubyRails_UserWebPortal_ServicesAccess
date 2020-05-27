
# INFORMATION

Institution:    Ecole de Technologie Superieure (ETS)
Created by:		Alexandre Laroche
Date:			11 april 2018


# OBJECTIFS & FONCTIONNALITES

PORTAIL WEB qui permet de regrouper les Ressources de supervision de droits d’accès du Québec (RSDA).
Favoriser la concertation, l’échange et la collaboration entre les membres et les différents partenaires.

Portail web permet de gerer (afficher, creer, modifier, lier, supprimer, etc);

- Usagers
- Profils usager
- Authentification
- Recuperation de mot de passe

- Organismes
- Organismes-Referents
- Referents

- Services (tarification)
- Points de services
- Locaux (disponibilite)

- Envoi de emails avec attachements
- Encryption des donnees


# TECHNOLOGIES

Ruby on Rails, BoosStrap, HTML 5, CSS 3, CloudFlare, Bundler, Ubuntu 18, etc.


# DEMARRER PORTAIL WEB

1- Installer Ruby on Rails sur Ubuntu 18:

	https://www.howtoforge.com/tutorial/ubuntu-ruby-on-rails/

2- Ouvrir Terminal Linux dans le repertoire source du projet.

3- Mettre a jour Bundler:

	$ bundle update --bundler

4- Installer les dependances:

	$ bundle install
	$ bundle update

5- Demarrer serveur Rails:

	$ rails server

6- Ouvrir un navigateur web et entrer l'URL:  0.0.0.0:3000


# CONNEXION PORTAIL WEB

### User 1

Email:		admin@outlook.com
Password:	welcome

Username:	Alexandre
Role:		directeur

### User 2

Email:		evelyne@outlook.com
Password:	welcome

Username:	Evelyne
Role:		intervenant


# CONSOLE RAILS

La console Rails permet de verifier certaines informations sans devoir passer par un UI.


Démarrer console:		$ rails console
Quitter console:		ctrl + d

Demarrer console test:	$ rails console --sandbox
Quitter console test:	ctrl + d


Trouver usager:

	>> user = User.find_by(email: "admin@outlook.com")

Afficher info usager

	>> user

Creer usager:

	>> user = User.new(name: "alexandre", email: "admin@outlook.com", password: "welcome", password_confirmation: "welcome", role: "directeur")
	>> user.valid?
	>> user.save

Modifier usager:

	>> user.update_attribute(:activated, true)
	>> user.update_attribute(:activated_at, Time.zone.now)
	>> user.save

Verifier role usager:

	>> user.role?

Changer role usager:

	>> user.role = ‘directeur’
	>> user.save
	>> user.role?


Supprimer une table de la BD:

	>> ActiveRecord::Migration.drop_table(:users)


Supprimer une colonne d'une table de la DB:

	>> ActiveRecord::Migration.remove_column :table_name, :column_name


Supprimer un indexde la BD:

	>> ActiveRecord::Migration.remove_index :users, :email


Ajouter une colonne a la BD:

	>> ActiveRecord::Migration.add_column :users, :email, :string


# DATABASE

Mettre a jour la BD:

	$ rails db:migrate
	$ rake db:migrate

Creer automatiquement des classes MVC:

	$ rails generate controller nomClasseAuPluriel new
	$ rails generate model nomClasseAuSingulier 


Exemple:

	$ rails generate controller Organismes new
	$ rails generate model Organisme nom:string email:string   etc... 


Ajouter des variables:

	$ rails db:migrate pour que les variables fonctionnent)


Ajouter un Fichier dans la DB:

	$ rails generate migration nomDuFichier


# TROUBLESHOOT

### Raison inconnue

	$ spring stop
	$ sudo bundle install

### Base de donnees

	$ bin/rails db:migrate RAILS_ENV=development
	$ rails db:migrate
	$ rake db:migrate

### Usager

	$ rails console
	>> user = User.find_by(email: "admin@outlook.com")
	>> user
	ctrl + d


	$ rails console
	>> User.all
	ctrl + d


# REFERENCES

Installer Ruby on Rails: https://www.howtoforge.com/tutorial/ubuntu-ruby-on-rails/

Creation usager: http://railstutorial.org
                 http://www.railstutorial.org/book

Recherche: http://www.korenlc.com/creating-a-simple-search-in-rails-4/

Historique Tarification: https://github.com/collectiveidea/audited


# LICENCE

Copyright 2018 Alexandre Laroche. 
All rights reserved.