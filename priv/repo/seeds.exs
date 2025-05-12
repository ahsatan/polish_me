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
alias PolishMe.Stash.StashPolish

alpha = %User{email: "alpha@test.com", is_admin: true} |> Repo.insert!()
_beta = %User{email: "beta@test.com"} |> Repo.insert!()

arcana =
  %Brand{
    name: "Arcana Lacquer",
    slug: "arcana-lacquer",
    description:
      "Arcana Lacquer is an indie nail polish brand started by two friends with a common interest - unique and beautiful nails! We are located in Baltimore, Maryland and work out of our home creating magical shades for everyone to enjoy.\n\nOur inspirations come from witchcraft, the occult, video games, books, movies, and music. We hope you find common interests with us and enjoy our polish creations!",
    website: "https://arcanalacquer.com/",
    contact_email: "arcanalacquer@gmail.com",
    logo_url: "/uploads/brand/logo/arcana-lacquer.png"
  }
  |> Repo.insert!()

colores_de_carol =
  %Brand{
    name: "Colores de Carol",
    slug: "colores-de-carol",
    website: "https://coloresdecarol.com/",
    contact_email: "coloresdecarol@gmail.com",
    logo_url: "/uploads/brand/logo/colores-de-carol.jpg"
  }
  |> Repo.insert!()

cracked =
  %Brand{
    name: "Cracked",
    slug: "cracked",
    description:
      "Welcome to Cracked Polish, where creativity meets self-expression, and every nail becomes a canvas of artistry and joy.",
    website: "https://crackedpolish.com/",
    contact_email: "support@crackedpolish.com",
    logo_url: "/uploads/brand/logo/cracked.svg"
  }
  |> Repo.insert!()

dam =
  %Brand{
    name: "Dam",
    slug: "dam",
    description:
      "Dam Nail Polish is an indie nail polish brand that is run in an office turned nail polish lab in Fairfax, Virginia. The brand started in September 2014 with a vision of unique and awesome colors that you simply cannot find on shelves. Angie specializes in all sorts of special effect polishes from thermals to holographics to shimmers, magnetics, and reflectives. Our aim is to create polishes with a quick dry, super smooth formula.",
    website: "https://damnailpolish.com/",
    contact_email: "angie@damnailpolish.com",
    logo_url: "/uploads/brand/logo/dam.png"
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
    contact_email: "info@emilydemolly.com",
    logo_url: "/uploads/brand/logo/emily-de-molly.jpg"
  }
  |> Repo.insert!()

lurid =
  %Brand{
    name: "Lurid Lacquer",
    slug: "lurid-lacquer",
    description:
      "I am a highly sensitive person in a world that denigrates sensitivity and confuses and conflates it with weakness. My sensitivity is my greatest strength as a human being and an artist and a writer. I knew that I wanted to address grief and trauma through my brand, and to create highly emotional content. I chose the name Lurid Lacquer because the idea of speaking openly, frankly, and unapologetically about emotion and mental health is considered to be in very poor taste in my community of origin. I also wanted to play on the secondary meaning of lurid: to be garishly or offensively bright. My creations are both things: scandalously emotional and offensively vibrant!",
    website: "https://luridlacquer.com/",
    contact_email: "customerservice@luridlacquer.com",
    logo_url: "/uploads/brand/logo/lurid-lacquer.png"
  }
  |> Repo.insert!()

lynb =
  %Brand{
    name: "LynB Designs",
    slug: "lynb-designs",
    description:
      "LynBDesigns was started as a hobby, and in 2012 we tried my hand at making nail polish. We make polish based on ours/your favorite movies, television shows, musicals, and even holidays. We use a unique perspective and a quirky sense of color to make polishes you won't find in your local stores.",
    website: "https://lynbdesigns.store/",
    contact_email: "lynbdesigns@yahoo.com",
    logo_url: "/uploads/brand/logo/lynb-designs.png"
  }
  |> Repo.insert!()

olive_ave =
  %Brand{
    name: "Olive Ave Polish",
    slug: "olive-ave-polish",
    description:
      "I created Olive Ave Polish to make nail care easy, joyful, and something you can feel good about. Our polish is non-toxic, cruelty-free, shipped in recycled packaging, and designed for effortless application. Because when you take time for yourself, you deserve products that reflect your values.",
    website: "https://oliveavepolish.com/",
    contact_email: "support@oliveavepolish.com",
    logo_url: "/uploads/brand/logo/olive-ave-polish.png"
  }
  |> Repo.insert!()

starrily =
  %Brand{
    name: "Starrily",
    slug: "starrily",
    description:
      "Choose from a kaleidoscope of highly pigmented, vegan, cruelty-free & 10-free hues, made in the USA. Because at the end of the day, your nails are the canvas, and you are the master artist, painting your unique style onto the world.",
    website: "https://starrily.com/",
    contact_email: "support@starrily.com",
    logo_url: "/uploads/brand/logo/starrily.png"
  }
  |> Repo.insert!()

ashes_of_creation =
  %Polish{
    name: "Ashes of Creation",
    slug: "ashes-of-creation",
    description:
      "Ashes of Creation has a white crelly base with yellow/orange, orange/red, and bright red metallic flakes!\n\nThis polish is inspired by the rebirth of a Phoenix from the ashes, but also by the new life of a Phoenix from an egg.",
    colors: [:white, :red, :orange, :yellow],
    finishes: [:crelly, :flake],
    brand: arcana
  }
  |> Repo.insert!()

citracorn =
  %Polish{
    name: "Citracorn",
    slug: "citracorn",
    description:
      "While touring the citrus grove, you may spot a rare Citracorn! Their brightly colored coats come from their exclusive diet of grapefruit.\n\nCitracorn has a coral crelly base with red to orange shimmer.",
    colors: [:pink],
    finishes: [:crelly, :shimmer],
    brand: arcana
  }
  |> Repo.insert!()

emissary_of_inari =
  %Polish{
    name: "Emissary of Inari",
    slug: "emissary-of-inari",
    description:
      "Emissary of Inari is a thermal polish that goes from red (cold) to light pink (warm) with a strong red to orange shimmer!\n\nEmissary of Inari is inspired by the wise Kitsune. Inari is said to be the diety of rice, agriculture, and good fortune. It is said that Kitsune are the messengers of Inari, bringing good fortune with them as they visit rice fields.\n\nInari is one of the most popular deities in Japan, with over a third of the shrines dedicated to them. You can identify an Inari shrine by its bright red color and multiple fox statues!",
    colors: [:purple, :pink, :red],
    finishes: [:thermal, :shimmer],
    brand: arcana
  }
  |> Repo.insert!()

lost_hope =
  %Polish{
    name: "Lost Hope",
    slug: "lost-hope",
    description:
      "Lost Hope is a darkish red jelly base with strong orange to yellow shimmer.\n\nIf you struck a deal with Raphael, or you just want to kill a devil, you'll find yourself at the House of Hope. The house is a beautiful prison adorned with red carpets and warm fires. Don't get too cozy; Hope is waiting.",
    colors: [:red, :orange, :yellow],
    finishes: [:jelly, :shimmer],
    brand: arcana
  }
  |> Repo.insert!()

