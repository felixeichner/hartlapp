User.create!(name: 										"Felix Eichner",
						 email: 									"eichner.f@googlemail.com",
						 password: 								"111111",
						 password_confirmation: 	"111111",
						 admin: 									true,
						 activated: 							true,
						 activated_at: 						Time.zone.now)

99.times do |n|
	name = 															Faker::Name.name
	email = 														"example#{n+1}@mail.com"
	password = 													"111111"
	User.create!(name: 									name,
							 email: 								email,
							 password: 							password,
							 password_confirmation: password,
							 activated: 						true,
							 activated_at: 					Time.zone.now)
end