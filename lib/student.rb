class Student


  attr_accessor :name,:grade
  attr_reader :id

  def initialize(name,grade,id=nil)
    @name = name
    @grade = grade
    @id = id
  end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def self.create_table
    sql =  <<-SQL
    CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade TEXT
    )
    SQL
    #creates table students, if it does not already exist, with these columns.
    DB[:conn].execute(sql)
    #for the DB hash defined in environment.rb executes the varialbe sql, which includes the sql statement
  end

  def self.drop_table #save method
    sql = <<-SQL
      DROP TABLE students
    SQL
    #inserts into table students
    DB[:conn].execute(sql)
  end

  def save #save method
    sql = <<-SQL #this allows us to write sql statements over many lines
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    #inserts into table students
    DB[:conn].execute(sql, self.name, self.grade)
    #for DB hash defined in environment.rb, executes the variable sql, which inclues the INSERT statement, and creates elements name and grade
    sql = "SELECT last_insert_rowid() FROM students" #doesn't need the <<-SQL as it is short.  command last_insert_rowid() returns the id
    @id = DB[:conn].execute(sql)[0][0] #sets the instance object variable id to the id created in the db, returned by sql statement, and set in the variable id
    #could be refactored to @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:) #metaprogramming.  can come in any order
    student = Student.new(name, grade) #creats the new instance of Student
    student.save #sets the new student to the db and recalls the ID
    student #returns the student
  end


#End of the Class.  Do not pass
end
