namespace :fill do

    task :data => :environment do

		100.times do 
			fname = RandomWord.nouns.next
			lname = RandomWord.nouns.next
			email = "#{fname}.#{lname}@mail.com"
			notes = "#{RandomWord.nouns.next} #{RandomWord.adjs.next} #{RandomWord.nouns.next} #{RandomWord.adjs.next}"
			Person.create(first_name: fname.titleize, last_name: lname.titleize, email: email, notes: notes)
		end

    end

end