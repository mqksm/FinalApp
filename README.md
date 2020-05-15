# FinalApp
The final app for the Mobile Computing course

On the main screen is a list of 5 sub-applications that are launched by tapping:

•	Сlient-server application. The application allows you to search for music by artist name, song title, and album name. After entering the request and pressing the "search" button, the cells with the found compositions are displayed on the screen, which include the names of the composition and the album in which this composition is composed.

•	Application for determining location. The application displays on the screen the coordinates of the location of the device in the form of latitude, longitude and altitude, as well as a determined device address.

•	Context application. The application displays on the screen the coordinates of the location of the device in the form of latitude, longitude and altitude, as well as a current position of device on map. As part of the context, a user alert was implemented on arrival on the university campus. When a user arrives at the university, he receives a notification with recommendations to turn off the sound, the background of the application also changes. When a user leaves the university, the application returns the standard background and notifies the user that the phone can be turned on again if it was turned off.

•	Passing the contacts application. The application displays the contacts on the screen and sends them to the server in the form of JSON using the POST request.

•	Energy conservation application. The application displays the generated running applications on the screen in a ranked format. To use the application, user can register and log in or just log in without any credentials as anonym. User credentials are stored on the device. The main screen displays the received data about applications and their power consumption. This data is saved in the local storage of the current user, the contents of which can be seen by pressing the “Storage” button. It is also possible to clear the storage data of the current user by pressing the “Clear” button. Periodically, the application closes, which consumes the most energy. After some time, applications reopen.
