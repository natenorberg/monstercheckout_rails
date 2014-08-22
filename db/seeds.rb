# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
nate = User.new
nate.name = 'Nate Norberg'
nate.email = 'natenorberg@gmail.com'
nate.password = 'password'
nate.password_confirmation = 'password'
nate.save()
nate.is_admin = true
nate.save()

seed_file = File.join(Rails.root, 'db', 'seed.yml')
config = YAML::load_file(seed_file)
Equipment.create(config["equipment"])