mushroom_lit_cavern =
  %Polish{
    name: "Mushroom-Lit Cavern",
    slug: "mushroom-lit-cavern",
    description:
      "In the distance you see a faint glow that grows as you approach. A dim cave gives way to an oasis of glowing blue mushrooms. Fae flit between the stalks as you take a seat on a moss-covered stone to admire the beauty. Mushroom-Lit Cavern is a thermal polish that goes from dark blue (cold) to light blue (warm) with a strong violet-blue shimmer. The shimmer alters the cold state to read more royal blue than pure black!",
    colors: [:blue],
    finishes: [:thermal, :shimmer],
    brand: arcana
  }
  |> Repo.insert!()

shattered_remnants =
  %Polish{
    name: "Shattered Remnants",
    slug: "shattered-remnants",
    description:
      "Shattered Remnants has a blueish-green jelly base with gold flakes and gold reflective glitter.",
    colors: [:green, :gold],
    finishes: [:jelly, :flake, :glitter],
    brand: arcana
  }
  |> Repo.insert!()

volcanicorn =
  %Polish{
    name: "Volcanicorn",
    slug: "volcanicorn",
    description:
      "Within an active volcano reside the fiery Volcanicorn! With their black coats and red mane, they blend in with their surroundings.\n\nVolcanicorn has a dark red base with a red pearlescent shimmer!",
    colors: [:red],
    finishes: [:shimmer],
    brand: arcana
  }
  |> Repo.insert!()

horizon =
  %Polish{
    name: "Horizon",
    slug: "horizon",
    description: "HORIZON is a pumpkin orange linear holographic.",
    colors: [:orange, :rainbow],
    finishes: [:holo],
    brand: colores_de_carol
  }
  |> Repo.insert!()

malachite =
  %Polish{
    name: "Malachite",
    slug: "malachite",
    description: "Deep Turquoise linear holographic.",
    colors: [:green, :blue, :rainbow],
    finishes: [:holo],
    brand: colores_de_carol
  }
  |> Repo.insert!()

sapphire_princess =
  %Polish{
    name: "Sapphire Princess",
    slug: "sapphire-princess",
    description:
      "Intense sapphire blue linear holographic.\n\n**NOTE: I highly recommend you use a base coat as you may experience staining.",
    colors: [:blue, :rainbow],
    finishes: [:holo],
    brand: colores_de_carol
  }
  |> Repo.insert!()

slappys_tie =
  %Polish{
    name: "Slappy's Tie",
    slug: "slappys-tie",
    description:
      "Slappy's Tie is a deep oxblood red linear holographic.\n\n**NOTE: I highly recommend you use a base coat as you may experience staining.",
    colors: [:red, :rainbow],
    finishes: [:holo],
    brand: colores_de_carol
  }
  |> Repo.insert!()

the_scarecrow_walks_at_midnight =
  %Polish{
    name: "The Scarecrow Walks At Midnight",
    slug: "the-scarecrow-walks-at-midnight",
    description:
      "The Scarecrow Walks At Midnight is an intense burnt orange linear holographic with iridescent orange flakes.\n\n**NOTE: I highly recommend you use a base coat as you may experience staining.",
    colors: [:orange, :red, :rainbow],
    finishes: [:holo],
    brand: colores_de_carol
  }
  |> Repo.insert!()

berried_juniper =
  %Polish{
    name: "Berried Juniper",
    slug: "berried-juniper",
    description:
      "Introducing Berried Juniper, a stunning mid-toned green inspired by the resilient juniper plant commonly found in the Pacific Northwest. Part of our Plant trio, this shade captures the essence of nature's beauty with its rich, verdant hue. Its super shiny, full-coverage formula is self-leveling, providing a smooth, flawless finish every time. Nurture yourself and your nails with this nature-inspired green that’s perfect for any season. Embrace the outdoors and freshen up your look with Berried Juniper!\n\nFun Fact - Inspired by my love of green colors in home decor and wall paint. I saw it as a sign from the universe to create some muted greens because I kept falling in love with green house accents.\n\nPro Tip - Take to the nearest home decor place and I bet you will spot so many things in this shade hahaha.\n\nFull coverage in 2-3 coats.",
    colors: [:green],
    finishes: [:creme],
    brand: cracked
  }
  |> Repo.insert!()

black_jade =
  %Polish{
    name: "Black Jade",
    slug: "black-jade",
    description:
      "Meet Black Jade, the sophisticated dark green cream polish inspired by its namesake plant's rich, timeless beauty. This deep, cool-toned green wraps your nails in an elegant, polished, bold, and refined look. With its smooth, creamy formula, Black Jade glides on effortlessly, giving you a sleek, luxe finish that feels grounded yet elevated. Part of our Plant Trio.\n\nPerfect for those who crave something dark but with a natural edge, Black Jade is that understated yet eye-catching green that adds just the right amount of relaxed sophistication to your manicure.\n\nPro Tip - Wear as a French tip manicure for a fun spin.\n\nFull coverage in 2-3 coats.",
    colors: [:green],
    finishes: [:creme],
    brand: cracked
  }
  |> Repo.insert!()

calabrian_pepper =
  %Polish{
    name: "Calabrian Pepper",
    slug: "calabrian-pepper",
    description:
      "Spice up your nails with Calabrian Pepper. This trendy fiery red cream is perfect for adding a little sizzle to your nails.\n\nFun Fact - Inspired by a type of red chili pepper that are native to the Calabria region of Southern Italy.\n\nPro Tip - Wear your favorite matte top coat for a classic manicure.\n\nFull coverage in 2-3 coats.",
    colors: [:red],
    finishes: [:creme],
    brand: cracked
  }
  |> Repo.insert!()

chinotto =
  %Polish{
    name: "Chinotto",
    slug: "chinotto",
    description:
      "Experience the rich elegance of Chinotto. This unique warm dark brown jelly brings a touch of the Mediterranean. Perfect for those who appreciate subtlety and depth.\n\nFun Fact - Inspired by an Italian Drink.\n\nPro Tip - Wear with you favorite matte or glossy top coat.\n\nFull coverage in 2-3 coats.",
    colors: [:brown],
    finishes: [:jelly],
    brand: cracked
  }
  |> Repo.insert!()

delicacy_in_sardinia =
  %Polish{
    name: "Delicacy in Sardinia",
    slug: "delicacy-in-sardinia",
    description:
      "Savor the rich Delicacy in Sardinia. Our burnt orange cream has luscious hues of orange and burnt red. I would only produce the finest tomato red cream for my cronies.\n\nFun Fact - Inspired by the sauces used in pasta dishes.\n\nPro Tip - Wear with your favorite matte or glossy top coat.\n\nFull coverage in 2-3 coats.",
    colors: [:orange, :red],
    finishes: [:creme],
    brand: cracked
  }
  |> Repo.insert!()

