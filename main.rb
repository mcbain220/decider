require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true

helpers do

# converts keys to weighting values

	def convert(value)
		converter = {1 => 5, 2 => 4, 3 => 3, 4 => 2, 5 => 1}
		value += 1
		converter[value]
	end

  def decider(final_score)
    decision = ["choice",0]
    final_score.each do |sub_array|
      if sub_array[1] > decision[1]
        decision.replace(sub_array)
      end
    end
    decision[0]
  end
end


get '/' do
	erb :home
end

# intial setup

post '/intro' do
  session[:name] = params[:name]
  # session[:topic] = params[:topic]
	session[:sorted_priorities] = {"1@Location"=>5,"2@Affordability"=>4, "3@Food"=>3,"4@Proximity"=>2, "5@Entertainment"=>1}
	session[:options] = {}
	redirect '/step_1'
end

# show priorities sorting page

get '/step_1' do
	erb :step_1
end

# adding options

get '/step_1a' do
	erb :step_1a
end

# submitting options

post '/step_1a/submit' do
	params.each do |key, val|
		session[:options][key.delete("option_").to_s] = val    # revisit changing this to a hash
	end
	
	redirect '/step_2'
end

# priority sorting handler

post '/step_1/sorted' do
	params[:id].each do | array |
		session[:sorted_priorities][array.to_s] = convert(params[:id].index(array))
	end
end

# setup initial 'prioritize' hash and show sorting page

get '/step_2' do
	i = 1
	session[:prioritized] = {}
	session[:sorted_priorities].each do
		session[:prioritized]["#{i}"] = ["1","2","3","4","5"]
		i +=1
	end
	erb :step_2
end

# sorted priorities handler

post '/step_2/sorted_options' do  # need to create the default hash key/value pairs.  format is "(priority)option" => [1,2,3,4,5]
	session[:prioritized].merge!(params)
end

# final calculation

get '/calculate' do
	session[:priority_weighting] = {}
	session[:sorted_priorities].each do | a, b |
		session[:priority_weighting][a.split("@")[0]] = b
	end

	session[:final_calc] = []
	session[:prioritized].each do | key, opt_array |
		opt_array.each do | option |
			# binding.pry
			a = convert(opt_array.index(option).to_i) * session[:priority_weighting][key]
			session[:final_calc] << [key, option, a]
		end
	end

	session[:final_calc].each do | component |
		session[:sorted_priorities].each_key do |key|
			if key[0] == component[0]
				component[0] = key.split("@")[1]
			end
		end
		component[1] = session[:options][component[1]]
	end

  session[:final_scores] = []

  session[:options].each do | key, value |
    key_score = 0
    session[:final_calc].each do |sub_array|
      if sub_array[1] == value
        key_score += sub_array[2]
      end
    end
    session[:final_scores] << [value, key_score]
  end

	erb :calculate
end









