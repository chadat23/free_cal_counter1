# App usage summary

FreeCalCounter is to help people track calories, macros, and weight over time. 

At a high level, eventually, it should be able to do things like track calories, fat, carbs, and protein per meal, day, and week, enable visualizing, easy data entry and editing from sources such as the FDA as well as OpenFoodFacts (OFF). There should be a local db (parsed and pruned from FDA data) to search, a local db of logged foods to expedite reselecting foods, and the ability to reach out to OFF as well. Local stuff should be prioritised since it's faster, but other than that basic workflow divergence, any source should seamlessly integrated. It should also be able to track and visualize a person's weight over time, and to make recommendations regarding macro nutrient targets. While the goal isn't infinite flexibility or to allow any work flow, it needs to be flexible, we always want it to be easy for users to fix input mistakes.

# 1 Screens Overview

## 1.1 Overview: basic summaries of the week's macros. The macros are to be in tables of bar charts as well as some text labels. Additionally, there should be buttons to toggle between showing the consumed macros and the remaining macros.
- 1.1.1 Each column of bar charts represents a day of the current week: Monday through Sunday, and each row represents a macro, one bar chart per day. 
- 1.1.2 There should also be a column of text, to the right of the bar charts, representing the current day's consumed or remaining (depending on button selection) macro amount for each macro as well as the day's target for said macro.
- 1.1.3 The Consumed/Remaining buttons should set a global state so that it'll be persistent even when the screen if left and returned to.
- 1.1.4 The below that should show a Search bar, globe button representing an OpenFoodFacts search, and then a Log button.
- 1.1.5 The Search bar should bring up the Search screen.
- 1.1.6 The OFF button should either do nothing and be there for consistencies sake, or should search for whatever is in the search box, but clicking on the search box to enter text should open the Search screen so there should be anything in the search box so maybe the button should do nothing at that point to avoid empty searches?
- 1.1.7 Below that should be a set of tabs: Overview, Log, Weight, and Settings which should bring the user to the Overview, Log, Weight, and Settings screens respectively.

## 1.2 Log: the person's logged foods. 
- 1.2.1 The top should have a label for the day: a date, "Yesterday", "Today", or "Tomorrow" with simple navigation to move between days.
- 1.2.2 The navigation buttons should let the user switch to see what was logged on any given day by letting the user move one day at a time into the future or past relative to the currently sleected day. It should default to today.
- 1.2.3 There should then be a row of bar charts representing the Consumed or Remaining macros for the selected day based on the global state.
- 1.2.4 Each set of foods that are logged together should have a timestamp above the group (Meal) as well as the total macros for the meal.
- 1.2.5 Each portion of each food item should be in its own little bubble (Slidable Portion Widget which contains a Portion Widget) and should contain the size of the portion, the unit of measure of the portion, the macros of the portion, and the image of the food. The image should be a thumbnail if available, and if not, should default back to the emoji, and only if there's no emoji for the food of the portion, should it fall back to a default emoji.
- 1.2.6 The Slidable Portion Widget combined with the contained Portion Widget should allow deleting, copying, and editing logged items. The Portion Widget should have an always visible edit button on the right side. Sliding the portion to the left should reveal the delete button, and having it work this way means that two actions are needed to help avoid accidental deletions.
- 1.2.7 Long pressing a portion should select it. Clicking elsewhere should unselect it but the particulars of what that mean needs to be sorted out so that it's done in a practical yet intuative way. Once one portion is selected, tapping on additional portions should select them as well. Tapping a selected portion should unselect it. again, if any portions are selected, tapping off of any portion should unselect them all. If any portions are selected, a context sensavive set of buttons should be brought up: Copy, Move, Delete, and Make Recipe. The Copy button should copy the selected portions to the Log Queue, the Move button should move the selected portions to a user specified date and time with the Log, so should update the logged time based on a calendar and time picker that should be presented to the user that should default to the present date and time, the Delete button should delete the selected portions, and the Make Recipe button should open the recipe screen and prepopulate the ingredients with the selected portions.
- 1.2.8 The bottom should show a Search bar, globe button representing an OpenFoodFacts search, and then a Log button.
- 1.2.9 The Search bar should bring up the Search screen.
- 1.2.10 The OFF button should either do nothing and be there for consistencies sake, or should search for whatever is in the search box, but clicking on the search box to enter text should open the Search screen so there shouldn't be anything in the search box so maybe the button should do nothing at that point to avoid empty searches?

