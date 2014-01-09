require 'spec_helper'

describe Grape::Jbuilder do
  let(:app) { Class.new(Grape::API) }

  before do
    app.format :json
    app.formatter :json, Grape::Formatter::Jbuilder
    app.helpers RSpec::Mocks::ExampleMethods
    app.before do
      env['api.tilt.root'] = "#{File.dirname(__FILE__)}/../views"
    end
  end

  it 'should work without jbuilder template' do
    app.get('/home') { 'Hello World' }

    get '/home'

    expect(last_response.body).to eq('"Hello World"')
  end

  it 'should respond with proper content-type' do
    app.get('/home', jbuilder: 'user') {
      @user    = double(name: 'Fred', email: 'fred@bloggs.com')
      @project = double(name: 'JBuilder')
    }

    get('/home')

    expect(last_response.headers['Content-Type']).to eq('application/json')
  end

  ['user', 'user.jbuilder'].each do |jbuilder_option|
    it 'should render jbuilder template (#{jbuilder_option})' do
      app.get('/home', jbuilder: jbuilder_option) do
        @user    = OpenStruct.new(name: 'LTe', email: 'email@example.com')
        @project = OpenStruct.new(name: 'First')
      end

      pattern = {
        user: {
          name: 'LTe',
          email: 'email@example.com',
          project: {
            name: 'First'
          }
        }
      }

      get '/home'
      expect(last_response.body).to match_json_expression(pattern)
    end
  end
end
