require 'rails_helper'

describe ExampleApiClient, :vcr do
  describe "#list_todos" do
    it "responds with 200 status" do
      response = described_class.new.list_todos()

      expect(response.status).to eq(200)
      expect(response.body).to be_present
    end
  end

  describe "#get_todo" do
    it "responds with 200 status" do
      response = described_class.new.get_todo(123)

      expect(response.status).to eq(200)
      expect(response.body).to eq([ {
         "completed"=>false,
         "id"=>123,
         "title"=>"esse et quis iste est earum aut impedit",
         "userId"=>7
      } ])
    end
  end
end
