#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS "USERS" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, 
				"name" TEXT,
				"phone" TEXT, 
				"datestamp" TEXT, 
				"barber" TEXT, 
				"color" TEXT)'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
  erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
		erb :contacts
end

post '/contacts' do
	@email = params[:email]
	@textarea = params[:textarea]
	
	hh = {:email => 'Введите имейл',
		:textarea => 'Введите сообщение'}

	hh.each do |key, value|
		if params[key] == ''
			@error = hh[key]
			return erb :contacts
		end
	end

	@title = "We've got your message"
	f = File.open './public/contacts.txt', 'a'
	f.write "textarea: #{@textarea}, email: #{@email}"
	f.close

	erb :message2
end

post '/visit' do
	
	@user_name = params[:user_name]
	@phone = params[:phone]
	@time = params[:time]
	@barber = params[:barber]
	@color = params[:color]

	hh = {:user_name => 'Введите имя', 
		:phone => 'Введите номер телефона', 
		:time => 'Введите время'
	}                                                

	hh.each do |key, value|
		#если параметр пуст
		if params[key] == ''
			#переменной error присвоить value из хеша hh
			#value из хеша hh это сообщение об ошибке
			# переменной error присвоить сообщение об ошибке
			@error = hh[key]
			return erb :visit
		end	
	end

	db = get_db	
	db.execute 'insert into Users (name, phone, 
	             datestamp, barber, color) values 
	             (?, ?, ?, ?, ?)', 
	             [@user_name, @phone, @time, @barber, @color]

	@title = "Thank you!"
	@message = "Dear #{@user_name}, we'll be waiting for you at #{@time}. Your barber is #{@barber}. #{@color}"
	f = File.open './public/users.txt', 'a'
	f.write "User's name #{@user_name}, phonenumber #{@phone}, time #{@time}."
	f.close
	erb :message

end

get '/showusers' do
	erb :showusers
end