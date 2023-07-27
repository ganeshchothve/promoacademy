require 'rails_helper'

RSpec.describe "Api::CoursesController", type: :request do

  let(:course) { create(:course) }
  let(:tutor) { create(:tutor, { course: course, email: 'email1@em.em' }) }
  let(:tutor2) { create(:tutor, { course: course, phone: '8390341970' }) }

  describe '#index' do
  
    def get_all_courses
      get "/api/courses"
    end

    context "should return courses" do
      it 'should return all courses' do
        course
        tutor
        tutor2
        get_all_courses
        response_body = JSON.parse(response.body)
        expect(response.code).to eq('200')
        expect(response_body.count).to eq(1)
        expect(response_body[0]['tutors'].count).to eq(2)
      end
    end
  
    context "when there are courses with tutors" do
      it "returns a list of courses with tutors" do
        course1 = Course.create(name: "Course 1")
        tutor1 = course1.tutors.create(name: "Tutor 1", email: "tutor1@example.com", phone: "1234567890")

        course2 = Course.create(name: "Course 2")
        tutor2 = course2.tutors.create(name: "Tutor 2", email: "tutor2@example.com", phone: "9876543210")

        get_all_courses
      
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(2)
        
        expect(json_response[0]['name']).to eq(course1.name)
        expect(json_response[0]['tutors'].length).to eq(1)
        expect(json_response[0]['tutors'][0]['name']).to eq(tutor1.name)
        expect(json_response[0]['tutors'][0]['email']).to eq(tutor1.email)
        expect(json_response[0]['tutors'][0]['phone']).to eq(tutor1.phone)

        # Course 2
        expect(json_response[1]['name']).to eq(course2.name)
        expect(json_response[1]['tutors'].length).to eq(1)
        expect(json_response[1]['tutors'][0]['name']).to eq(tutor2.name)
        expect(json_response[1]['tutors'][0]['email']).to eq(tutor2.email)
        expect(json_response[1]['tutors'][0]['phone']).to eq(tutor2.phone)
      end
    end

    context "when there are no courses" do
      it "returns an empty list" do
        get_all_courses
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_empty
      end
    end
  end

  describe '#create' do

    def create_course(params)
      post "/api/courses", params: params
    end

    context 'when params are valid' do
      let(:params) do 
      { 
        course: { 
                name: 'Course 1', 
                tutors_attributes: 
                  [
                    { 
                      name: 'Tutor 1',
                      email: 'email@e1.com'
                    }, 
                    { 
                      name: 'Tutor 2',
                      phone: '823424234'
                    }
                  ]
                } 
      }
      end
      
      it 'should create a course' do
        create_course params
        expect(Course.count).to eq(1)
      end

      it 'should create tutors for the course' do
        create_course params
        expect(Tutor.count).to eq(2)
      end

      it 'should return a success message' do
        create_course params
        response_body = JSON.parse(response.body)
        expect(response.code).to eq('201')
        expect(response_body.keys).to eq(["id", "name", "created_at", "updated_at"])
      end
    end

    context 'when params are invalid' do
      let(:params) do 
        { 
          course: { 
                  name: ''
          }
        }
      end
      
      it 'should not create a course' do
        create_course params
        expect(Course.count).to eq(0)
      end

      it 'should return an error message' do
        create_course params
        response_body = JSON.parse(response.body)
        expect(response.code).to eq('422')
        expect(response_body['errors']).to eq(["Name can't be blank"])
      end
    end

    context 'when tutor name is blank' do
      let(:params) do 
        { 
          course: { 
                  title: 'Course 1', 
                  tutors_attributes: 
                    [
                      { 
                        name: nil
                      }
                    ] 
                  }
        }
      end

      it 'response code should be 422' do
        create_course params
        expect(response.code).to eq('422')
      end
    end

    context "when email or phone already exists" do

      it "should return an error message" do
        course_params = { name: 'Course 1', tutors_attributes: [{ name: "New Tutor", email: "newtutor@example.com", phone: "1112223333" }] }

        create_course({course: course_params })

        expect(response).to have_http_status(201)

        course_params = { name: 'Course 2', tutors_attributes: [{ name: "New Tuto2r", email: "newtutor@examsple.com", phone: "1112223333" }] }

        create_course({course: course_params })

        expect(response).to have_http_status(422)

        json_response = JSON.parse(response.body)

        expect(json_response['errors']).to include("Tutors phone has already been taken")
      end
    end
  end
end
