require 'spec_helper'

describe 'Grape::Jbuilder partials' do
  subject do
    Class.new(Grape::API)
  end

  before do
    subject.format :json
    subject.formatter :json, Grape::Formatter::Jbuilder
    subject.before { env['api.tilt.root'] = "#{File.dirname(__FILE__)}/views" }
  end

  def app
    subject
  end

  it 'proper render partials' do
    subject.get('/home', jbuilder: 'project') do
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
    last_response.body.should match_json_expression(pattern)
    last_response.body.should ==
      "{\"project\":{\"name\":\"First\",\"info\":{\"type\":\"paper\"},\"author\":{\"author\":\"LTe\"}}}"
  end
end