## 1.3 Search: shows results from food searches.
- 1.3.1 The top should have a row with an exit button that should bring the user back to the home screen (prompting the user that the Log Queue will be emptied if it isn't already so), a list of images showing what's in the Log Queue, and a down arrow button to navigate to the Log Queue screen.
- 1.3.2 Next are two rows of bar charts, one representing the day's macros (including what's in the Log Queue), one for the Log Queue's macros.
- 1.3.3 Below that are three buttons, a Text based search button, a Barcode based Search, and a Recipe button thus representing the three main forms of food search.
  - 1.3.3.1 The Text based search:
    - 1.3.3.1.1 Defaults to searching the local food databases.
    - 1.3.3.1.2 The OFF button can be used for additional data options. Pressing it should perform an OFF search for the text that's in the Search bar.
    - 1.3.3.1.3 Search results are to be color coded based on the original source of the data (USDA Foundation Foods, USDA SR Foods, OFF Foods, user entered, Recipe). That said, since once a portion is logged that refers to a food, said food needs to be added to the logged foods table (that's not exactly what it's called but...), so there simultaniously needs to be a way to distinguish previously logged vs not logged foods. Perhaps different versions of each color, darker ones for previously logged foods, and lighter ones for unlogged foods.
    - 1.3.3.1.4 For each food, there should be an icon/image, the name, a dropdown of proposed portion units and sizes, and the macros for the currently selected portion, as well as an add button.
    - 1.3.3.1.5 Selecting the add button should add the current portion to the Log Queue.
    - 1.3.3.1.6 Selecting other parts of a search result should bring up the Serving Edit screen.
    - 1.3.3.1.7 Kind of like with the Slidable Portion Widgets, the search results should be slidable, so there should be a Slidable Search Result Widget that wraps a Search Result Widget. 
      - 1.3.3.1.7.1 The previous functionality can all be handled by the Search Result Widget, but that should be a child widget of the Slidable Search Result Widget.
      - 1.3.3.1.7.2 Sliding the search result to the left should reveal the delete button, and having it work this way means that two actions are needed to help avoid accidental deletions.
        - 1.3.3.1.7.2.1 Sliding the search result to the right should reveal the Edit and Copy buttons.
          - 1.3.3.1.7.2.1.1 The Edit button needs to bring up a yet to be implimented (or at least flushed out) Food Edit Screen that lets the user modify an existing food.
            - 1.3.3.1.7.2.1.1.1 If the search result is from the reference db, then at least uppon submitting/entering the edit, the food needs to be copied to the live db logged_foods table with all of the user viewed data copied over (other than whatever the user changes via the edit screen) with all other stuff being updated as needed to maintain overarching app functionality (so it probably shouldn't have a parent).
            - 1.3.3.1.7.2.1.1.2 If the parent food is in the referenece db, then ideally, since foods point to the parent's id, the source data from the reference db would be able to be filitered out of search results. This is low priority and can be done later, especially if there aren't clear and high confidence ways to achieve this.
            - 1.3.3.1.7.2.1.1.3 In cases where the parent is also in the logged_foods table, all parents should be recursively filtered out of the search results so only the newest version of the food will be shown. This will yield unfindable foods; this may bring about future features.
            - 1.3.3.1.7.2.1.1.4 By doing this we won't break old logs, yet we'll be able to update future search results.
          - 1.3.3.1.7.2.1.2 The Copy button should work about like the edit button, only a coppied item seemingly won't have a parent.
            - 1.3.3.1.7.2.1.2.1 So unlike with the edit button, whatever its data's being copied from, won't be filtered out of the search results.
            - 1.3.3.1.7.2.1.2.2 When the Edit Food Screen opens, the food name should be the same as the source food, only with " - Copy" appended to the end of it.
        - 1.3.3.1.7.2.2 In theory, from the user's perspective, the Delete button will delete foods.
          - 1.3.3.1.7.2.2.1 Since the reference db is read only, if the user tries to delete a search result from the reference db, the user should be susinctly be promped to let them know that the food can't be deleted and why.
          - 1.3.3.1.7.2.2.2 If the search result that's to be deleted is from the logged_foods table, and isn't referenced by anything (presumably just portions or recipies), then it can be deleted.
          - 1.3.3.1.7.2.2.3 If the search result that's to be deleted is from the logged_foods table, and is referenced by something (presumably just portions or recipies), then it can't be deleted, so some sort of flag needs to be set in the food so that it's filtered from future search results without breaking old logged portions or recipies.
  - 1.3.3.2 The Barcode search isn't to be worried about for now.
  - 1.3.3.3 The Recipe Search button is next.
    - 1.3.3.3.1 Below the row of 3 buttons (text search, barcode search, and recipe search) should be a Create New Recipe button to bring the user to the Edit Recipe Screen.
    - 1.3.3.3.2 Adjascent to the Create New Recipe button should be a dropdown to let the user select what Category of recipe they want to search.
    - 1.3.3.3.3 Below that should be the returned list of recipes.
      - 1.3.3.3.3.1 When the pace is initially loaded, when no search tearm has yet been entered, it should default to showing all of the latest versions of recipes, so if a recipe has been saved a number of times, only the latest version should be shown.
      - 1.3.3.3.3.2 Entering a search term at the bottom of the page should search recipies, not foods, and I suppose the OFF button shouldn't do anything since it doesn't seem like that'd make sense.
      - 1.3.3.3.3.3 Much like with the text based search, the results should be displayed in the Search Result Widget, and the Slidable Search Result Widget, but maybe the Slidable Search Widget needs a flag and configurability, or maybe it needs to be a different widget.
        - 1.3.3.3.3.3.1 Like with search results, sliding a recipe to the left should reviel a delete button, but like with the text based search results, in order to ensure data integrity, it should hide the recipe if it's ever been logged or added to another recipe as an ingredient.
        - 1.3.3.3.3.3.2 Sliding the recipe to the right should reveal the Edit, Copy, and Dump buttons.
          - 1.3.3.3.3.3.2.1 The Edit button should bring the user to the Edit Recipe Screen, where, again like with the logged_foods table, in order to ensure data integrity, if the current version of the recipe has ever been logged or used as an ingrediant in another recipe, it needs to be duplicated and then the user should be able to edit the copy. This should seemlessly be done behind the sceens because the user doesn't need to know how this works. Additionally, the new version of the recipe needs to have it's parent Id set so that old versions of it can be filtered out of search results. However, if the current version of the recipe has never been logged or added as in ingrediant to another recipe, it can be updated in place since that won't change any past logs. Any past logged items that point to the recipe should be left to refer to the old version, but the new version should be used for any future logs.
          - 1.3.3.3.3.3.2.2 The Copy button should bring the user to the Edit Recipe Screen, where it should look/behave about like what the Edit button does, only with " - Copy" appended to the end of the new recipe's name. However, since we're copying the recipe, we're creating a new one rather than replacing an old one in search results so we'll leave the paren Id blank, always create a new entry, never update an old one, and not worry about filtering out old versions since it has no parent.
          - 1.3.3.3.3.3.2.3 The Dump button should dump one serving's worth of ingrediants into the Log Queue. The idea is that, while, for instance, if you were making a cookie recipe, you'd never make one cookie or only eat most of the ingrediants, but you might, for instance, have a standard dinner salad recipe that you work from most nights, but where, unlike the cookie recipie, instead of making it exactly the same every time, each night will be a little different depending on what's on hand. So the user may create a generic Dinner Salad recipe, and then when making it, hit the Dump button to avoid having to add each individual ingredient/portion to the Log Queue, then they can switch over to the Log Queue, delete anything that they're not having that night, and update portion amounts/units for the remaining ingrediants/portions. Also, there's to be an option to set in the Edit Recipe Screen to set that the recipe is only Dumpable (this will avoid accidently adding the recipe as is and which would inhibit the ability to edit the recipe in place (with the salad recipe example, the recipe may be updated frequently depending on what's in season and ensuring that it's always dumped ensures that the user doesn't end up with a bunch of versions of it in the db)). If the recipe is only dumpable then hitting the plus button should dump the recipe into the Log Queue and tapping the recipe (such as to bring up the Portion Edit Screen) should prompt the user that that isn't an option since the recipe is only dumpable.
        - 1.3.3.3.3.3.3 The plus button should add one portion (as specified by the dropdown of the Search Result Widget) to the Log Queue.
        - 1.3.3.3.3.3.4 Tapping elsewhere on the widget should bring up the Portion Edit Screen so that the user can enter the exact Amount and Unit of recipe that they're having.
