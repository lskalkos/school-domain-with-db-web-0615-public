class Student
  attr_accessor :name, :tagline, :twitter, :github, :blog_url, :image_url, :biography, :id

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        tagline TEXT,
        twitter TEXT,
        github TEXT,
        blog_url TEXT,
        image_url TEXT,
        biography TEXT
      );
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL

    DB[:conn].execute(sql)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?;
    SQL

    row = DB[:conn].execute(sql, name).first

    new_from_db(row) if row
  end

  def self.new_from_db(row)
    Student.new.tap do |s|
      s.id = row[0]
      s.name = row[1]
      s.tagline = row[2]
      s.twitter = row[3]
      s.github = row[4]
      s.blog_url = row[5]
      s.image_url = row[6]
      s.biography = row[7]
    end
  end

  def insert
    sql = <<-SQL
      INSERT INTO students
      (name, tagline, twitter, github, blog_url, image_url, biography)
      VALUES (?, ?, ?, ?, ?, ?, ?);
    SQL

    DB[:conn].execute(sql, self.name, self.tagline, self.github, self.blog_url, self.image_url, self.biography)

    sql_last_row_id = <<-SQL
      SELECT last_insert_rowid() FROM students;
    SQL

    @id = DB[:conn].execute(sql_last_row_id).first.first
  end

  def update
    sql = <<-SQL
      UPDATE students
      SET name = ?, tagline = ?, twitter = ?, github = ?, blog_url = ?, image_url = ?, biography = ?
      WHERE id = ?;
    SQL

    DB[:conn].execute(sql, self.name, self.tagline, self.twitter, self.github, self.blog_url, self.image_url, self.biography, self.id)
  end

  def save
    persisted? ? update : insert
  end

  def persisted?
    self.id ? true : false
  end


end
