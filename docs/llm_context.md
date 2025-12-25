# App usage summary

FreeCal Counter is to help people track calories, macros, and weight over time. 

At a high level, eventually, it should be able to do things like track calories, fat, carbs, and protein per meal, day, and week, enable visualizing, easy data entry and editing from sources such as the FDA as well as OpenFoodFacts (OFF). There should be a local db (perced and pruined from FDA data) to search, a local db of logged foods to expidite reselecting foods, and the ability to reach out to OFF as well. Local stuff should be prioritised since it's faster, but other than that basic workflow divergence, any source should seemlessly integrated. It should also be able to track and visualize a person's weight over time, and to make recomendations regarding macro nutrient targets. While the goal isn't infinite flexibility or to allow any work flow, it needs to be flexible, we always want it to be easy for users to fix input mistakes.

# Screens Overview

## Overview: basic summeries of the week's macros. The macros are to be in tables of bar charts as well as some labels. Additionally, there should be buttons to toggle between showing the consumed macros and the remaining macros.
- Each column of bar charts represents a day of the current week: Monday through Sunday, and each row represents a macro. 
- There should also be a column of text representing the current day's consumed or remaining (depending on button selection) macro amount as well as the day's target.
- The Consumed/Remaining buttons should set a global state so that it'll be persistant even when the screen if left and returned to.

## Log: the person's logged foods. 
- The top should have a label for the day: a date, "Yesterday", "Today", or "Tomorrow" with simple navigation to move between days.
- There should then be a row of bar charts representing the Consumed or Remaining macros for the selected day based on the global state.
- Each set of foods that are logged together should have a timestamp above the group (Meal) as well as the total macros for the meal.
- Each serving of each food item should be in its own little bubble and should contain the size of the serving, the units of measure of the serving, the macros of the serving, and the image of the food. The image should be a thumbnail if available, and if not, should default back to the emoji, and only if there's no emoji for the food of the portion, should it go back to a default emoji.
- Should let the user switch to see what was logged on any given day via the top navigation. 
- Should allow deleting, copying, and editing logged items. This is to be achieved by sliding the portion to the left to reveal the three buttons: edit, copy, and delete
- The bottom should show a Search bar, globe button representing an OpenFoodFacts search, and then a Log button.

## Search: shows results from food searches.
- The top should have a row with an exit button that should bring the user back to the home screen (prompting the user that the Log Queue will be emptied if it isn't already so), a list of images showing what's in the Log Queue, and then a button to navigate to the Log Queue screen.
- Next down are two rows of bar charts, one representing the forcasted day's macros, one for the Log Queue's macros.
- Below that are three buttons, a Text based search button, a Barcode based Search, and a Recipe button representing the three main forms of search.
- The Text based search defaults to searching the local food database.
- The OFF button can be used for aditional data options.
- Search results are to be color coded based on the source of the data (USDA Foundation Foods, USDA SR Foods, OFF Foods, Recipe)
- For each food, there should be an icon/image, the name, a dropdown of proposed portion sizes, and the macros for the currently selected portion, as well as an add button.
- Selecting the add button should add the current portion to the Log Queue.
- Selecting other parts of a search result should bring up the Serving Edit screen.
- Selecing the Log button should log the Log Queue to the LoggedPortions tabe in the db and then navigate the user back to the Overview screen.

## Portion Edit:
- Should have two rows of macros: the day's expected macro including the current proposed portion, and then the portion's macros. Both should update in real time.
- If it's being to update a portion that's already been logged or added to the Log Queue, the day's macros should be day's macros - old version of the portion + new version of the portion.
- There should be the Amount, so how many units of the food are in the portion
- There should also be the Unit, the list of all of the units of measure that are available for the current food item, eg. grams, cups, Apples, etc. 
- The Cancel button should bring the user back to where they just were, so the Log, Log Queue, or Search screen.
- The Add button should add the portion to the Log Queue if the user was just at the Search screen or update the portion if the user was updating a food from the Log or Log Queue screen.

## Log Queue:
- The top should have a row with an exit button that should bring the user back to the home screen (prompting the user that the Log Queue will be emptied if it isn't already so), a list of images showing what's in the Log Queue, and then a button to navigate to the Search screen.
- Should have two rows of macros: the day's expected macro including the current proposed portion, and then the portion's macros. Both should update in real time.
- Then should be a list of food bubbles, each with an image, name, amount, unit, and macros.
- There should be an edit button that brings the user to the Portion Edit screen so that it can be edited.
- Sliding the portion to the left reveal the delete button. Clicking the user should delete the portion from the Log Queue, clicking on the slid portion somewhere other than the delete button should slide the portion back to its nominal position.
- The bottom has the standard Search bar, OFF button, and Log button.
- Clicking the Log button will commit the Log Queue to the LoggedPortion table and then bring the user back to the Overview screen.

## Log Queue: same basic thing as the Log, only its a staging area between food entry and the log so it'll be a list of food bubbles

## Overview: summary graphs; Log: daily entries; Weight: trend line; Settings: preferences

# Data Persistance: logic behind editing, copying and deleting foods and recipes

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
  

# Non-exhaustive Widget List
- FoodServing: used in the Log and Log Queue screens to display servings of food. containst info on the kind of food, serving size, unit of measure, macros, a stock image
- NutritionTargetsOverviewChart: used in overview_screen to display macros in a visual way
- MiniBarChartPainter: used in the NutritionTargetsOverviewChart to actually display instances of macros

# not yet flushed dealt with
Entities & Data Models	Short summaries of important data types and what fields mean	Food, FoodServing, LoggedFood, WeightEntry
Providers & Responsibilities	Map which providers handle which data and how they relate	LogProvider logs foods; NavigationProvider controls current screen; WeightProvider handles weight data
Future Features (optional)	Document “planned but not yet requested” ideas for later	e.g., social sharing, weekly summaries

# Notes, Quirks, and Idosyncrasies
- The Portion Edit screen always has and Add button, but in two of it's 3 use-cases, it's updating, not adding