dough_re_mi =
  %Polish{
    name: "Dough-re-mi",
    slug: "dough-re-mi",
    description:
      "Sing into the season with Dough-re-mi, a sophisticated nude polish with a hint of peach shimmer, a part of our Food Coma collection that’s as smooth and warm as your favorite holiday melodies. Inspired by the joy of festive caroling, this soft, glowing shade brings a subtle radiance to your nails, perfect for any occasion. Whether you're singing along to carols or cozying up by the fire, Dough-re-mi adds a touch of understated elegance with a dash of shimmer. Let your nails hum in harmony with the spirit of the season!\n\nFun Fact - Inspired by comforting Christmas carols. It's like your go-to neutral shade.\n\nPro Tip - Paint Broken Ornaments on top for a festive look.",
    colors: [:nude, :orange, :pink],
    finishes: [:shimmer],
    brand: cracked
  }
  |> Repo.insert!()

im_jaded =
  %Polish{
    name: "I'm Jaded",
    slug: "im-jaded",
    description:
      "Meet I'm Jaded a luscious deep jade crelly polish that’s super juicy and the perfect way to transition into warmer days ahead. Our crelly formulas are self leveling and gives your nails that effortlessly smooth, squishy finish. A special St. Patrick’s Day release, this stunning green is a continuation of my unwavering love for all things green because let’s be real, you can never have too many!\n\nJade is a stone of good luck, harmony, and balance, making this shade perfect. It's a little moment of self-care, a touch of inner peace, and maybe even a lucky charm for 2025. Working on growth, alignment, and self-love? I'm Jaded is here for the journey. And let’s be honest, who couldn’t use a little extra luck nowadays.",
    colors: [:green],
    finishes: [:crelly],
    brand: cracked
  }
  |> Repo.insert!()

leather_bound =
  %Polish{
    name: "Leather Bound",
    slug: "leather-bound",
    description:
      "Our duochrome shade, Leather Bound, is going to hold your attention. This dark metallic mahogany with a slight green gold shift is rich in tone and allure like a leather book cover. Elevate your basics with the timeless look of aged leather on your nails.\n\nFun Fact - Inspired by leather book covers.\n\nPro Tip - Try in various lighting to see the really cool shifts pull through.",
    colors: [:brown, :gold, :green],
    finishes: [:duochrome, :metallic],
    brand: cracked
  }
  |> Repo.insert!()

read =
  %Polish{
    name: "Read",
    slug: "read",
    description:
      "There is just something so indulgent about a rich Read (red). This sophisticated dark merlot cream embodies the depth of a cherished book. Your new favorite fall shade has entered the room like a bold new character in a story.\n\nFun Fact - Naming was inspired by reading at its a red. Get it? Read pronounced red, lol.\n\nPro Tip - Try it with your favorite matte topcoat.\n\nFull coverage in 2-3 coats.",
    colors: [:red],
    finishes: [:creme],
    brand: cracked
  }
  |> Repo.insert!()

red_planet_panic =
  %Polish{
    name: "Red Planet Panic",
    slug: "red-planet-panic",
    description:
      "Inspiration: Tim Burtons Mars Attacks\n\nDescription: Sound the alarms—Red Planet Panic has landed, and it's out-of-this-world stunning! This warm red jelly polish is packed with multichrome flakes that shift like a UFO in the night sky, flashing hints of green, gold, and magenta. It’s chaos, it’s beauty, it’s a red lover’s dream come true.\n\nInspired by Tim Burton’s cult classic Mars Attacks!, this shade is pure retro sci-fi magic—bold, eye-catching, and just a little bit dangerous. The squishy red base glows like a planetary invasion, while the shifting flakes create an intergalactic spectacle at your fingertips.",
    colors: [:red],
    finishes: [:jelly, :flake],
    brand: cracked
  }
  |> Repo.insert!()

situationship =
  %Polish{
    name: "Situationship",
    slug: "situationship",
    description:
      "Navigate the complexities of love with Situationship, our dark maroon duochrome with black to red shifting shimmers will command your attention all day long. Be prepared to be entangled with this beauty.\n\nFun Fact - This is one of the most expensive colors I have created thus far.\n\nPro Tip - Use with caution, this shade causes a major distraction. You won't be able stop looking at your nails in all the different lighting.",
    colors: [:red, :black],
    finishes: [:duochrome, :shimmer],
    brand: cracked
  }
  |> Repo.insert!()

stem =
  %Polish{
    name: "Stem",
    slug: "stem",
    description:
      "This nature inspired leafy green cream Stem provides a lush charm to your nails. It's almost like you applied a plant leaf straight on to your nail bed.\n\nFun Fact - Stems are the main transportation routes of water from the roots to the leaves.\n\nPro Tip - Wear underneath Boujee Emerald for a shimmering deep green.\n\nFull coverage in 2-3 coats.",
    colors: [:green],
    finishes: [:creme],
    brand: cracked
  }
  |> Repo.insert!()

stuck_on_monday_blues =
  %Polish{
    name: "Stuck On Monday Blues",
    slug: "stuck-on-monday-blues",
    description:
      "Embrace the depth and disdain for the start of the week with Stuck On Monday Blues, our blackened navy with blue shimmers is perfect for starting the week with a whole moody vibe.\n\nFun Fact - This shade was my fun take on those who want to try black nails but don’t want to fully commit. In the dark people may see this as black but once a little light hits, it transforms into magical blue dancing shimmers on your nails.\n\nPro Tip - Wear Lazy Like Lilac on top for an ethereal glow.",
    colors: [:blue],
    finishes: [:shimmer],
    brand: cracked
  }
  |> Repo.insert!()

the_shag =
  %Polish{
    name: "The Shag",
    slug: "the-shag",
    description:
      "The Shag is a soft hunter green with micro blue and green shimmers and a gold sheen. This green will surprise you. It transforms in the sunlight but looks absolutely stunning on cloudy days.\n\nFun Fact - The Shag is inspired by my grandparents green carpet. Back in their day every carpet was green and so were the appliances.\n\nPro Tip - This green was formulated to suit all skin tones if you are skeptical of trying green I dare you to give this one a chance.",
    colors: [:green, :blue, :gold],
    finishes: [:shimmer],
    brand: cracked
  }
  |> Repo.insert!()

wheres_my_bliss =
  %Polish{
    name: "Where's My Bliss?",
    slug: "wheres-my-bliss",
    description:
      "Where’s My Bliss? is described as a sea foam teal crelly. This shade was inspired by the stained glass nail trend. Any sea foam shade instantly makes me feel calm. This lovely shade is apart of our Beach collection.\n\nFun Fact - This is up there as one of my highest number of prototypes to nail the undertones of this one. I think it's going to be hard to dupe.\n\nPro Tip - Wear one coat with your favorite matte top coat on for a stained glass look.",
    colors: [:green, :blue],
    finishes: [:crelly],
    brand: cracked
  }
  |> Repo.insert!()

