require "rails_helper"

describe "Partners API Requests", type: :request do
  describe "POST /api/v1/add_partners" do
    context "with valid API key" do
      context "when given valid parameters" do
        it "creates a new user record" do
          expect { valid_add_partner_creation_request }
            .to change { User.count }
            .from(0)
            .to(1)
        end
        it "doesn't creates a new user if it exists" do
          FactoryBot.create(:user, email: "test@example.com")
          expect { valid_add_partner_creation_request }
            .to_not change { User.count }
        end
      end
    end

    context "with invalid API key" do
      it "responds with forbidden" do
        expect do
          post api_v1_add_partners_path(
            partner: {
              email: "test@example.com",
              diaper_partner_id: "diaper-partner-id"
            }
          ), headers: { 'X-Api-Key': "INVALID" }
        end.to_not change { User.count }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "Environment variable not set" do
    it "responds with forbidden" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("DIAPER_KEY").and_return(nil)

      post api_v1_add_partners_path(
        partner: {
          email: "test@example.com",
          diaper_partner_id: "diaper-partner-id"
        }
      ), headers: { 'X-Api-Key': nil }

      expect(response).to have_http_status(:forbidden)
    end
  end

  def valid_add_partner_creation_request(
    email: "test@example.com",
    diaper_partner_id: "diaper-partner-id"
  )
    post api_v1_add_partners_path(
      partner: {
        email: email,
        diaper_partner_id: diaper_partner_id
      }
    ), headers: { 'X-Api-Key': ENV["DIAPER_KEY"] }
  end
end
