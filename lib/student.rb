class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
     SELECT *
     FROM students
     SQL

     DB[:conn].execute(sql).map do |row|
       self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
     SELECT *
     FROM students
     WHERE name = ?
     LIMIT 1
     SQL

     DB[:conn].execute(sql, name).map do |row|
       self.new_from_db(row)
     end.first
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9()
    sql = <<-SQL
     SELECT *
     FROM students
     WHERE grade = 9
     SQL

     DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade()
    sql = <<-SQL
     SELECT *
     FROM students
     WHERE grade < 12
     SQL

     puts below_12_students = DB[:conn].execute(sql)
    #  array << self.new_from_db(below_12_students)
    #  puts array

  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
     SELECT *
     FROM students
     WHERE grade = 10
     LIMIT #{num}
     SQL

     DB[:conn].execute(sql)
  end

  def self.first_student_in_grade_10()
    sql = <<-SQL
     SELECT *
     FROM students
     WHERE grade = 10
     LIMIT 1
     SQL

      student10 = DB[:conn].execute(sql)
      new_stud_10 = self.new_from_db(student10[0])
      new_stud_10
  end


  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
     SELECT *
     FROM students
     WHERE grade = #{grade}
     SQL

     DB[:conn].execute(sql)
  end
end