vintage_lampshade =
  %Polish{
    name: "Vintage Lampshade",
    slug: "vintage-lampshade",
    description:
      "Step into the nostalgia of entering an old library and seeing green lamps everywhere. The iconic Vintage Lampshade is a rich pine with a slight blue-purple shift bound to capture green lovers' hearts.\n\nFun Fact - Inspired by green library lamps.\n\nPro Tip - Try in various lighting to see the cool shifts pull through.",
    colors: [:green, :blue],
    finishes: [:multichrome],
    brand: cracked
  }
  |> Repo.insert!()

once_upon_a_trail =
  %Polish{
    name: "Once Upon a Trail",
    slug: "once-upon-a-trail",
    description:
      "Step into a storybook with Once Upon A Trail, our warm brown crelly creation for this month’s Hella Handmade Creations! Continuing our Down The Indie Rabbit Hole theme, this shade is a captivating blend of softness and elegance, inspired by the mesmerizing beauty of tiger’s eye stones.\n\nOnce Upon a Trail features a warm, earthy brown base with stunning gold magnetic pigments that shimmer and shift like the bands of light on polished tiger’s eye. Soft, wearable, and endlessly enchanting, it’s the perfect polish for those who love understated yet magical shades.",
    colors: [:brown, :gold],
    finishes: [:crelly, :magnetic],
    brand: cracked
  }
  |> Repo.insert!()

carnelian =
  %Polish{
    name: "Carnelian",
    slug: "carnelian",
    description:
      "This polish was inspired by the August birthstone, Carnelian. This orange polish has a strong holographic effect and is ready to go in about 1-2 coats. The carnelian stone is known to restore vitality and motivation, and also foster creativity. It gives courage and promotes positive life choices.",
    colors: [:orange, :rainbow],
    finishes: [:holo],
    brand: dam
  }
  |> Repo.insert!()

copper =
  %Polish{
    name: "Copper",
    slug: "copper",
    description:
      "Metallic copper linear holographic polish inspired by the jewelry metal copper.",
    colors: [:gold, :rainbow],
    finishes: [:holo],
    brand: dam
  }
  |> Repo.insert!()

dragon =
  %Polish{
    name: "Dragon",
    slug: "dragon",
    description:
      "Red base with gold flakes.\n\nThe dragon is a powerful symbol in astrology and a symbol of power and grandeur. Dragons tend to be charming and popular and are generally honest and authentic. They are not skilled at faking their feelings. Red and gold are lucky colors for the dragon zodiac.",
    colors: [:red, :gold],
    finishes: [:jelly, :flake],
    brand: dam
  }
  |> Repo.insert!()

emerald =
  %Polish{
    name: "Emerald",
    slug: "emerald",
    description:
      "This emerald green nail polish was inspired by the May birthstone, Emerald. This rich green polish has a strong holographic effect and is ready to go in about 1-2 coats. The word Emerald comes from a Latin term “smaragdus,” signifying green gem. Emeralds were once Cleopatra's favorite gems and are thought to symbolize wisdom, growth, and patience.",
    colors: [:green, :rainbow],
    finishes: [:holo],
    brand: dam
  }
  |> Repo.insert!()

rabbit =
  %Polish{
    name: "Rabbit",
    slug: "rabbit",
    description:
      "White base with pink and gold shifting shimmer.\n\nRabbits are very witty, quick minded, compassionate and charming people. Pink is considered to be lucky for those born in the year of the Rabbit. The rabbit in the Chinese zodiac are synonymous with the cat in the Vietnamese zodiac.",
    colors: [:white, :pink, :gold],
    finishes: [:shimmer],
    brand: dam
  }
  |> Repo.insert!()

ruby =
  %Polish{
    name: "Ruby",
    slug: "ruby",
    description:
      "This polish was inspired by the July birthstone, Ruby. This vivid red polish has a strong holographic effect. It is ready to go in about 1-2 coats. The gemstone Ruby represents love, health, and wisdom. It's believed to bring good fortune on anyone wearing the gemstone.",
    colors: [:pink, :red, :rainbow],
    finishes: [:holo],
    brand: dam
  }
  |> Repo.insert!()

tiger =
  %Polish{
    name: "Tiger",
    slug: "tiger",
    description:
      "Orange base with orange and gold shifting shimmer. Tigers usually have an overall down to earth personality who are confident and can be great leaders. Orange is considered to be a lucky color for the tiger.",
    colors: [:orange, :gold],
    finishes: [:shimmer],
    brand: dam
  }
  |> Repo.insert!()

blue_banded_pelican =
  %Polish{
    name: "Blue-Banded Pelican",
    slug: "blue-banded-pelican",
    description:
      "Blue-Banded Brown Pelican is a rich medium tone blue creme.\n\nBrown Pelicans are brought to International Bird Rescue for care for a variety of reasons, from oil spills and food shortages to fishing gear-related injuries.\n\nSince 2009, Bird Rescue has been equipping rehabilitated Brown Pelicans with special blue bands before their release. These bands have large white lettering that makes them easy to spot and read out in the wild.\n\nReports on these blue-banded pelicans have provided them with important information on post-release survival and the pelicans’ movements up and down the coast.\n\nYou can help International Bird Rescue and other conservation organizations by keeping an eye out for banded birds and reporting any that you see to reportband.gov.",
    colors: [:blue],
    finishes: [:creme],
    brand: dimension
  }
  |> Repo.insert!()

go_vegan =
  %Polish{
    name: "Go Vegan",
    slug: "go-vegan",
    description: "",
    colors: [:red],
    finishes: [:creme],
    brand: dimension
  }
  |> Repo.insert!()

great_indian_hornbill =
  %Polish{
    name: "Great Indian Hornbill",
    slug: "great-indian-hornbill",
    description:
      "Great Indian Hornbill is a vibrant yellow with gold shimmers throughout.\n\n1. The Great Indian Hornbill (Buceros bicornis) is one of the largest hornbill species found in the Indian subcontinent. They measure approximately 95 to 130 cm (37 to 51 inches) in length, with a wingspan of about 150 cm (59 inches).\n\n2. Known for their distinct appearance, Great Indian Hornbills have a large yellowish casque, which is a hollow structure on the upper beak. The casque acts as a resonating chamber, enhancing the bird's calls. Males usually have larger casques than females.\n\n3. Habitat destruction and hunting have led to the decline of Great Indian Hornbill populations. They primarily inhabit the canopy levels of evergreen and mixed deciduous forests, as well as hilly and mountainous regions. These birds are found in India, Bhutan, Nepal, and parts of Southeast Asia.",
    colors: [:yellow, :gold],
    finishes: [:shimmer],
    brand: dimension
  }
  |> Repo.insert!()

halloween_hermit_crab =
  %Polish{
    name: "Halloween Hermit Crab",
    slug: "halloween-hermit-crab",
    description:
      "Halloween Hermit Crab is a rich metallic like orange.\n\nThe Halloween hermit crab gets their name from their striking coloration, which resembles Halloween decorations.",
    colors: [:orange],
    finishes: [:shimmer],
    brand: dimension
  }
  |> Repo.insert!()

