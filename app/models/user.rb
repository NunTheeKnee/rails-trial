class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  #This function checks if the user provided google email exists or not
  def self.from_omniauth(auth)
    user = where(email: auth.info.email).first do |u|
      u.google_auth_uid = auth.uid
    end
    if user.present?
      user
    else
      nil
    end
  end

  #This function updates the user avatar_url and google_auth_id
  def self.update_user_credentials(auth)
    user = where(email: auth.info.email).first do |u|
      u.google_auth_uid = auth.uid
    end
    if user.present?
      user.avatar_url = auth.info.image
      user.google_auth_uid = auth.uid
      user.save
    end
  end
end
