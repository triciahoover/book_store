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
	session[:book] = book[0]
	redirect '/results'
end

get '/results' do
	book= session[:book]
	erb :results, :locals => {:book => book}
end