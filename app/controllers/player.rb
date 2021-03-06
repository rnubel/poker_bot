SamplePokerBot.controllers :player do
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

  # Return 200 if you're ready to start the game.
  get "/ready" do
    status 200
    "Always!"
  end

  # Return 200 if you accept your seat at the table.
  # This is a good time to update or clear your game state.
  post "/seat" do
    logger.info "Joining table #{params[:game_table_identifier].inspect}"

    status 200
    "Ready!"
  end

  # Get your bot's action for the next turn.
  # Data passed in:
  # {
  #   :minimum_bet => 20,
  #   :your_chips => 100,
  #   :your_cards => [
  #     {:suit => "C", :value => "9" },
  #     {:suit => "S", :value => "9" }
  #   ],
  #   :community_cards => [
  #     {:suit => "H", :value => "9" },
  #     {:suit => "C", :value => "8" },
  #     {:suit => "D", :value => "9" }
  #   ] 
  # }
  #
  # Return 200 and your action in the format:
  # {
  #   :action => "bet",
  #   :amount => 25
  # }
  # A 400-level error or no response will indicate a fold.
  post "/action" do
    logger.info "Deciding action for #{params.inspect}"

    content_type :json

    if params[:blind] == "true"
      status 200
      action = { :action => "blind", :amount => params[:minimum_bet] }.to_json
    elsif params[:your_chips].to_i > params[:minimum_bet].to_i
      status 200
      amount = params[:minimum_bet].to_i

      # Randomly raise a bit. Maybe.
      raise_amount = rand(20) < 2 ? 1 : 0
      if amount + raise_amount < params[:your_chips].to_i
        amount += raise_amount
      end
      
      action = { :action => "bet", :amount => amount }.to_json
    else
      status 403
      action = { :action => "fold"}.to_json
    end

    logger.info "Decided on #{action.inspect}."
    body action
  end
end
