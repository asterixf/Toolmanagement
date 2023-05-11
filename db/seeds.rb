# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts("Seeding database...")
10.times do
  Tool.create(
    alias: Faker::Alphanumeric.alpha(number: 8),
    sap: Faker::Alphanumeric.alpha(number: 4),
    technology: Faker::ElectricalComponents.active,
    bu: "Damper",
    volume: Faker::Number.within(range: 8000..10000),
    segment: ["HV", "MV", "HV"].sample,
    customer: Faker::Company.name,
    capacity: 35,
    damaged: 0,
    blocked: 0,
    spares: 0,
    available: 100,
    plant: "cuautla",
    active: 35,
    location: "stored",
  )
  35.times do
    Cavity.create(
      tool: Tool.last,
      num: Cavity.where(tool: Tool.last).count + 1,
      status: "released",
      is_spare: false,
      created_by: "seed"
    )
      end
  end
  10.times do
    Tool.create(
      alias: Faker::Alphanumeric.alpha(number: 8),
      sap: Faker::Alphanumeric.alpha(number: 4),
      technology: Faker::ElectricalComponents.active,
      bu: "Steering",
      volume: Faker::Number.within(range: 8000..10000),
      segment: ["LV", "MV", "HV"].sample,
      customer: Faker::Company.name,
      capacity: 35,
      damaged: 0,
      blocked: 0,
      spares: 0,
      available: 100,
      plant: "cuautla",
      active: 35,
      location: "stored"
    )
    35.times do
      Cavity.create(
        tool: Tool.last,
        num: Cavity.where(tool: Tool.last).count + 1,
        status: "released",
        is_spare: false,
        created_by: "seed"
      )
    end
  end
    10.times do
      Tool.create(
        alias: Faker::Alphanumeric.alpha(number: 8),
        sap: Faker::Alphanumeric.alpha(number: 4),
        technology: Faker::ElectricalComponents.active,
        bu: "Low_Volume",
        volume: Faker::Number.within(range: 8000..10000),
        segment: ["HR", "MR", "HR"].sample,
        customer: Faker::Company.name,
        capacity: 35,
        damaged: 0,
        blocked: 0,
        spares: 0,
        available: 100,
        plant: "cuautla",
        active: 35,
        location: "stored",
      )
      35.times do
        Cavity.create(
          tool: Tool.last,
          num: Cavity.where(tool: Tool.last).count + 1,
          status: "released",
          is_spare: false,
          created_by: "seed"
        )
      end
  end
puts("Seeding complete!")