orange_pecan_milk =
  %Polish{
    name: "Orange Pecan Milk",
    slug: "orange-pecan-milk",
    description:
      "Orange Pecan Milk is a creamy, tropical light orange.\n\nOur plant based milk lacquer collection has a milky jelly formula. It is somewhat sheer but can be built up for richer color and coverage! A pop of color with a visible nail line can be achieved with this collection.",
    colors: [:orange],
    finishes: [:jelly],
    brand: dimension
  }
  |> Repo.insert!()

vanilla_almond_milk =
  %Polish{
    name: "Vanilla Almond Milk",
    slug: "vanilla-almond-milk",
    description:
      "Vanilla Almond Milk is a milky white jelly.\n\nOur plant based milk lacquer collection has a milky jelly formula. It is somewhat sheer but can be built up for richer color and coverage! A pop of color with a visible nail line can be achieved with this collection.",
    colors: [:white],
    finishes: [:jelly],
    brand: dimension
  }
  |> Repo.insert!()

vitamin_d =
  %Polish{
    name: "Vitamin D",
    slug: "vitamin-d",
    description: "",
    colors: [:yellow, :orange],
    finishes: [:creme],
    brand: dimension
  }
  |> Repo.insert!()

western_grebe =
  %Polish{
    name: "Western Grebe",
    slug: "western-grebe",
    description:
      "Western Grebe is a bright red sheer jelly.\n\nWestern Grebes are diving birds with striking bright red eyes. They spend almost their entire lives on the water, building floating nests and carrying their young on their backs.\n\nThese grebes are common patients at the International Bird Rescue and come into care due to oil spills, starvation, and a wide range of injuries. They were the favorite species of Bird Rescue’s founder, Alice Berkner.\n\nOne of the best ways to help protect these birds is to help keep our waterways clean.",
    colors: [:red],
    finishes: [:jelly],
    brand: dimension
  }
  |> Repo.insert!()

%Polish{
  name: "All the Rage",
  slug: "all-the-rage",
  description:
    "A multichrome nail polish that shifts from a dark grey to a deep red.\n\nOpaque in 2 - 3 coats depending on your application, top coat recommended for a glossy finish.",
  colors: [:gray, :black, :red],
  finishes: [:multichrome],
  brand: emily_de_molly
}
|> Repo.insert!()

%Polish{
  name: "Blue Duke",
  slug: "blue-duke",
  description:
    "A brown nail polish with a large particle aurora shimmer that has a subtle shift from green to blue.\n\nOpaque in 2-3 coats depending on your application, top coat recommended for a glossy finish.",
  colors: [:green, :blue, :brown],
  finishes: [:shimmer],
  brand: emily_de_molly
}
|> Repo.insert!()

%Polish{
  name: "Fiery Attraction",
  slug: "fiery-attraction",
  description:
    "A deep red nail polish with a red to orange shifting magnetic effect.\n\nOpaque in 2 - 3 coats depending on your application, top coat recommended for a glossy finish.",
  colors: [:red, :orange],
  finishes: [:magnetic],
  brand: emily_de_molly
}
|> Repo.insert!()

%Polish{
  name: "Secret Code",
  slug: "secret-code",
  description: "A dark vampy red nail polish with subtle copper aurora shimmer.
Opaque in 2 - 3 coats depending on your application, top coat recommended for a glossy finish.",
  colors: [:red],
  finishes: [:shimmer],
  brand: emily_de_molly
}
|> Repo.insert!()

%Polish{
  name: "Somebody's Fool",
  slug: "somebodys-fool",
  description:
    "A multichrome nail polish that shifts through shades of greens and blues.\n\nOpaque in 2 - 3 coats depending on your application, top coat recommended for a glossy finish.",
  colors: [:blue, :green, :purple],
  finishes: [:multichrome],
  brand: emily_de_molly
}
|> Repo.insert!()

%Polish{
  name: "Spells of Love",
  slug: "spells-of-love",
  description:
    "A deep brick red creme nail polish.\n\nOpaque in 1 - 2 coats depending on your application, top coat recommended for a glossy finish.",
  colors: [:pink, :red],
  finishes: [:creme],
  brand: emily_de_molly
}
|> Repo.insert!()

%Polish{
  name: "Wrong Side of Heaven",
  slug: "wrong-side-of-heaven",
  description:
    "A bright red holographic nail polish.\n\nOpaque in 2 - 3 coats depending on your application, top coat recommended for a glossy finish.\n\nThis colour has the potential for staining.",
  colors: [:red, :rainbow],
  finishes: [:holo],
  brand: emily_de_molly
}
|> Repo.insert!()

%Polish{
  name: "Blood Bag",
  slug: "blood-bag",
  description:
    "A rich oxblood red base with an aurora shimmer that shifts from red to orange.\n\nPlease note that this polish is very pigmented and may stain. Please wear a good base coat!\n\nOctober is Bleeding Disorder Awareness Month. $1 from every bottle sold of Blood Bag will be donated to the National Organization for Rare Disorders.",
  colors: [:red],
  finishes: [:shimmer],
  brand: lurid
}
|> Repo.insert!()

%Polish{
  name: "Faded Flannel",
  slug: "faded-flannel",
  description:
    "Faded Flannel features a cool-toned brick red jelly base with warm red-to-orange aurora shimmer and a mix of bronze and silver light reflective glitter.\n\nFaded Flannel is part of the Midwestern Winters Collection (these polishes were given as gifts with purchase at random at our November 2024 launch).",
  colors: [:red, :orange],
  finishes: [:jelly, :shimmer, :glitter],
  brand: lurid
}
|> Repo.insert!()

%Polish{
  name: "Fireside",
  slug: "fireside",
  description:
    "Fireside features an orange jelly base with vibrant orange to gold aurora shimmer that shifts to green at extremes.\n\nFireside is part of the Midwestern Winters Collection (these polishes were given as gifts with purchase at random at our November 2024 launch).\n\n$1 per bottle will be donated to Baby2Baby's Disaster Relief and Emergency Response Program.",
  colors: [:orange, :gold],
  finishes: [:jelly, :shimmer],
  brand: lurid
}
|> Repo.insert!()

%Polish{
  name: "I Await Your Arrival",
  slug: "i-await-your-arrival",
  description:
    "A rich cobalt base with a warm blue aurora shimmer that shifts to purple and bronze light reflective glitter.\n\nI Await Your Arrival is part of the Waiting for Someone Who Never Comes Collection.",
  colors: [:blue],
  finishes: [:shimmer, :glitter],
  brand: lurid
}
|> Repo.insert!()

%Polish{
  name: "Indomitable",
  slug: "indomitable",
  description:
    "A violet-leaning purple base with a vibrant purple to pink to red shimmer.\n\n(This product is very pigmented and may stain your nail bed. Please wear a base coat to prevent staining.)\n\nFrom the Thistle and Thorn Collection.",
  colors: [:purple, :pink],
  finishes: [:shimmer],
  brand: lurid
}
|> Repo.insert!()

