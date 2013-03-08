json.project do
  json.(@project, :name)

  json.info do
	json.partial! 'partial', type: @type
  end

  json.author(@author, :author)
end
