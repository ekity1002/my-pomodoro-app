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

  describe "GET /task" do
    it "returns task" do
      task = FactoryBot.create(:task, title: "Sample Task", description: "This is a sample task.")
      get task_path(task.id)

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["title"]).to eq("Sample Task")
      expect(JSON.parse(response.body)["description"]).to eq("This is a sample task.")
    end
  end

  describe "POST /tasks" do
    it "creates a new Task" do
      valid_attributes = { title: "New Task", description: "This is a new task.", due_date: "2023-12-31"}
      expect {
        post tasks_path, params: {task: valid_attributes}
      }.to change(Task, :count).by(1)

      expect(response).to have_http_status(201)
      task = Task.last
      expect(task.title).to eq("New Task")
      expect(task.description).to eq("This is a new task.")
      expect(task.due_date.to_s).to eq("2023-12-31")
    end

    context "with invalid parameters" do
      it "does not create a new Task" do
        invalid_attributes = { description: "no title.", due_date: "2023-12-31"}
        expect {
          post tasks_path, params: {task: invalid_attributes}
        }.to change(Task, :count).by(0)

        expect(response).to have_http_status(422) # Unprocessable Entity
        expect(JSON.parse(response.body)).to include("title" => ["can't be blank"])
      end
    end
  end

end
