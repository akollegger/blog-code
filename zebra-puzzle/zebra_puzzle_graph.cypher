// Zebra Puzzle graph representation (constraint graph, not solved)
MERGE (h1:House {pos: 1})
MERGE (h2:House {pos: 2})
MERGE (h3:House {pos: 3})

// Variable nodes
MERGE (blue:Color {name: 'Blue'})
MERGE (red:Color {name: 'Red'})
MERGE (green:Color {name: 'Green'})

MERGE (dog:Animal {name: 'Dog'})
MERGE (cat:Animal {name: 'Cat'})
MERGE (zebra:Animal {name: 'Zebra'})

// Initial domains (apply unary constraint by restricting Red to house 2)
WITH blue, red, green, dog, cat, zebra, h1, h2, h3
UNWIND [
  {var: blue, houses: [h1, h2, h3]},
  {var: green, houses: [h1, h2, h3]},
  {var: red, houses: [h2]},
  {var: dog, houses: [h1, h2, h3]},
  {var: cat, houses: [h1, h2, h3]},
  {var: zebra, houses: [h1, h2, h3]}
] AS entry
UNWIND entry.houses AS house
MERGE (entry.var)-[:DOMAIN]->(house)

// Binary constraints (relationships that a solver can interpret)
MERGE (cat)-[:SAME_HOUSE_AS]->(red)
MERGE (red)-[:SAME_HOUSE_AS]->(cat)

MERGE (dog)-[:SAME_HOUSE_AS]->(blue)
MERGE (blue)-[:SAME_HOUSE_AS]->(dog)

MERGE (blue)-[:LEFT_OF]->(red)
MERGE (red)-[:RIGHT_OF]->(blue)

// All-different constraints for colors (bidirectional)
MERGE (red)-[:DIFFERENT_HOUSE_FROM]->(blue)
MERGE (blue)-[:DIFFERENT_HOUSE_FROM]->(red)
MERGE (red)-[:DIFFERENT_HOUSE_FROM]->(green)
MERGE (green)-[:DIFFERENT_HOUSE_FROM]->(red)
MERGE (blue)-[:DIFFERENT_HOUSE_FROM]->(green)
MERGE (green)-[:DIFFERENT_HOUSE_FROM]->(blue)

// All-different constraints for animals (bidirectional)
MERGE (cat)-[:DIFFERENT_HOUSE_FROM]->(dog)
MERGE (dog)-[:DIFFERENT_HOUSE_FROM]->(cat)
MERGE (cat)-[:DIFFERENT_HOUSE_FROM]->(zebra)
MERGE (zebra)-[:DIFFERENT_HOUSE_FROM]->(cat)
MERGE (dog)-[:DIFFERENT_HOUSE_FROM]->(zebra)
MERGE (zebra)-[:DIFFERENT_HOUSE_FROM]->(dog)
