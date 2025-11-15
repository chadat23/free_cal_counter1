# App usage summary

FreeCal Counter is to help people track calories, macros, and weight over time. 

At a high level, eventually, it should be able to do things like track calories, fat, carbs, and protein per meal, day, and week, enable visualizing, easy data entry and editing from sources such as the FDA as well as OpenFoodFacts (OFF). There should be a local db (perced and pruined from FDA data) to search, a local db of logged foods to expidite reselecting foods, and the ability to reach out to OFF as well. Local stuff should be prioritised since it's faster, but other than that basic workflow divergence, any source should seemlessly integrated. It should also be able to track and visualize a person's weight over time, and to make recomendations regarding macro nutrient targets. While the goal isn't infinite flexibility or to allow any work flow, it needs to be flexible, we always want it to be easy for users to fix input mistakes.

# Key Workflows

## Switch between the 4 tabs
- Tap each of the 4 tab buttons and observe that they each display properly

## Search for local food item and add it to the Log Queue
- From the Overview or Log page, click on the Search Bar at the bottom of the screen to bring up the Search Screen which also displays the Search Bar
- Enter a search term.
- Select a food item serving type to bring up the Serving Edit screen
- Set the serving size and unit of measure
- Click Add button to add the serving to the Log Queue

## An atypical yet feature rich workflow
- Click between the 4 tabs and ensure that they each display what they're currently expected to display
- Click on the Search bar
  - Do a simple search
  - Select an item
  - Edit the units and amount
  - Ensure that they below values update as expected, cancel and ensure it goes back to the right screen, search again, select and set values, then add the item to the Queue, click the log button, ensure that the Dashbard and Log display properly, search for and add two foods to the queue, click on the queue button and ensure they display properly, drag one to the left, delete it and ensure it deletes, drag the other to the right, click the edit button, edit it, ensure it updates properly, and click the log button from the queue, again ensure that the Dashboard and Log display properly, then ensure that from the Log, you can delete an item and edit the other, and again, ensure the dashboard and log update properly.
  
# Screens Overview
- Overview: basic summeries of the weeks macros as well as a graph of the user's weight. The macros are to be in a tables of bar charts as well as some labels. The weight is via a line graph.
- Log: the person's logged foods. 
  - The top should have a label for the day: a date, "Yesterday", "Today", or "Tomorrow" with simple navigation to move between days. 
  - Each set of foods that are logged together should have a timestamp above the group. 
  - Each serving of each food item should be in its own little bubble and should contain size of the serving, the units of measure of measure, macros, and the image of the food. 
  - Should let the user switch to see what was logged on any given day via the top navigation. 
  - Should allow deleting, copying, and editing logged items.
- Search: shows results from food searches.
- Log Queue: same basic thing as the Log, only its a staging area between food entry and the log so it'll be a list of food bubbles
- Overview: summary graphs; Log: daily entries; Weight: trend line; Settings: preferences

# Non-exhaustive Widget List
- FoodServing: used in the Log and Log Queue screens to display servings of food. containst info on the kind of food, serving size, unit of measure, macros, a stock image
- NutritionTargetsOverviewChart: used in overview_screen to display macros in a visual way
- MiniBarChartPainter: used in the NutritionTargetsOverviewChart to actually display instances of macros

# not yet flushed dealt with
Entities & Data Models	Short summaries of important data types and what fields mean	Food, FoodServing, LoggedFood, WeightEntry
Providers & Responsibilities	Map which providers handle which data and how they relate	LogProvider logs foods; NavigationProvider controls current screen; WeightProvider handles weight data
Future Features (optional)	Document “planned but not yet requested” ideas for later	e.g., social sharing, weekly summaries