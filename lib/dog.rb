require 'pry'

class Dog

  attr_accessor :name, :breed
  attr_reader :id

  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE dogs"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = "INSERT INTO dogs (name, breed) VALUES (?, ?)"
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
    self
  end

  def self.create(name:, breed:)
    self.new(name: name, breed: breed).tap { |s| s.save }
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM dogs WHERE id = ?"
    d = DB[:conn].execute(sql, id)[0]
    self.new(id: d[0], name: d[1], breed: d[2])
  end

  def self.find_or_create_by(name:, breed:)


  end

end #class Dog
