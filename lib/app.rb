require 'sinatra/base'
require_relative './idea_box'
require 'omniauth-twitter'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'

  unless ENV['RACK_ENV'] == 'test'
    before // do
      OPEN_URLS = ['/login', '/auth/twitter/callback', '/', '/styles/*']
      pass if session[:admin] || OPEN_URLS.include?(request.path_info)
      redirect to('/login')
    end
  end

  helpers do
    def admin?
      session[:admin]
    end
  end

  configure do
    enable :sessions
  end

  use OmniAuth::Builder do
    provider :twitter, 'EZtMcMRXcYYswwqyNtfobw', 'i8knkHioADOmeAWGl1d1yhUQHANPY5lpgwCtcWWdeA'
  end

  get '/login' do
    redirect to("/auth/twitter")
  end

  get '/auth/twitter/callback' do
    env['omniauth.auth'] ? session[:admin] = true : halt(401,'Not Authorized')
    "Hi #{env['omniauth.auth']['info']['name']}"
    redirect to("/users")
  end

  get '/auth/failure' do
    params[:message]
  end

  get '/logout' do
    session[:admin] = nil
    "You are now logged out"
  end

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
    redirect '/users/' + @@current_user_id # really bad hack
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
    if params[:user]["email"].empty?
      session[:user] = "Please fill in an email"
      redirect back
    end
    UserStore.create(User.new(params[:user]))
    redirect '/users'
  end

  get '/users/:id' do |id|
    @@current_user_id = id
    user = UserStore.find(id.to_i)
    erb :user_show, locals: {user: user,
                            groups: GroupStore.find_all_by_user_id(id.to_i),
                            errors: []}
  end

  post '/users/:id' do |id|
    errors = []
    REQUIRED_PARAMS ||= ["title","description"]
    REQUIRED_PARAMS.each do |param|
      if params[:idea][param].empty?
        errors << "Please fill in #{param}"
      end
    end
    if errors.length > 0
      erb :user_show, locals: {user: UserStore.find(id.to_i),
                              groups: GroupStore.find_all_by_user_id(id.to_i),
                              errors: errors}
    else
      IdeaStore.create(params[:idea])
      redirect '/users/' + id
    end
  end

  post '/users/:id/groups' do |id|
    GroupStore.create(Group.new(params[:group]))
    redirect '/users/' + id
  end

  get '/tags/:tag' do |tag|
    erb :tag_show, locals: {tag: tag, ideas: IdeaStore.find_all_by_tag(tag)}
  end

end
