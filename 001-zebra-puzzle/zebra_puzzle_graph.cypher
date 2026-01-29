// --- 1. Nodes: Houses ---
MERGE (h1:House {pos: 1})
MERGE (h2:House {pos: 2})
MERGE (h3:House {pos: 3})

// --- 2. Nodes: Variables (Colors and Animals) ---
MERGE (blue:Color {name: 'Blue'})
MERGE (red:Color {name: 'Red'})
MERGE (green:Color {name: 'Green'})
MERGE (dog:Animal {name: 'Dog'})
MERGE (cat:Animal {name: 'Cat'})
MERGE (zebra:Animal {name: 'Zebra'})

// --- 3. Explicit Initial Domains ---
// Every variable starts connected to every house. 
// No premature optimization or pre-filtering.
MERGE (blue)-[:DOMAIN]->(h1) MERGE (blue)-[:DOMAIN]->(h2) MERGE (blue)-[:DOMAIN]->(h3)
MERGE (red)-[:DOMAIN]->(h1) MERGE (red)-[:DOMAIN]->(h2) MERGE (red)-[:DOMAIN]->(h3)
MERGE (green)-[:DOMAIN]->(h1) MERGE (green)-[:DOMAIN]->(h2) MERGE (green)-[:DOMAIN]->(h3)
MERGE (dog)-[:DOMAIN]->(h1) MERGE (dog)-[:DOMAIN]->(h2) MERGE (dog)-[:DOMAIN]->(h3)
MERGE (cat)-[:DOMAIN]->(h1) MERGE (cat)-[:DOMAIN]->(h2) MERGE (cat)-[:DOMAIN]->(h3)
MERGE (zebra)-[:DOMAIN]->(h1) MERGE (zebra)-[:DOMAIN]->(h2) MERGE (zebra)-[:DOMAIN]->(h3)

// --- 4. Unary Constraint (Clue 2) ---
// We represent "Red must be House 2" as a target relationship for the solver.
MERGE (red)-[:MUST_BE]->(h2)

// --- 5. Binary Assignment Constraints (Clues 1 & 4) ---
MERGE (cat)-[:SAME_HOUSE_AS]->(red)
MERGE (red)-[:SAME_HOUSE_AS]->(cat)
MERGE (dog)-[:SAME_HOUSE_AS]->(blue)
MERGE (blue)-[:SAME_HOUSE_AS]->(dog)

// --- 6. Binary Spatial Constraints (Clue 3) ---
MERGE (blue)-[:LEFT_OF]->(red)
MERGE (red)-[:RIGHT_OF]->(blue)

// --- 7. All-Different Constraints (Logical Necessity) ---
// Colors must be in different houses
MERGE (red)-[:DIFFERENT_HOUSE_FROM]->(blue)
MERGE (blue)-[:DIFFERENT_HOUSE_FROM]->(red)
MERGE (red)-[:DIFFERENT_HOUSE_FROM]->(green)
MERGE (green)-[:DIFFERENT_HOUSE_FROM]->(red)
MERGE (blue)-[:DIFFERENT_HOUSE_FROM]->(green)
MERGE (green)-[:DIFFERENT_HOUSE_FROM]->(blue)

// Animals must be in different houses
MERGE (cat)-[:DIFFERENT_HOUSE_FROM]->(dog)
MERGE (dog)-[:DIFFERENT_HOUSE_FROM]->(cat)
MERGE (cat)-[:DIFFERENT_HOUSE_FROM]->(zebra)
MERGE (zebra)-[:DIFFERENT_HOUSE_FROM]->(cat)
MERGE (dog)-[:DIFFERENT_HOUSE_FROM]->(zebra)
MERGE (zebra)-[:DIFFERENT_HOUSE_FROM]->(dog)