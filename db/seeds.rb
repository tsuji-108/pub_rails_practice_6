# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Seed 100 TODO records (idempotent by name)
puts "Seeding 100 TODO records..."

ActiveRecord::Base.transaction do
  100.times do |i|
    idx = i + 1
    name = "Seed TODO #{idx.to_s.rjust(3, '0')}"

    Todo.find_or_create_by!(name: name) do |todo|
      todo.content = "This is the content for seed TODO ##{idx}."
      # Store completion state as string to match schema
      todo.is_completed = (idx % 5 == 0) ? "true" : "false"
    end
  end
end

count = Todo.where("name LIKE ?", "Seed TODO %").count
puts "Done. Seeded/ensured #{count} TODO records with 'Seed TODO' prefix."
