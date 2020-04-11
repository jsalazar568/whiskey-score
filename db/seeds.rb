# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

jack = WhiskeyBrand.create_or_find_by({ name: 'Jack Daniel' })
johnnie = WhiskeyBrand.create_or_find_by({ name: 'Johnnie Walker' })
chivas = WhiskeyBrand.create_or_find_by({ name: 'Chivas Regal' })

jack1 = Whiskey.create_or_find_by({label: 'Old No. 7', whiskey_brand: jack})
jack2 = Whiskey.create_or_find_by(label: 'Gentleman Jack', whiskey_brand: jack)
jack3 = Whiskey.create_or_find_by(label: 'Single Barrel', whiskey_brand: jack)
johnnie1 = Whiskey.create_or_find_by(label: 'Red Label', whiskey_brand: johnnie)
johnnie2 = Whiskey.create_or_find_by(label: 'Black Label', whiskey_brand: johnnie)
johnnie3 = Whiskey.create_or_find_by(label: 'Blue Label', whiskey_brand: johnnie)
chivas1 = Whiskey.create_or_find_by(label: 'Chivas Regal 12', whiskey_brand: chivas)
chivas2 = Whiskey.create_or_find_by(label: 'Chivas Regal Extra', whiskey_brand: chivas)
chivas3 = Whiskey.create_or_find_by(label: 'Chivas Regal 18', whiskey_brand: chivas)
chivas4 = Whiskey.create_or_find_by(label: 'Chivas Regal 25', whiskey_brand: chivas)

user = User.create_or_find_by({email: 'johanna@mail.com'}) do |user|
  user.name = 'Joha'
end

Review.create_or_find_by({
                             whiskey: jack1,
                             user: user,
                             title: 'The movies one',
                             description: 'The one that is selled in cans in the supermarket!',
                             taste_grade: 3
                         })
Review.create_or_find_by({
                             whiskey: johnnie3,
                             user: user,
                             title: 'The one with pretty bottles',
                             description: 'Famous in Venezuela',
                             taste_grade: 4,
                             color_grade: 4
                         })


