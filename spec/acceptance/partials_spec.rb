require 'spec_helper'

describe 'Grape::Jbuilder partials' do
  let(:app) { Class.new(Grape::API) }

  before :each do
    app.format :json
    app.formatter :json, Grape::Formatter::Jbuilder
    app.before do
      env['api.tilt.root'] = "#{File.dirname(__FILE__)}/../views"
    end
  end

  it 'proper render partials' do
    app.get('/home', jbuilder: 'project') do
      @author   = OpenStruct.new(author: 'LTe')
      @type     = OpenStruct.new(type: 'paper')
      @project  = OpenStruct.new(name: 'First', type: @type, author: @author)
    end

    pattern = {
      project: {
        name: 'First',
        info: {
          type: 'paper'
        },
        author: {
          author: 'LTe'
        }
      }
    }

    get('/home')
    expect(last_response.body).to match_json_expression(pattern)
    expect(last_response.body).to eq(
      "{\"project\":{\"name\":\"First\",\"info\":{\"type\":\"paper\"},\"author\":{\"author\":\"LTe\"}}}"
    )
  end
end
