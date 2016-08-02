require_relative 'db'
require 'pry'

class Contact

  attr_accessor :name, :email
  attr_reader :id

  def initialize(params={})
    @id = params[:id]
    @name = params[:name]
    @email = params[:email]
  end

  class << self

    def all
      DB.exec("SELECT * from contacts ORDER BY id ASC;").map {|contact| instance_from_row(contact)}
    end

    def create(name, email)
      contact = Contact.new(name: name, email: email)
      contact.save 
    end
    
    def find(id)
      result = DB.exec_params("SELECT * FROM contacts WHERE id = $1;", [id])
      return nil if result.values.empty?
      instance_from_row(result.first)
    end
    
    def search(term)
      result = DB.exec_params("SELECT * FROM contacts WHERE name ILIKE $1 OR email ILIKE $1;", ["%#{term}%"])
      return [] if result.values.empty?
      result.map {|contact| instance_from_row(contact)}
    end

    def instance_from_row(row)
      Contact.new({
        id: row['id'].to_i,
        name: row['name'],
        email: row['email']
      })
    end

  end

  def save
    if saved?
      DB.exec_params("UPDATE contacts SET name = $1, email = $2 WHERE id = $3;", [@name, @email, @id])
    else
      result = DB.exec_params("INSERT INTO contacts (name, email) VALUES ($1, $2) RETURNING id;", 
      [@name, @email])
      @id = result[0]['id'].to_i
    end
  end

  def saved?
      !@id.nil?
  end 

  def destroy
    DB.exec_params("DELETE FROM contacts WHERE id = $1;", [@id])
  end 

end


