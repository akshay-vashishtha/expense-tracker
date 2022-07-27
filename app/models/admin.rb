class Admin < ApplicationRecord
    has_secure_password
    validates :password_digest, length: { minimum: 3 }
end