%Polish{
  name: "Potholes Trail",
  slug: "potholes-trail",
  description:
    "A cerulean crelly base with glowy green shimmer that shifts subtly to teal at extremes.\n\nPotholes Trail is part of the Summers With My Siblings Collection.",
  colors: [:blue, :green],
  finishes: [:crelly, :shimmer],
  brand: lurid
}
|> Repo.insert!()

%Polish{
  name: "Saturday Morning Cartoons",
  slug: "saturday-morning-cartoons",
  description:
    "A pinky coral jelly base with large particle shimmer that shifts from pink to orange to gold.\n\nSaturday Morning Cartoons is part of the Summers With My Siblings Collection.",
  colors: [:pink, :orange],
  finishes: [:jelly, :shimmer],
  brand: lurid
}
|> Repo.insert!()

%Polish{
  name: "Sure, Bert",
  slug: "sure-bert",
  description:
    "A pinky coral base with aurora shimmer that shifts from red to orange to gold.\n\nSure, Bert is part of the Summers With My Siblings Collection.",
  colors: [:pink, :orange, :gold],
  finishes: [:shimmer],
  brand: lurid
}
|> Repo.insert!()

%Polish{
  name: "Tomate de Árbol",
  slug: "tomate-de-arbol",
  description:
    "A coral red base with vibrant orange to gold to green shimmer (the shimmer gives this polish an overall orange appearance).\n\nTomate de Árbol is part of the Cartagena Querida Collection.",
  colors: [:orange, :red, :gold],
  finishes: [:shimmer],
  brand: lurid
}
|> Repo.insert!()

%Polish{
  name: "Vixen",
  slug: "vixen",
  description:
    "Vixen features a blackened maroon base with fine particle aurora shimmer that shifts from purple to pink to red. (This is the same beautiful shimmer that is in Indomitable and A Rose Amongst the Weeds.)\n\nThe base is pigmented and may stain. Please wear a good base coat!",
  colors: [:purple, :red],
  finishes: [:shimmer],
  brand: lurid
}
|> Repo.insert!()

%Polish{
  name: "Why Would I Wear Lipstick?",
  slug: "why-would-i-wear-lipstick",
  description:
    "A cherry pinkish-red jelly base with vibrant red to orange shimmer (in some lighting, the base color appears a vibrant deep pink and in other lighting, it appears red).\n\nPlease note that this polish is very pigmented and may stain. As always, please wear a good base coat.\n\nWhy Would I Wear Lipstick? is part of the Forever Weird Collection.",
  colors: [:pink, :red],
  finishes: [:jelly, :shimmer],
  brand: lurid
}
|> Repo.insert!()

%Polish{
  name: "You Are the Only Safe Harbor",
  slug: "you-are-the-only-safe-harbor",
  description:
    "A blue jelly base with vibrant blue to purple shimmer.\n\nYou Are the Only Safe Harbor is part of the A Taurus Born in the Year of the Ox Collection.",
  colors: [:blue, :purple],
  finishes: [:jelly, :shimmer],
  brand: lurid
}
|> Repo.insert!()

%Polish{
  name: "You, of Unbreakable Will",
  slug: "you-of-unbreakable-will",
  description:
    "A red base with fiery red to orange shimmer.\n\nYou, of Unbreakable Will is part of A Taurus Born in the Year of the Ox Collection.",
  colors: [:red],
  finishes: [:shimmer],
  brand: lurid
}
|> Repo.insert!()

%Polish{
  name: "A Little Azure",
  slug: "a-little-azure",
  description: "A Little Azure - deep denim blue creme that watermarbles!!",
  colors: [:blue],
  finishes: [:creme],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "A Peach of My Heart",
  slug: "a-peach-of-my-heart",
  description:
    "A Peach of My Heart - pastel coral neon creme that glows under blacklight and watermarbles!!",
  colors: [:pink],
  finishes: [:creme, :blacklight],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "Always Well Red",
  slug: "always-well-red",
  description: "Always Well Red - deep Victorian red creme that watermarbles - May stain.",
  colors: [:red],
  finishes: [:creme],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "Cancer (The Crab)",
  slug: "cancer-the-crab",
  description:
    "Cancer (the crab) - juicy red base with red to orange to gold shifting micro flakie shimmer.\n\nMay cause staining.",
  colors: [:red, :orange],
  finishes: [:shimmer],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "Citrus Got Real",
  slug: "citrus-got-real",
  description: "Citrus Got Real - pastel neon true orange creme that watermarbles.",
  colors: [:orange],
  finishes: [:creme],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "If You Musk",
  slug: "if-you-musk",
  description: "If You Musk - dark blue base with copper to gold shifting shimmer.",
  colors: [:blue, :gold],
  finishes: [:shimmer],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "It's Fall Coming Back To Me Now",
  slug: "its-fall-coming-back-to-me-now",
  description:
    "It’s Fall Coming Back to Me Now - forest green with copper to green shifting shimmer and a touch of added holo sparkle.",
  colors: [:green, :gold],
  finishes: [:shimmer, :holo],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "Luminous Dream",
  slug: "luminous-dream",
  description:
    "Luminous Dream - pale peach base with orange to gold to green shifting shimmer and added holo flakies.",
  colors: [:orange, :gold],
  finishes: [:shimmer, :flake],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "Old Lady Energy",
  slug: "old-lady-energy",
  description:
    "Old Lady Energy - creamy pink base with pink to gold shifting micro flakie shimmer.",
  colors: [:pink, :gold],
  finishes: [:shimmer],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "Orange You Appealing",
  slug: "orange-you-appealing",
  description:
    "Orange You Appealing - pastel yellow orange neon creme that glows under blacklight and watermarbles!!",
  colors: [:orange, :yellow],
  finishes: [:creme, :blacklight],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "Orpiment",
  slug: "orpiment",
  description: "Orpiment - warm yellow with intense red to orange to gold shifting shimmer.",
  colors: [:yellow, :orange, :red],
  finishes: [:shimmer],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "Pere Cheney",
  slug: "pere-cheney",
  description:
    "Pere Cheney - copper/brown base with a hint of plum filled with copper to gold shifting shimmer.",
  colors: [:brown, :gold],
  finishes: [:shimmer],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "Reddy or Not",
  slug: "reddy-or-not",
  description:
    "Reddy or Not - a neon red creme that glows red under blacklight and that watermarbles!!",
  colors: [:red],
  finishes: [:creme, :blacklight],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "Snake Goddess of Belle Isle",
  slug: "snake-goddess-of-belle-isle",
  description: "Snake Goddess of Belle Isle - emerald green base with copper shimmer.",
  colors: [:green, :gold],
  finishes: [:shimmer],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "Spill the Teal",
  slug: "spill-the-teal",
  description:
    "Spill the Teal - a neon teal creme that glows green-blue under blacklight and that watermarbles!!",
  colors: [:blue, :green],
  finishes: [:creme, :blacklight],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "Stay Topaz-itive",
  slug: "stay-topaz-itive",
  description: "Stay Topaz-itive - a terracotta creme that watermarbles!!",
  colors: [:orange, :brown, :red],
  finishes: [:creme],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "The Cherry Best",
  slug: "the-cherry-best",
  description:
    "The Cherry Best - pastel red-toned pink neon creme that glows under blacklight and watermarbles!!",
  colors: [:pink],
  finishes: [:creme, :blacklight],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "Toucha Toucha Me",
  slug: "toucha-toucha-me",
  description:
    "Toucha Touch Me - a peachy orange to white thermal with a touch of holo shimmer, orange to gold shifting crystal micro flakies, and pink to green shifting crystal flakies.",
  colors: [:orange, :pink, :white],
  finishes: [:thermal, :shimmer, :flake],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "Vermillion",
  slug: "vermillion",
  description:
    "Vermillion - bright warm red to white thermal base with red to orange to gold shifting shimmer.",
  colors: [:pink, :white, :red],
  finishes: [:thermal, :shimmer, :flake],
  brand: lynb
}
|> Repo.insert!()

