# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PolishMe.Repo.insert!(%PolishMe.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PolishMe.Repo
alias PolishMe.Accounts.User
alias PolishMe.Brands.Brand
alias PolishMe.Polishes.Polish

_alpha = %User{email: "alpha@test.com", is_admin: true} |> Repo.insert!()
_beta = %User{email: "beta@test.com"} |> Repo.insert!()

arcana =
  %Brand{
    name: "Arcana Lacquer",
    slug: "arcana-lacquer",
    description:
      "Arcana Lacquer is an indie nail polish brand started by two friends with a common interest - unique and beautiful nails! We are located in Baltimore, Maryland and work out of our home creating magical shades for everyone to enjoy.\n\nOur inspirations come from witchcraft, the occult, video games, books, movies, and music. We hope you find common interests with us and enjoy our polish creations!",
    website: "https://arcanalacquer.com/",
    contact_email: "arcanalacquer@gmail.com"
  }
  |> Repo.insert!()

colores_de_carol =
  %Brand{
    name: "Colores de Carol",
    slug: "colores-de-carol",
    website: "https://coloresdecarol.com/",
    contact_email: "coloresdecarol@gmail.com"
  }
  |> Repo.insert!()

cracked =
  %Brand{
    name: "Cracked",
    slug: "cracked",
    description:
      "Welcome to Cracked Polish, where creativity meets self-expression, and every nail becomes a canvas of artistry and joy.",
    website: "https://crackedpolish.com/",
    contact_email: "support@crackedpolish.com"
  }
  |> Repo.insert!()

dam =
  %Brand{
    name: "Dam",
    slug: "dam",
    description:
      "Dam Nail Polish is an indie nail polish brand that is run in an office turned nail polish lab in Fairfax, Virginia. The brand started in September 2014 with a vision of unique and awesome colors that you simply cannot find on shelves. Angie specializes in all sorts of special effect polishes from thermals to holographics to shimmers, magnetics, and reflectives. Our aim is to create polishes with a quick dry, super smooth formula.",
    website: "https://damnailpolish.com/",
    contact_email: "angie@damnailpolish.com"
  }
  |> Repo.insert!()

dimension =
  %Brand{
    name: "Dimension Nails",
    slug: "dimension-nails",
    description:
      "We aim to add new dimensions in the nail industry by incorporating health conscious 10+ free formulas, a love for animals through our products, and providing education about veganism with activism at the core.",
    website: "https://dimensionnails.com/",
    contact_email: "dimensionnails@hotmail.com"
  }
  |> Repo.insert!()

emily_de_molly =
  %Brand{
    name: "Emily de Molly",
    slug: "emily-de-molly",
    description:
      "Emily de Molly is an independent nail lacquer brand located in Canberra, Australia.\n\nEstablished in May 2012, we are dedicated to providing an amazing variety of colours and finishes at an affordable price. Our finishes include magnetics, reflective glitters, holographics, multichromes, thermals, shimmers, flakies and glitter polishes.\n\nWe also specialise in stamping plates and accessories.",
    website: "https://emilydemolly.com/",
    contact_email: "info@emilydemolly.com"
  }
  |> Repo.insert!()

lurid =
  %Brand{
    name: "Lurid Lacquer",
    slug: "lurid-lacquer",
    description:
      "I am a highly sensitive person in a world that denigrates sensitivity and confuses and conflates it with weakness. My sensitivity is my greatest strength as a human being and an artist and a writer. I knew that I wanted to address grief and trauma through my brand, and to create highly emotional content. I chose the name Lurid Lacquer because the idea of speaking openly, frankly, and unapologetically about emotion and mental health is considered to be in very poor taste in my community of origin. I also wanted to play on the secondary meaning of lurid: to be garishly or offensively bright. My creations are both things: scandalously emotional and offensively vibrant!",
    website: "https://luridlacquer.com/",
    contact_email: "customerservice@luridlacquer.com"
  }
  |> Repo.insert!()

lynb =
  %Brand{
    name: "LynB Designs",
    slug: "lynb-designs",
    description:
      "LynBDesigns was started as a hobby, and in 2012 we tried my hand at making nail polish. We make polish based on ours/your favorite movies, television shows, musicals, and even holidays. We use a unique perspective and a quirky sense of color to make polishes you won't find in your local stores.",
    website: "https://lynbdesigns.store/",
    contact_email: "lynbdesigns@yahoo.com"
  }
  |> Repo.insert!()

olive_ave =
  %Brand{
    name: "Olive Ave Polish",
    slug: "olive-ave-polish",
    description:
      "I created Olive Ave Polish to make nail care easy, joyful, and something you can feel good about. Our polish is non-toxic, cruelty-free, shipped in recycled packaging, and designed for effortless application. Because when you take time for yourself, you deserve products that reflect your values.",
    website: "https://oliveavepolish.com/",
    contact_email: "support@oliveavepolish.com"
  }
  |> Repo.insert!()

starrily =
  %Brand{
    name: "Starrily",
    slug: "starrily",
    description:
      "Choose from a kaleidoscope of highly pigmented, vegan, cruelty-free & 10-free hues, made in the USA. Because at the end of the day, your nails are the canvas, and you are the master artist, painting your unique style onto the world.",
    website: "https://starrily.com/",
    contact_email: "support@starrily.com"
  }
  |> Repo.insert!()

%Polish{
  name: "Shattered Remnants",
  slug: "shattered-remnants",
  description:
    "Shattered Remnants has a blueish-green jelly base with gold flakes and gold reflective glitter.",
  colors: [:green, :yellow],
  finishes: [:jelly, :flake, :glitter],
  brand: arcana
}
|> Repo.insert!()

%Polish{
  name: "Emissary of Inari",
  slug: "emissary-of-inari",
  description:
    "Emissary of Inari is a thermal polish that goes from red (cold) to light pink (warm) with a strong red to orange shimmer!",
  colors: [:purple, :pink, :red],
  finishes: [:thermal, :shimmer],
  brand: arcana
}
|> Repo.insert!()

%Polish{
  name: "Mushroom-Lit Cavern",
  slug: "mushroom-lit-cavern",
  description:
    "Mushroom-Lit Cavern is a thermal polish that goes from dark blue(cold) to light blue(warm) with a strong violet-blue shimmer. The shimmer alters the cold state to read more royal blue than pure black!",
  colors: [:blue],
  finishes: [:thermal, :shimmer],
  brand: arcana
}
|> Repo.insert!()
