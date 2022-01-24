# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# You can remove the 'faker' gem if you don't want Decidim seeds.
# Decidim.seed!

require 'factory_bot_rails'
require 'decidim/faker/localized'
require 'decidim/core/test/factories'

smtp_label = 'GDL Label'
smtp_email = 'localhost'

organization = Decidim::Organization.create!(
  name: 'Guadalajara',
  smtp_settings: {
    from: "#{smtp_label} <#{smtp_email}>",
    from_email: smtp_email,
    from_label: smtp_label,
    username: ENV['SMTP_USERNAME'] || '',
    password: ENV['SMTP_PASSWORD'] || '',
    address: ENV['SMTP_ADDRESS'] || 'localhost',
    port: ENV['SMTP_PORT'] || '25'
  },
  host: 'guadalajara.fly.dev',
  external_domain_whitelist: ['guadalajara.fly.dev', 'decidim.org', 'github.com'],
  description: Decidim::Faker::Localized.wrapped('<p>', '</p>') do
    Decidim::Faker::Localized.sentence(word_count: 15)
  end,
  default_locale: Decidim.default_locale,
  available_locales: Decidim.available_locales,
  reference_prefix: Faker::Name.suffix,
  available_authorizations: Decidim.authorization_workflows.map(&:name),
  users_registration_mode: :enabled,
  tos_version: Time.current,
  badges_enabled: true,
  user_groups_enabled: true,
  send_welcome_notification: true,
  file_upload_settings: Decidim::OrganizationSettings.default(:upload)
)

admin = Decidim::User.find_or_initialize_by(email: 'admin@decidim.org')

admin.update!(
  name: Faker::Name.name,
  nickname: Faker::Twitter.unique.screen_name,
  password: 'changeme',
  password_confirmation: 'changeme',
  organization: organization,
  confirmed_at: Time.current,
  locale: I18n.default_locale,
  admin: true,
  tos_agreement: true,
  personal_url: Faker::Internet.url,
  about: Faker::Lorem.paragraph(sentence_count: 2),
  accepted_tos_version: organization.tos_version,
  admin_terms_accepted_at: Time.current
)

FactoryBot.create(:static_page, organization: organization, slug: 'terms-and-conditions')

user = Decidim::System::Admin.new(email: 'abdulachik@gmail.com', password: 'changeme', password_confirmation: 'changeme')
user.save!
