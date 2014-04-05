
Factory.define :user do |user|
  user.nom                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
  user.date_naissance "16-05-1990"
  user.poids_actuel "75"
  user.poids_ideal "12"
  user.taille "175"
  user.sport true
  user.spor true
  user.data ""
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
  micropost.content "Foo bar"
  micropost.association :user
end
