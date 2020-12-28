class SessionsController < ApplicationController
  def create
    client_id = '7021d177a4d68f042962'
    client_secret = 'd335ab566d666a3421aa440f5786ed6eafec890b'
    code = params[:code]

    conn = Faraday.new(url: 'https://github.com', headers: { 'Accept': 'application/json' })

    response = conn.post('/login/oauth/access_token') do |request|
      request.params['code'] = code
      request.params['client_id'] = client_id
      request.params['client_secret'] = client_secret
    end

    data = JSON.parse(response.body, symbolize_names: true)
    access_token = data[:access_token]

    conn = Faraday.new(
      url: 'https://api.github.com',
      headers: {
        'Authorization': "token #{access_token}"
      }
    )
    response = conn.get('/user')
    data = JSON.parse(response.body, symbolize_names: true)
  end
end
