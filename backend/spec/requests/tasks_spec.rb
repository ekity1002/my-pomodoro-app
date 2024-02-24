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
      expect(JSON.parse(response.body)["status"]).to eq("incomplete")
    end
  end

  describe "POST /tasks" do
    it "creates a new Task" do
      valid_attributes = { title: "New Task", description: "This is a new task.", due_date: Date.today.strftime("%Y-%m-%d")}
      expect {
        post tasks_path, params: {task: valid_attributes}
      }.to change(Task, :count).by(1)

      expect(response).to have_http_status(201)
      task = Task.last
      expect(task.title).to eq("New Task")
      expect(task.description).to eq("This is a new task.")
      expect(task.due_date).to eq(Date.today)
      expect(task.incomplete?).to eq(true)
    end

    context "with invalid parameters" do
      it "does not create a new Task when it has not title" do
        invalid_attributes = { description: "no title."}
        expect {
          post tasks_path, params: {task: invalid_attributes}
        }.to change(Task, :count).by(0)

        expect(response).to have_http_status(422) # Unprocessable Entity
        expect(JSON.parse(response.body)).to include("title" => ["can't be blank"])
      end
      it "does not create a new Task when due_date is past" do
        invalid_attributes = { title: "past due date Task", description: "past due date", due_date: "1991-10-02" }
        expect {
          post tasks_path, params: {task: invalid_attributes}
        }.to change(Task, :count).by(0)

        expect(response).to have_http_status(422) # Unprocessable Entity
        expect(JSON.parse(response.body)).to include("due_date" => ["cant't be in the past"])
      end
    end
  end

  describe "PUT /tasks/:id" do
    it "updates the requestd task" do
      task = FactoryBot.create(:task)
      valid_attributes = { title: "Updated Task", description: "This is a updated task.", due_date: Date.today.strftime("%Y-%m-%d"), status: "complete"}
      put task_path(task), params: {task: valid_attributes}

      task.reload # データベースから再度読み込み
      expect(response).to have_http_status(200)
      expect(task.title).to eq("Updated Task")
      expect(task.description).to eq("This is a updated task.")
      expect(task.due_date).to eq(Date.today)
      expect(task.complete?).to eq(true)
    end

    context "with invalid parameters" do
      it "does not update a task when due_date is past" do
        task = FactoryBot.create(:task)
        invalid_attributes = { title: "Updated Task", description: "This is a updated task.", due_date: "1991-12-31"}
        put task_path(task), params: {task: invalid_attributes}

        task.reload # データベースから再度読み込み
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to include("due_date" => ["cant't be in the past"])
      end
    end
  end

  describe "DELETE /tasks/:id" do
    it "deletes the task" do
      task = FactoryBot.create(:task)
      expect {
        delete task_path(task)
      }.to change(Task, :count).by(-1) # タスクの総数が1減少することを確認

      expect(response).to have_http_status(204) # No Content

    end
  end
end
