# spec/requests/tasks_spec.rb
require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    before do
      create_list(:task, 10)
    end

    it "returns all tasks" do
      get tasks_path

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).size).to eq(10)
    end
  end
end
