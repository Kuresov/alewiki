#Create seed data for users and wiki entries.

3.times do
  user = User.create!(
    name:     Faker::Name.name,
    email:    Faker::Internet.email,
    password: Faker::Lorem.characters(10)
  )
  user.skip_confirmation!
  user.save!
end

users = User.all

15.times do
  users.sample.wikis.create!(
    title:   Faker::Lorem.sentence(4),
    body:    Faker::Lorem.paragraph(4),
    private: [true, false].sample
  )
end

wikis = Wiki.all

puts "Seed Finished"
puts "#{users.count} users present"
puts "#{wikis.count} wikis present"
