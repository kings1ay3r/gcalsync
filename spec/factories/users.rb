FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password { "password" }
    google_access_token { "fake_access_token" }
    google_refresh_token { "fake_refresh_token" }
    last_signed_in_at { Time.now }
  end
end
