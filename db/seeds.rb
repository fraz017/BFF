# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(email: "admin@bff.com", password: "bffadmin", password_confirmation: "bffadmin", role: :admin, complete_profile: true)
AvailableCategory.create(name: "entertainment", color: "#ccc", icon: "fa fa-entertainment")
AvailableCategory.create(name: "food", color: "#ccc", icon: "fa fa-food")
AvailableCategory.create(name: "shopping", color: "#ccc", icon: "fa fa-shopping")
AvailableCategory.create(name: "fashion_and_beauty", color: "#ccc", icon: "fa fa-fashion_and_beauty")
AvailableCategory.create(name: "fitness_and_health", color: "#ccc", icon: "fa fa-fitness_and_health")
AvailableCategory.create(name: "travel", color: "#ccc", icon: "fa fa-travel")
AvailableCategory.create(name: "sports", color: "#ccc", icon: "fa fa-sports")
AvailableCategory.create(name: "electronics", color: "#ccc", icon: "fa fa-electronics")
AvailableCategory.create(name: "education", color: "#ccc", icon: "fa fa-education")
AvailableCategory.create(name: "romance", color: "#ccc", icon: "fa fa-romance")
AvailableCategory.create(name: "others", color: "#ccc", icon: "fa fa-others")