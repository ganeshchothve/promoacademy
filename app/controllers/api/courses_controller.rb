class Api::CoursesController < ApplicationController
  #before_action :authorize_api_request
  #Additional info not given in assignment for authentication (or) who can have access to this api
  skip_before_action :verify_authenticity_token, only: :create

  def index
    courses = Course.includes(:tutors)
    render json: courses, include: :tutors
  end

  def create
    course = Course.new(course_params)
    if course.save
      render json: course, status: :created
    else
      render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def course_params
    params.require(:course).permit(:name, tutors_attributes: [:name, :email, :phone])
  end
end
