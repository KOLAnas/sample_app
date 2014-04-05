require 'faker'

namespace :db do
  desc "Peupler la base de donnees"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
    administrateur = User.create!(:nom => "Example User",
                         :email => "example@railstutorial.org",
                         :password => "foobar",
                         :password_confirmation => "foobar",
			 :date_naissance => "16/05/1976",
			 :poids_actuel => "80.5",
			 :poids_ideal => "70",
			 :taille => "175",
			 :sport => true,
			 :spor =>  true,
			 :data => "")
    administrateur.toggle!(:admin)

  
    admin = User.create!(:nom => "Selassi Anas",
                         :email => "selassi.anas@gmail.com",
                         :password => "selassi",
                         :password_confirmation => "selassi",
			 :date_naissance => "16/05/1990",
			 :poids_actuel => "80.5",
			 :poids_ideal => "70",
			 :taille => "175",		 
			 :sport => true,
			 :spor =>  true,
			 :data => "")
    admin.toggle!(:admin)

    99.times do |n|
      nom  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "motdepasse"
      age = "54"
      date_naissance="16/08/1960"
      poids_actuel = "67"
      poids_ideal = "56"
      User.create!(:nom => nom,
                   :email => email,
                   :password => password,
                   :password_confirmation => password,
		   :date_naissance => date_naissance,
		   :poids_actuel => poids_actuel,
		   :poids_ideal => poids_ideal,
 		   :taille => "175",
		   :sport => true,
		   :spor =>  true,
		   :data => "")
    end
end


def make_microposts
    User.all(:limit => 6).each do |user|
      50.times do
        user.microposts.create!(:content => Faker::Lorem.sentence(5))
      end
    end
  end



def make_relationships
  users = User.all
  user  = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end
