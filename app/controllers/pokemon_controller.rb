class PokemonController < ApplicationController

  def index
    key = ENV["GIPHY_KEY"]

    pokemon_response = HTTParty.get("https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json")
    pokemon_body = JSON.parse(pokemon_response.body)

    @pokemon_id           = pokemon_body["pokemon"][0]["id"]
    @pokemon_name         = pokemon_body["pokemon"][0]["name"]
    @pokemon_type         = pokemon_body["pokemon"][0]["type"]
    @pokemon_height       = pokemon_body["pokemon"][0]["height"]
    @pokemon_weight       = pokemon_body["pokemon"][0]["weight"]
    @pokemon_candy        = pokemon_body["pokemon"][0]["candy"]
    @pokemon_spawn_chance = pokemon_body["pokemon"][0]["spawn_chance"]
    @pokemon_avg_spawns   = pokemon_body["pokemon"][0]["avg_spawns"]
    @pokemon_spawn_time   = pokemon_body["pokemon"][0]["spawn_time"]
    @pokemon_multipliers  = pokemon_body["pokemon"][0]["multipliers"]
    @pokemon_weaknesses   = pokemon_body["pokemon"][0]["weaknesses"]


    gif_response = HTTParty.get("https://api.giphy.com/v1/gifs/search?api_key=#{key}&q=#{@pokemon_name}&rating=g")
    gif_body = JSON.parse(gif_response.body)

    @pokemon_gif = gif_body["data"][0]["images"]["original"]["url"]

  end

  def show
    key = ENV["GIPHY_KEY"]

    pokemon_response = HTTParty.get("https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json")
    pokemon_body = JSON.parse(pokemon_response.body)

    input = params[:id]


    pokemon_body["pokemon"].each do |pokemon|
      if input.to_i == pokemon["id"]
        @pokemon_id           = pokemon["id"]
        @pokemon_name         = pokemon["name"]
        @pokemon_type         = pokemon["type"]
        @pokemon_height       = pokemon["height"]
        @pokemon_weight       = pokemon["weight"]
        @pokemon_candy        = pokemon["candy"]
        @pokemon_spawn_chance = pokemon["spawn_chance"]
        @pokemon_avg_spawns   = pokemon["avg_spawns"]
        @pokemon_spawn_time   = pokemon["spawn_time"]
        @pokemon_multipliers  = pokemon["multipliers"]
        @pokemon_weaknesses   = pokemon["weaknesses"]
      elsif input.to_i == 0
        if input.capitalize == pokemon["name"]
          @pokemon_id           = pokemon["id"]
          @pokemon_name         = pokemon["name"]
          @pokemon_type         = pokemon["type"]
          @pokemon_height       = pokemon["height"]
          @pokemon_weight       = pokemon["weight"]
          @pokemon_candy        = pokemon["candy"]
          @pokemon_spawn_chance = pokemon["spawn_chance"]
          @pokemon_avg_spawns   = pokemon["avg_spawns"]
          @pokemon_spawn_time   = pokemon["spawn_time"]
          @pokemon_multipliers  = pokemon["multipliers"]
          @pokemon_weaknesses   = pokemon["weaknesses"]
        end
      else
        flash.now[:alert] = ['Cannot find Pokemon. Try again.']
        render :new
      end
    end



    gif_response = HTTParty.get("https://api.giphy.com/v1/gifs/search?api_key=#{ key }&q=#{ @pokemon_name }&rating=g")
    gif_body = JSON.parse(gif_response.body)

    @pokemon_gif = gif_body["data"][0]["images"]["original"]["url"]

    respond_to do |format|
      format.html { render :show }
      format.json {
        render json: {
          id:           @pokemon_id,
          name:         @pokemon_name,
          type:         @pokemon_type,
          height:       @pokemon_height,
          weight:       @pokemon_weight,
          candy:        @pokemon_candy,
          spawn_chance: @pokemon_spawn_chance,
          avg_spawns:   @pokemon_avg_spawns,
          spawn_time:   @pokemon_spawn_time,
          multipliers:  @pokemon_multipliers,
          weaknesses:   @pokemon_weaknesses,
          gif:          @pokemon_gif
           }
      }
    end

  end

  private

  def pokemon_params
    params.require(:pokemon).permit(:id, :name)
  end

end
