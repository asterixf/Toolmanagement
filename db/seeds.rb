# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts("Seeding database...")
50.times do
  Tool.create(
    alias: Faker::Alphanumeric.alpha(number: 8),
    sap: Faker::Alphanumeric.alpha(number: 4),
    technology: Faker::ElectricalComponents.active,
    bu: ["Damper", "Steering", "Low_Volume"].sample,
    volume: Faker::Number.within(range: 8000..10000),
    segment: ["HR", "MR", "HR"].sample,
    customer: Faker::Company.name,
    capacity: Faker::Number.within(range: 17...85),
    damaged: 0,
    blocked: 0,
    spares: 0,
    available: 0,
    plant: "cuautla",
    active: 0,
    location: "stored"
  )
end
puts("Seeding complete!")
