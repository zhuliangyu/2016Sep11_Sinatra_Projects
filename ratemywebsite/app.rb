require "sinatra"
require "sinatra/reloader"
require "data_mapper"

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/rate.db")

class Task
  include DataMapper::Resource

  property :id, Serial # An auto-increment integer key
  property :name, Text # A varchar type string, for short strings
  property :email, String
  property :design, Integer
  property :content, Integer
  property :speed, Integer
  property :overall, Integer

end

DataMapper.auto_upgrade!

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'admin']
  end
end


get "/" do
  erb(:index,{layout: :layout})
end

post "/post" do
  Task.create(params)

  redirect to "/"



end

get "/show" do
  protected!
  @good=Task.all(:overall.gte => 3)
  @bad=Task.all(:overall.lt =>3)

  erb(:show,{layout: :layout})
  # exhibitions = Exhibition.all(:run_time.gt => 2, :run_time.lt => 5)
  # 2 # => SQL conditions: 'run_time > 2 AND run_time < 5'1 exhibitions = Exhibition.all(:run_time.gt => 2, :run_time.lt => 5)
  # 2 # => SQL conditions: 'run_time > 2 AND run_time < 5'



  #
  #
end