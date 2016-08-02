require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def menu
  puts "Here is a list of available commands:
  \tnew - Create a new contact
  \tlist - List all ContactList
  \tshow - Show a contact
  \tsearch - Search contacts 
  \tupdate - Update contact
  \tdelete- Delete contact"
  end 

  def launch_app 
    case ARGV[0]
    when "list" 
      Contact.all.each do |contact| 
      puts "#{contact.id}: #{contact.name} -- #{contact.email}"
      end 
    when "new"
      puts "Full name: "
      name = STDIN.gets.chomp
      puts "E-mail: "
      email = STDIN.gets.chomp
      if Contact.all.any? {|contact| contact.email = email}
        puts "Sorry, contact with the email #{email} already exists!"
      else
        puts Contact.create(name,email)
        puts "Contact was created successfully."
      end
    when "show"
      id = ARGV[1]
      if Contact.find(id) == nil
        puts "Sorry, contact not found."
      else 
        puts "#{Contact.find(id).id}: #{Contact.find(id).name} -- #{Contact.find(id).email}"
      end
    when "search"
      search_term = ARGV[1] 
      if Contact.search(search_term) == []
        puts "Sorry, no contact found."
      else 
        # Contact.search(search_term)
        Contact.search(search_term).each do |contact|
        puts "#{contact.id}: #{contact.name} -- #{contact.email}"
        end
      end 
    when "update"
      id = ARGV[1]
      if Contact.find(id) == nil
        puts "Unable to update-- contact does not exist."
      else
        contact = Contact.find(id)
        puts "What would you like to change the name to?"
        new_name = STDIN.gets.chomp
        contact.name = new_name
        puts "What would you like the change the e-mail to?"
        new_email = STDIN.gets.chomp
        contact.email = new_email 
        contact.save
      end
    when "delete"
      id = ARGV[1]
      if Contact.find(id) == nil 
        puts "No contact deleted-- contact does not exist."
      else 
        contact = Contact.find(id)
        puts "#{contact.name} has been successfully deleted."
        contact.destroy
      end
    else
      self.menu
    end
  end 

end

ContactList.new.launch_app