%Polish{
  name: "Blossom",
  slug: "blossom",
  description: "Petal pink with a strong gold contrasting shimmer.",
  colors: [:pink, :gold],
  finishes: [:shimmer],
  brand: olive_ave
}
|> Repo.insert!()

%Polish{
  name: "Ginger",
  slug: "ginger",
  description: "A spicy orange scattered holographic.",
  colors: [:orange, :brown],
  finishes: [:holo],
  brand: olive_ave
}
|> Repo.insert!()

%Polish{
  name: "Sunburst",
  slug: "sunburst",
  description: "A bold summer yellow cream that evokes the sun's most golden rays.",
  colors: [:yellow],
  finishes: [:creme],
  brand: olive_ave
}
|> Repo.insert!()

%Polish{
  name: "Au",
  slug: "au",
  description:
    "Brilliant golden micro flakie foil nail polish.\n\nUse in 1-3 thin coats to create a stunning foil-like reflective finish.\n\nDescription: Au is a beautiful reflective foil effect nail polish consisting of micro flake particles. It's best applied in 2 thin coats to create a brilliant luster.",
  colors: [:gold],
  finishes: [:metallic],
  brand: starrily
}
|> Repo.insert!()

%Polish{
  name: "Magma",
  slug: "magma",
  description:
    "Magnetic color shifting copper shimmer effect top coat.\n\nColor shifts from a strong reddish copper to magnificent shades of green and gold.\n\nVersatile, use over different base colors for unlimited effects.\n\nCan be used without magnet to add a stunning copper shimmer effect.\n\nDescription: Magma will easily become your new favorite nail polish. Create effortless nail art effects by adding a layer of Magma. Use a magnet to make it 3D or use without a magnet to add a strong copper shimmer. Try it with Eclipse to create a unique holographic magnetic effect or layer over different colors.",
  colors: [:gold, :red],
  finishes: [:magnetic, :shimmer],
  topper: true,
  brand: starrily
}
|> Repo.insert!()

%Polish{
  name: "Queen Bee",
  slug: "queen-bee",
  description:
    "Description: Queen Bee is a highly pigmented bright and creamy mustard yellow nail polish, formulated to be long lasting and high quality. Wear alone or use under our glitter toppers for unique looks! Opaque in 1-2 coats.",
  colors: [:yellow],
  finishes: [:creme],
  brand: starrily
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Beautiful in bottle and swatch.",
  fill_percent: 99,
  purchase_price: Money.new(1200),
  purchase_date: ~D[2025-03-14],
  swatched: true,
  user: alpha,
  polish: ashes_of_creation
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Definitely pink side of coral.",
  fill_percent: 99,
  purchase_price: Money.new(1200),
  purchase_date: ~D[2025-03-14],
  swatched: true,
  user: alpha,
  polish: citracorn
}
|> Repo.insert!()

%StashPolish{
  thoughts:
    "Very reactive thermal - a bit more purple than description indicates but close to photos.",
  fill_percent: 90,
  purchase_price: Money.new(1200),
  purchase_date: ~D[2025-02-14],
  swatched: true,
  user: alpha,
  polish: emissary_of_inari
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Looks perfect for fall.",
  fill_percent: 99,
  purchase_price: Money.new(1200),
  purchase_date: ~D[2025-03-14],
  swatched: true,
  user: alpha,
  polish: lost_hope
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Sadly teal instead of light blue for warm phase.",
  fill_percent: 95,
  purchase_price: Money.new(1200),
  purchase_date: ~D[2025-02-14],
  swatched: true,
  user: alpha,
  polish: mushroom_lit_cavern
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Great for St. Patrick's or Xmas.",
  fill_percent: 95,
  purchase_price: Money.new(1200),
  purchase_date: ~D[2025-02-14],
  swatched: true,
  user: alpha,
  polish: shattered_remnants
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Not sure how vampy - will be fun to try!",
  fill_percent: 99,
  purchase_price: Money.new(1200),
  purchase_date: ~D[2025-03-14],
  swatched: true,
  user: alpha,
  polish: volcanicorn
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Unflattering on me.",
  fill_percent: 98,
  purchase_price: Money.new(1125),
  purchase_date: ~D[2025-03-02],
  swatched: true,
  user: alpha,
  polish: horizon
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Hm, not as unique as I hoped.",
  fill_percent: 98,
  purchase_price: Money.new(1125),
  purchase_date: ~D[2025-03-02],
  swatched: true,
  user: alpha,
  polish: malachite
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Gorgeous dark blue but not very distinct from Cupcake's. Could destash one.",
  fill_percent: 98,
  purchase_price: Money.new(1125),
  purchase_date: ~D[2025-03-02],
  swatched: true,
  user: alpha,
  polish: sapphire_princess
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Excellent vampy color. Not as much rainbow comes through the holo in red however.",
  fill_percent: 98,
  purchase_price: Money.new(1125),
  purchase_date: ~D[2025-03-02],
  swatched: true,
  user: alpha,
  polish: slappys_tie
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Love it, flakies don't detract from holo.",
  fill_percent: 98,
  purchase_price: Money.new(1125),
  purchase_date: ~D[2025-03-02],
  swatched: true,
  user: alpha,
  polish: the_scarecrow_walks_at_midnight
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Gorgeous orange but somehow not as flattering on me. Still worth wearing.",
  fill_percent: 95,
  purchase_price: Money.new(900),
  purchase_date: ~D[2025-02-09],
  swatched: true,
  user: alpha,
  polish: delicacy_in_sardinia
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Unfortunately streaky - user error?",
  fill_percent: 98,
  purchase_price: Money.new(1170),
  purchase_date: ~D[2025-02-09],
  swatched: true,
  user: alpha,
  polish: stuck_on_monday_blues
}
|> Repo.insert!()

