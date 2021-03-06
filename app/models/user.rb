# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  nom        :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
 
 attr_accessor :password, :calculer_age, :imc, :size, :sportif, :sportiff
  attr_accessible :nom, :email, :date_naissance, :password, :password_confirmation, :age, :poids_actuel, :poids_ideal, :taille, :sport, :spor, :data


  has_many :microposts, :dependent => :destroy
  has_many :relationships, :foreign_key => "follower_id",
                           :dependent => :destroy

 has_many :following, :through => :relationships, :source => :followed


 has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower


email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i





  validates :nom,  :presence => true,
                    :length   => { :maximum => 50 }

  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }


 validates :date_naissance, :presence   => true 
			    


 validates :poids_actuel, :presence   => true , numericality: { :greater_than => :poids_ideal}     
         

 validates :poids_ideal, :presence   => true


 validates :taille, :presence   => true

  # Crée automatique l'attribut virtuel 'password_confirmation'.
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }




  def calculer_age
    Time.now.year - self.date_naissance.year
  end


def size
   (self.taille/100)*(self.taille/100)
  end

 def imc
    self.poids_actuel/self.size
  end

 def sportif
    if self.sport==true 
    s="OUI" 
    else 
    s="NON"
   end
  end

 def sportiff
    if self.spor==true 
    s="OUI" 
    else 
    s="NON"
   end
  end

  before_save :encrypt_password

  def has_password?(password_soumis)
    encrypted_password == encrypt(password_soumis)
  end


 def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end




  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end



  def feed
    Micropost.from_users_followed_by(self)
  end

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
