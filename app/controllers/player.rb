SamplePokerBot.controllers :seating do
  # get :index, :map => "/foo/bar" do
  #   session[:foo] = "bar"
  #   render 'index'
  # end

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get "/example" do
  #   "Hello world!"
  # end

  get "/ready" do
    status 200
    "Always!"
  end

  post "/seat" do
    table = JSON.parse(params[:table])
    logger.info "Joining table #{table.inspect}"

    status 200
    "Ready!"
  end
end