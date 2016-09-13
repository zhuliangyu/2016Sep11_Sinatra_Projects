require "sinatra"
# require "sinatra/reloader"
require "data_mapper"

enable :sessions

# database name: todolist
# table name: todo
# DataMapper.setup(:default, "sqlite://#{Dir.pwd}/todolist.db")
DataMapper.setup(:default, 'postgres://zhuliangyu:UIUCuiuc27@127.0.0.1/todolist')

class Task
  include DataMapper::Resource

  property :id, Serial # An auto-increment integer key
  property :name, Text # A varchar type string, for short strings
  property :flag, Integer, :default => 0 #flag for completed or uncompleted task. After adding a new task, default value is 0, which means a uncompleted task


end

# DataMapper.auto_upgrade!
DataMapper.auto_upgrade!


#show all tasks
get "/" do
  # uncompleted tasks
  @tasks_uncompleted=Task.all(:flag => 0)
  # completed tasks
  @tasks_completed=Task.all(:flag => 1)

  erb(:task, {layout: :layout})
end

#post to add an item into database
post "/" do

  Task.create(params)
  @tasks_uncompleted=Task.all(:flag => 0)
  @tasks_completed=Task.all(:flag => 1)


  erb(:task, {layout: :layout})

  # redirect to homepage
  redirect to "/"

end

# change tasks status from completed to uncompleted or vice versa
get "/change/:id" do |id|
  task=Task.get(id)
  #why it is not working?
  # task.update(:flag =>0)if task.flag==1
  # task.update(:flag =>1)if task.flag==0
  if task.flag==0
    task.update(:flag => 1)
  else
    task.update(:flag => 0)
  end

  redirect to "/"


end

# delete the completed tasks
get "/del/:id" do |id|
  task=Task.get(id)
  #why it is not working?
  # task.update(:flag =>0)if task.flag==1
  # task.update(:flag =>1)if task.flag==0
  task.destroy

  redirect to "/"


end

get "/color/:color" do |color|
  session[:color]=color
  redirect to "/"

end

get "/test" do
  "test"
end
