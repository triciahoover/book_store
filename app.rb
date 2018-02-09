require 'sinatra'
require 'pg'
load './local_env.rb' if File.exist?('./local_env.rb')
enable :sessions

db_params = {
	host: ENV['dbhost'],
	port: ENV['port'],
	dbname: ENV['dbname'],
	user: ENV['dbuser'],
	password: ENV['password']
}

db = PG::Connection.new(db_params)

get '/' do
	erb :home
end

post '/search' do
	title = params[:title]
	book = db.exec("select * from book_table where title = '#{title}'")
	session[:book1] = book[0]
	session[:book2] = book[1]
	redirect '/results'
end

get '/results' do
	book1 = session[:book1]
	book2 = session[:book2]
	erb :results, :locals => {:book1 => book1, :book2 => book2}
end