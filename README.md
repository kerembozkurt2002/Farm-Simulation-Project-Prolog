# Overview
This project involves developing a simulation of a farm environment where animals move, consume food, and reproduce. The game takes place in a simplified farm world where animals gain energy from food to reproduce.

# Files
* main.pro: Your main implementation file.
* cmpefarm.pro and farm.pro: Base mechanics provided; do not modify these.
* farm.txt: The map file representing the farm layout.


# Getting Started
Load the main file and use the following query to check the current state:

* ?- state(Agents, Objects, Time, TurnOrder).

  
# Agents and Objects

**Agents:**
* C: Cow (herbivore)
* H: Chicken (herbivore)
* W: Wolf (carnivore)
* Objects:
* G: Grass
* F: Grain
* M: Corn
  
**Agent Attributes:**
* type: (herbivore/carnivore)
* subtype: Species
* x, y: Coordinates
* energy point: Energy level
* children: Number of offspring
* Object Attributes:
* type: Object type
* subtype: Object kind
* x, y: Coordinates
  
**Predicates:**
* agents_distance(+Agent1, +Agent2, -Distance): Computes the Manhattan distance between two agents.
* number_of_agents(+State, -NumberOfAgents): Finds the total number of agents in a given state. 
* value_of_farm(+State, -Value): Calculates the total value of all products on the farm.
* find_food_coordinates(+State, +AgentId, -Coordinates): Finds coordinates of consumable foods for a specific agent.
* find_nearest_agent(+State, +AgentId, -Coordinates, -NearestAgent): Finds the nearest agent to a given agent.
* find_nearest_food(+State, +AgentId, -Coordinates, -FoodType, -Distance): Finds the nearest consumable food for an agent.
* move_to_coordinate(+State, +AgentId, +X, +Y, -ActionList, +DepthLimit): Finds actions to move an agent to specific coordinates.
* move_to_nearest_food(+State, +AgentId, -ActionList, +DepthLimit): Finds actions to move an agent to the nearest food.
* consume_all(+State, +AgentId, -NumberOfMovements, -Value, -NumberOfChildren, +DepthLimit): Guides an agent to consume all reachable food items.


**For the detailed explanation of the program please read the description.pdf**
