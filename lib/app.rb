require 'sinatra/base'
require_relative './idea_box'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'

  configure :development do
    register Sinatra::Reloader
  end

  not_found do
    erb :error
  end

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all.sort, idea: Idea.new}
  end

  post '/' do
    IdeaStore.create(params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect back
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/users', "should redirect to user/:id TODO"  # needs to redirect to users/:id, currently going back to edit
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect back
  end

  get '/users' do
    erb :users_index, locals: {users: UserStore.all, user: User.new}
  end

  post '/users' do
    UserStore.create(User.new(params[:user]))
    redirect '/users'
  end

  get '/users/:id' do |id|
    user = UserStore.find(id.to_i)
    erb :user_show, locals: {user: user,
                            groups: GroupStore.find_all_by_user_id(id.to_i)}
    # write idea unit test for find_all_by_user_id
  end

  post '/users/:id' do |id|
    IdeaStore.create(params[:idea])
    redirect '/users/' + id
  end

  post '/users/:id/groups' do |id|
    GroupStore.create(Group.new(params[:group]))
    redirect '/users/' + id
  end

end
