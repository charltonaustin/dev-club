require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/tasks"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "returns http success" do
      post "/tasks", params: { name: "new name", completed: false }, as: :json
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT /update" do
    it "returns http success" do
      post "/tasks", params: { name: "old name", completed: false }, as: :json
      put "/tasks/1", params: { name: "new name", completed: true }, as: :json
      expect(response).to have_http_status(:success)
    end
  end

end
