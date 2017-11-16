get '/api/monsters' do
	Monster.all.to_json
end

get '/api/monsters/:id' do
	Monster.show(params[:id]).to_json
end

get '/api/monsters/search/:term' do
	Monster.search(params[:term]).to_json
end