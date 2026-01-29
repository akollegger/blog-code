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

// Initial domains: each variable can be in any house
UNWIND [blue, red, green, dog, cat, zebra] AS var
UNWIND [h1, h2, h3] AS house
MERGE (var)-[:DOMAIN]->(house)

// Unary constraint: Red is in the middle house
MERGE (red)-[:REQUIRES]->(h2)

// Binary constraints (relationships that a solver can interpret)
MERGE (cat)-[:SAME_HOUSE_AS]->(red)
MERGE (dog)-[:SAME_HOUSE_AS]->(blue)
MERGE (blue)-[:LEFT_OF]->(red)

// All-different constraints for colors
MERGE (red)-[:DIFFERENT_HOUSE_FROM]->(blue)
MERGE (red)-[:DIFFERENT_HOUSE_FROM]->(green)
MERGE (blue)-[:DIFFERENT_HOUSE_FROM]->(green)

// All-different constraints for animals
MERGE (cat)-[:DIFFERENT_HOUSE_FROM]->(dog)
MERGE (cat)-[:DIFFERENT_HOUSE_FROM]->(zebra)
MERGE (dog)-[:DIFFERENT_HOUSE_FROM]->(zebra)