- 1.3.5 Selecing the Log button should log the Log Queue to the LoggedPortions tabe in the db and then navigate the user back to the Overview screen.

## 1.4 Portion Edit: a place for a user to be able to edit how much of a particular food was eaton
- 1.4.1 The top left is to have a back button that brings the user back to wherever they navigated to the Portion edit screen from (presumably the Search Screen, Log Screen, or Log Queue Screen) without making any changes.
- 1.4.2 Should have two rows of macros: the day's macro including the current proposed portion, and then the portion's macros. Both should update in real time.
- 1.4.3 If it's going to update a portion that's already been logged or added to the Log Queue, the day's macros should be day's logged macros - old version of the portion + new version of the portion. Otherwise the day's macros should be the day's logged macros + the portion's macros.
- 1.4.4 There should be a user editable Amount, so how many units or macros depending on what unit/target is selected of the food are in the portion
- 1.4.5 There should also be a user editable Unit, the list of all of the units of measure that are available for the current food item, eg. grams, cups, Apples, etc. 
- 1.4.6 Next should be a row of target buttons (this isn't means to be the label, just a brainstormed idea of what the concept is), so what we're trying to accomplish. They should be "Unit" (the default), Calories, Carbs, Protein, and Fat.
  - 1.4.6.1 If the target is Unit, then the user is saying that the Amount is whatever unit they entered from 1.4.5, and that's how much they're having.
  - 1.4.6.2 If the target is something else, then the foods macro values should be used to calculate the number of grams of said food that are required in order to achieve the target number of calories, carbs, protein, or fat.
- 1.4.7 Below the targets from 1.4.6 should be an output showing how many grams of said food are required in order to achieve the target amount of whatever the target is.
  - 1.4.7.1 If g is selected unit, and the target is Unit, and the Amount is 125, the the output should be 125.
  - 1.4.7.2 If the target is calories, and the Amount is 200, then the output should be the number of grams of said food that are required in order to achieve 200 calories.
  - 1.4.7.3 If the selected unit is Apple, and the target is Unit, the Amount is 2.5, and each apple is 120g, then the output should be 300.
  - 1.4.7.4 All of the math associated with all of this (the calculated number of grams), as well as updates to the day's and portion's macros should happen in real time.
- 1.4.8 The Cancel button should bring the user back to where they just were, so the Log, Log Queue, or Search screen without making any changes.
- 1.4.9 The Add button should add the portion to the Log Queue if the user navigated to the Edit screen from the Search Screen, update the portion in the Log if the user was navigated to the Edit Screen from the Log screen, or update the portion in the Log Queue if the user navigated to the Edit Screen from the Log Queue screen.
- 1.4.10 Presently, the Add button always says "Add", but ideally it would say "Update" if the user is updating a portion. This if this is a practical change then it should be implimented, but if it's too complicated then it shouldn't. 

## 1.5 Log Queue: A screen for viewing in process loggin activaties, what and how much food is being proposed to have been eaton.
- 1.5.1 The top should have a row with an exit button that should bring the user back to the home screen (prompting the user that the Log Queue will be emptied if it isn't already so), a list of images showing what's in the Log Queue, and then an up arrow button to navigate to the Search screen.
- 1.5.2 Next should be two rows of macros: the day's expected macro including the current proposed portion, and then the portion's macros. Both should update in real time.
- 1.5.3 Then should be a list of food bubbles, each with an image, name, amount, unit, and macros.
- 1.5.4 There should be an edit button that brings the user to the Portion Edit screen so that it can be edited.
- 1.5.5 Sliding the portion to the left should reveal the delete button. 
  - 1.5.5.1 Clicking the delete button should delete the portion from the Log Queue
  - 1.5.5.2 Clicking on the slid portion somewhere other than the delete button should slide the portion back to its nominal position.
  - 1.5.5.3 This is achieved by having the text, iamge, macros, and edit button in the Portion Widget, and having that wraped in a parent Slidable Portion Widget that handles the sliding stuff as well as the delete button and subsiquent functionality.
- 1.5.6 The bottom has the standard Search bar, OFF button, and Log button.
- 1.5.7 Clicking the Log button will commit the Log Queue to the LoggedPortion table and then bring the user back to the Overview screen.
- 1.5.8 When the Log Queue is logged, everything in the log queue should receive the same, current, time as the timestamp for when the portions were logged, that said, said time should be passed into the logging function since that's what allows moving portions, editing their logged time.

## 1.6 Ingrediant Edit: a place for a user to be able to edit how much of a ingrediant is in a recipe.
- 1.6.1 The top left corner is to have a back button that brings the user back to the recipe screen without making any changes.
- 1.6.2 Should have two rows of macros: the recipe's macro including the current proposed ingrediant, and then the ingrediant's macros. Both should update in real time.
- 1.6.3 If it's going to update an ingrediant that's already been added to the recipe, the recipe's macros should be recipe's macros - old version of the ingrediant + new version of the ingrediant. When adding new ingrediants, the recipe's macros should be the recipe's macros + the ingrediant's macros.
- 1.6.4 Below the two rows of macros should be two toggle buttons, Total and Per Serving.
  - 1.6.4.1 When Total is selected, the Recipe's Macros bar charts should be the macros for the sum of all of the recipe's ingredients, and the Ingredient's Macros are simply for the macros of Amounts Units of the ingredient.
  - 1.6.4.2 When Per Serving is selected, the bar charts are to represent one serving's worth of the recipe, so if the total ingredients of the recipe are to have 1500 calories, and it makes 5 servings, then when Per Serving is selecting, the Recipe's Macros bar charts should be 300 calories and the Ingredient's Macros should be 1/5th of the number of calories in Amount Units of the ingredient.
  - 1.6.4.3 The Amount always represents the total amount of said ingredient to be added to the recipe so the Total Per Serving selection has no impact on what the user is to actually ad to the bowl, pan, etc. 
- 1.6.5 There should be a user editable Amount, so how many units or macros of the food are in the ingredient depending on what unit or target is selected.
- 1.6.6 There should also be a user editable Unit, the list of all of the units of measure that are available for the current food item, eg. grams, cups, Apples, etc. 
- 1.6.7 Next should be a row of target buttons (this isn't means to be the label, just a brainstormed idea of what the concept is), so what we're trying to accomplish. They should be "Unit" (the default), Calories, Carbs, Protein, and Fat.
  - 1.6.7.1 If the target is Unit, then the user is saying that the Amount is whatever unit they entered from 1.6.6, and that's how much they're having.
  - 1.6.7.2 If the target is something else, then the foods macro values should be used to calculate the number of grams of said food that are required in order to achieve Amount number of calories, carbs, protein, or fat.
- 1.6.8 Below the targets from 1.6.7 should be an output showing how many grams of said food are required in order to achieve the target amount of whatever the target is.
  - 1.6.8.1 If g is the selected unit, and the target is Unit, and the Amount is 125, then the output should be 125 since it takes 125g of said food to have 125g of said food.
  - 1.6.8.2 If the target is calories, and the Amount is 200, then the output should be the number of grams of said food that are required in order to achieve 200 calories.
  - 1.6.8.3 If the selected unit is Apple, and the target is Unit, the Amount is 2.5, and each apple is 120g, then the output should be 300 since in this example 2.5 apples weigh 300g.
  - 1.6.8.4 All of the math associated with all of this (the calculated number of grams), as well as updates to the day's and portion's macros should happen in real time.
- 1.6.9 The Cancel button should bring the user back to Recipe Edit screen without adding the ingredient if it hadn't previously been added, and without updating it if it had.
- 1.6.10 The Update button should add the ingreiant to the recipe if the user navigated to the Ingrediant Edit screen by clicking to add an ingredient on the Edit Recipe Screen, and should update the existing ingrediant on the recipe if the user navigated to the Ingrediant Edit screen by clicking to edit an already present ingredient on the Edit Recipe Screen. The inconsistancy in text on the Update button (how it always says Update even though it's sometimes adding (such as when the screen was reach via the Edit Recipe Add Ingrediant button)) would ideally be fixed but is a very low preiority so if doing so reacy almost any complication or technical risk it should be avoided for the forseable future.

## 1.7 Recipe Edit: a screen for editing and creating recipes
- 1.7.1 The top row of the screen should have a back button that'll bring the user back to the Search Screen, the recipe name (if its previously been saved), and a save button that'll save the recipe. If there are unsaved changes, if the user hits the back button, they should get a susynct message asking if they want to discard unsaved changes.
- 1.7.2 Next down should be a place for the user to enter a recipe name
- 1.7.3 Next should be a row to 

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
- On the Search Screen, in addition to the 3 kinds of searches, maybe that's where it'd make sense to have an Add Food button.
