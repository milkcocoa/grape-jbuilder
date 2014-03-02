require 'spec_helper'

describe Grape::Jbuilder do
  let(:app) { Class.new(Grape::API) }

  before do
    app.format :json
    app.formatter :json, Grape::Formatter::Jbuilder
    app.before do
      env['api.tilt.root'] = "#{File.dirname(__FILE__)}/../views"
    end
  end

  it 'should work without jbuilder template' do
    app.get('/home') { 'Hello World' }

    get '/home'

    expect(last_response.body).to eq('"Hello World"')
  end

  it 'should work with dynamically set templates' do
    app.get('/home') { env['api.tilt.template'] = 'test' }

    get '/home'

    expect(last_response.body).to eq({'foo' => 'bar'}.to_json)
  end

  it 'should respond with proper content-type' do
    app.get('/home', jbuilder: 'user') do
      @user    = OpenStruct.new(name: 'LTe', email: 'email@example.com')
      @project = OpenStruct.new(name: 'First')
    end

    get('/home')

    expect(last_response.headers['Content-Type']).to eq('application/json')
  end

  it "renders the template's content" do
    app.get('/home', jbuilder: 'user') do
      @user    = OpenStruct.new(name: 'LTe', email: 'email@example.com')
      @project = OpenStruct.new(name: 'First')
    end

    get('/home')

    pattern = {
      user: {
        name: 'LTe',
        email: 'email@example.com',
        project: {
          name: 'First'
        }
      }
    }
    expect(last_response.body).to match_json_expression(pattern)
  end
end
