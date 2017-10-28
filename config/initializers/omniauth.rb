Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET_KEY'], 
            info_fields: "email, gender, first_name, last_name",
            callback_path: '/users/auth/facebook/callback'
            
end
