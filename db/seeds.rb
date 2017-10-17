# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# User.create(email: "admin@bff.com", password: "bffadmin", password_confirmation: "bffadmin", role: :admin, complete_profile: true)
AvailableCategory.create(name: "entertainment", color: "#CD5C5C", icon: "fa fa-music")
AvailableCategory.create(name: "food", color: "#8B0000", icon: "fa fa-coffee")
AvailableCategory.create(name: "shopping", color: "#32CD32", icon: "fa fa-shopping-basket")
AvailableCategory.create(name: "fashion_and_beauty", color: "#FF1493", icon: "fa fa-female")
AvailableCategory.create(name: "fitness_and_health", color: "#FF6347", icon: "fa fa-bicycle")
AvailableCategory.create(name: "travel", color: "#FFD700", icon: "fa fa-car")
AvailableCategory.create(name: "sports", color: "#F0E68C", icon: "fa fa-futbol-o")
AvailableCategory.create(name: "electronics", color: "#EE82EE", icon: "fa fa-exclamation-triangle")
AvailableCategory.create(name: "education", color: "#800080", icon: "fa fa-book")
AvailableCategory.create(name: "romance", color: "#90EE90", icon: "fa fa-heartbeat")
AvailableCategory.create(name: "others", color: "#556B2F", icon: "fa fa-tags")