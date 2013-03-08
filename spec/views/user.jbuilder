json.user do
  json.(@user, :name, :email)

  json.project do
    json.(@project, :name)
  end
end