%StashPolish{
  thoughts:
    "Peachy color is really only visible in macro photos - still a nice neutral but not as interesting as I hoped.",
  fill_percent: 99,
  purchase_price: Money.new(1170),
  purchase_date: ~D[2025-02-09],
  swatched: true,
  user: alpha,
  polish: dough_re_mi
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Hopefully good fall neutral.",
  purchase_price: Money.new(1300),
  purchase_date: ~D[2025-03-13],
  user: alpha,
  polish: once_upon_a_trail
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Hopefully good for nail art and base for flowers!",
  fill_percent: 99,
  purchase_price: Money.new(675),
  purchase_date: ~D[2025-03-17],
  swatched: true,
  user: alpha,
  polish: black_jade
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Love me a bold red!",
  fill_percent: 99,
  purchase_price: Money.new(900),
  purchase_date: ~D[2025-03-17],
  swatched: true,
  user: alpha,
  polish: calabrian_pepper
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Chocolatey.",
  fill_percent: 99,
  purchase_price: Money.new(900),
  purchase_date: ~D[2025-03-17],
  swatched: true,
  user: alpha,
  polish: chinotto
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Mmmm interesting shine - almost a reddish tone?",
  fill_percent: 99,
  purchase_price: Money.new(1170),
  purchase_date: ~D[2025-03-17],
  swatched: true,
  user: alpha,
  polish: leather_bound
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Deep, vampy red.",
  fill_percent: 99,
  purchase_price: Money.new(900),
  purchase_date: ~D[2025-03-17],
  swatched: true,
  user: alpha,
  polish: read
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Eeeh maybe prettier on nails?",
  fill_percent: 99,
  purchase_price: Money.new(1170),
  purchase_date: ~D[2025-03-17],
  swatched: true,
  user: alpha,
  polish: situationship
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Surprisingly gorgeous - I'm impressed.",
  fill_percent: 99,
  purchase_price: Money.new(878),
  purchase_date: ~D[2025-03-17],
  swatched: true,
  user: alpha,
  polish: the_shag
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Has fun blue angles but green may be a tinge too yellow-toned for me?",
  fill_percent: 99,
  purchase_price: Money.new(878),
  purchase_date: ~D[2025-03-17],
  swatched: true,
  user: alpha,
  polish: vintage_lampshade
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Love it! Super tropical waters.",
  fill_percent: 99,
  purchase_price: Money.new(675),
  purchase_date: ~D[2025-03-17],
  swatched: true,
  user: alpha,
  polish: wheres_my_bliss
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Gray-green that surprisingly I think looks quite nice on me.",
  fill_percent: 99,
  purchase_price: Money.new(675),
  purchase_date: ~D[2025-03-17],
  swatched: true,
  user: alpha,
  polish: berried_juniper
}
|> Repo.insert!()

%StashPolish{
  thoughts:
    "Love jade stones but this color is meh on me at first glance. Maybe try wearing with complementary colors.",
  fill_percent: 99,
  purchase_price: Money.new(675),
  purchase_date: ~D[2025-03-17],
  swatched: true,
  user: alpha,
  polish: im_jaded
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Darker than it looked online - love it.",
  fill_percent: 99,
  purchase_price: Money.new(675),
  purchase_date: ~D[2025-03-17],
  swatched: true,
  user: alpha,
  polish: stem
}
|> Repo.insert!()

%StashPolish{
  purchase_price: Money.new(1300),
  purchase_date: ~D[2025-03-22],
  user: alpha,
  polish: red_planet_panic
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Pretty in bottle but not great on me ;_;",
  fill_percent: 98,
  purchase_price: Money.new(1215),
  purchase_date: ~D[2025-03-03],
  swatched: true,
  user: alpha,
  polish: carnelian
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Ok on me - better alone as a holiday neutral than in a skittle.",
  fill_percent: 98,
  purchase_price: Money.new(1215),
  purchase_date: ~D[2025-03-03],
  swatched: true,
  user: alpha,
  polish: copper
}
|> Repo.insert!()

%StashPolish{
  thoughts: "LOVE",
  fill_percent: 98,
  purchase_price: Money.new(1215),
  purchase_date: ~D[2025-03-03],
  swatched: true,
  user: alpha,
  polish: dragon
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Eh, so close to CdC.",
  fill_percent: 99,
  purchase_price: Money.new(1215),
  purchase_date: ~D[2025-03-03],
  swatched: true,
  user: alpha,
  polish: emerald
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Ooooh shiny white! Pink shine - valentine's?",
  fill_percent: 99,
  purchase_price: Money.new(1215),
  purchase_date: ~D[2025-03-03],
  swatched: true,
  user: alpha,
  polish: rabbit
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Definitely heavily pink-tinted (not apparent from swatches or description).",
  fill_percent: 99,
  purchase_price: Money.new(1215),
  purchase_date: ~D[2025-03-03],
  swatched: true,
  user: alpha,
  polish: ruby
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Very sheer, hopefully suitable for a your-nails-but-better.",
  fill_percent: 99,
  purchase_price: Money.new(1125),
  purchase_date: ~D[2025-01-17],
  swatched: true,
  user: alpha,
  polish: orange_pecan_milk
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Sheer, hopefully suitable for a your-nails-but-better french.",
  fill_percent: 99,
  purchase_price: Money.new(1125),
  purchase_date: ~D[2025-01-17],
  swatched: true,
  user: alpha,
  polish: vanilla_almond_milk
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Like but a bit plain on its own.",
  fill_percent: 98,
  purchase_price: Money.new(875),
  purchase_date: ~D[2025-02-14],
  swatched: true,
  user: alpha,
  polish: blue_banded_pelican
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Perfect true, bold red. Slightly less bright than Western Grebe.",
  fill_percent: 98,
  purchase_price: Money.new(875),
  purchase_date: ~D[2025-02-14],
  swatched: true,
  user: alpha,
  polish: go_vegan
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Gorgeous but incompatible with skin tone ;_;",
  fill_percent: 98,
  purchase_price: Money.new(875),
  purchase_date: ~D[2025-02-14],
  swatched: true,
  user: alpha,
  polish: great_indian_hornbill
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Stunning in bottle and on me.",
  fill_percent: 99,
  purchase_price: Money.new(875),
  purchase_date: ~D[2025-02-14],
  swatched: true,
  user: alpha,
  polish: halloween_hermit_crab
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Just slightly more orange than Olive's Sunburst.",
  fill_percent: 99,
  purchase_price: Money.new(875),
  purchase_date: ~D[2025-02-14],
  swatched: true,
  user: alpha,
  polish: vitamin_d
}
|> Repo.insert!()

%StashPolish{
  thoughts: "Amazing jelly. Super bold and transformed a purple thermal to a red!",
  fill_percent: 95,
  purchase_price: Money.new(875),
  purchase_date: ~D[2025-02-14],
  swatched: true,
  user: alpha,
  polish: western_grebe
}
|> Repo.insert!()
