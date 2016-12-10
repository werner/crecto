require "spec"
require "../src/crecto"

class User < Crecto::Model
  schema "users" do
    field :name, String
    field :things, Int32
    field :stuff, Int32, virtual: true
    field :nope, Float64
    field :yep, Bool
    field :some_date, Time
    field :pageviews, Int64
    has_many :posts, Post, foreign_key: :user_id
    has_many :addresses, Address, foreign_key: :user_id
  end

  validate_required :name
end

class UserDifferentDefaults < Crecto::Model
  created_at_field "xyz"
  updated_at_field nil

  schema "users_different_defaults" do
    field :user_id, Int32, primary_key: true
    field :name, String
    has_many :things, Thing
  end

  validate_required :name
end

class UserLargeDefaults < Crecto::Model
  created_at_field nil
  updated_at_field nil

  schema "users_large_defaults" do
    field :id, Int64, primary_key: true
    field :name, String
  end
end

class UserRequired < Crecto::Model
  schema "users_required" do
    field :name, String
    field :age, Int32
    field :is_admin, Bool
  end

  validate_required :name
  validate_required [:age, :is_admin]
end

class UserFormat < Crecto::Model
  schema "users_required" do
    field :name, String
    field :age, Int32
    field :is_admin, Bool
  end

  validate_format :name, /[*a-zA-Z]/
end

class UserInclusion < Crecto::Model
  schema "users_required" do
    field :name, String
    field :age, Int32
    field :is_admin, Bool
  end

  validate_inclusion :name, ["bill", "ted"]
end

class UserExclusion < Crecto::Model
  schema "users_required" do
    field :name, String
    field :age, Int32
    field :is_admin, Bool
  end

  validate_exclusion :name, ["bill", "ted"]
end

class UserLength < Crecto::Model
  schema "users_required" do
    field :name, String
    field :age, Int32
    field :is_admin, Bool
  end

  validate_length :name, max: 5
end

class UserGenericValidation < Crecto::Model
  schema "user_generic" do
    field :id, Int32, primary_key: true
    field :password, String, virtual: true
    field :encrypted_password, String
  end

  validate "Password must exist", ->(user : UserGenericValidation) do
    return false if user.id.nil? || user.id == ""
    return true unless password = user.password
    !password.empty?
  end
end

class UserMultipleValidations < Crecto::Model
  schema "users" do
    field :first_name, String
    field :last_name, String
    field :rank, Int32
  end

  validates :first_name,
    length: {min: 3, max: 9}

  validates [:first_name, :last_name],
    presence: true,
    format: {pattern: /^[a-zA-Z]+$/},
    exclusion: {in: ["foo", "bar"]}

  validates :rank,
    inclusion: {in: 1..100}
end

class Address < Crecto::Model
  schema "addresses" do
    field :user_id, Int32
    belongs_to :user, User
  end
end

class Post < Crecto::Model
  schema "posts" do
    field :user_id, Int32
    belongs_to :user, User
  end
end

class Thing < Crecto::Model
  schema "things" do
    field :user_different_defaults_id, Int32
    belongs_to :user, User, foreign_key: :user_different_defaults_id
  end
end
