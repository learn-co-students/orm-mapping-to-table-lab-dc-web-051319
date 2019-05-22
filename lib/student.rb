require 'sqlite3'
require_relative '../lib/student'

class Student
  DB = {:conn => SQLite3::Database.new("db/students.db")}

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name,:grade
  attr_reader :id

  def initialize(name, grade, id=1)
    @id = id
    @name = name
    @grade = grade

  end

  #creates a table if it does not exist already
  def self.create_table
    sql =  <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        grade TEXT
        );
        SQL
    DB[:conn].execute(sql) 
  end

  #drops the table
  def self.drop_table
    sql =  <<-SQL 
      DROP TABLE students;
      SQL
    DB[:conn].execute(sql) 
  end

  #saves an instance of the student class to the database
  def save
    sql = <<-SQL
      INSERT INTO students (id, name, grade) 
      VALUES (?, ?, ?);
    SQL
 
    DB[:conn].execute(sql, self.id, self.name, self.grade)
  end

  #saves an instance of song to database
  def self.create(name:, grade:)
    students = Student.new(name, grade)
    students.save
    students
  end

  
end
