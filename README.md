# takeanumberv1

An app that simulates a take a number style of line.

## Getting Started

You will need a working version of Android Studio with an AVD running with an api level of 28 or higher to run this app using this repository. Download the repository and open it within android studio. Select the correct AVD and run this program on it. 


###   Using The App

This application simulates a take a number style of line. 

# Hosting a line:

You must register an account and login before you can start a line. To register, click on the Login button, then in the top roght click on the register icon. The email and password you use are arbitrary (ie. use yourname@test.com for your email address and whatever you would like as your password). 

Once registered and logged in, click on Start a Line. This will create a line in the database and display your the number of your line on the homescreen. Now you can view the current members in your line by clicking on Show Current Members. This will pull up a list of all members in your line in a modal from the bottom of your screen. In this list toggle whether or not it is any given users turn by clocking on each respective member of the list, or you can delete any member by clicking and holding (long press). Back on the user home page you can click delete line, which will double check to make sure and then delete the line and all members in the line from the database.


# Joining a line

To join a line all you need is the line number. From the home page of the application, click Join a Line. You will be directed to a new page pprompting you for a line number. Enter the line number for the store (The same number that is displayed on the user home page screen) and click submit. You will be directed to the waiting page which is initially red. When it is your turn (ie. the user hosting the line notifies the next person its their turn), the waiting screen will turn green and tell you it is your turn.



