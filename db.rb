require 'pg'

DB = PG.connect({
  host: 'localhost',
  dbname: 'contacts',
  user: 'development',
  password: 'development'
})