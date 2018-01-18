User.create!(name: 										"Felix Google",
						 email: 									"eichner.f@googlemail.com",
						 password: 								"111111",
						 password_confirmation: 	"111111",
						 admin: 									true,
						 activated: 							true,
						 activated_at: 						Time.zone.now)

names = []
99.times do |n|
	names.push(Faker::Simpsons.character)
end
number = 1
names.uniq.each do |n|
	name = 															n
	email = 														"email_#{number}@mail.com"
	password = 													"111111"
	User.create!(name: 									name,
							 email: 								email,
							 password: 							password,
							 password_confirmation: password,
							 activated: 						true,
							 activated_at: 					Time.zone.now)
	number += 1
end

User.create!(name: 										"Felix GMX",
						 email: 									"feichner@gmx.net",
						 password: 								"111111",
						 password_confirmation: 	"111111",
						 admin: 									true,
						 activated: 							true,
						 activated_at: 						Time.zone.now)

User.create!(name: 										"Anna",
						 email: 									"anna@mail.com",
						 password: 								"111111",
						 password_confirmation: 	"111111",
						 admin: 									true,
						 activated: 							true,
						 activated_at: 						Time.zone.now)

User.create!(name: 										"Tom",
						 email: 									"tom@mail.com",
						 password: 								"111111",
						 password_confirmation: 	"111111",
						 admin: 									true,
						 activated: 							true,
						 activated_at: 						Time.zone.now)

contents = []
50.times do
	content = "a"*150
	until content.length < 141
		content = "#{Faker::Friends.quote} (by #{Faker::Friends.character})"
	end
	contents.push(content)
end
users = User.order(:created_at).take(9)
contents.each do |content|
	users.shuffle.first.microposts.create!(content: content)
end

users.each do |user|
	users2 = User.order(:created_at).take(10).shuffle
	rand(4..9).times do
		user2 = users2.pop
		user.follow(user2) unless user == user2
	end
end