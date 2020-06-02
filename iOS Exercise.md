# Klarna iOS Home Assignment
This assignment is to be performed at home, the estimated time to complete it is one hour.
The assignment is broken down into two steps, where the second step is a continuation which is performed as a follow-up interview.

## Assignment

Create a simple one-view controller app which displays the weather for the users' location. 

### Design and Architecture
There is no big emphasis on visual design, but thought should be taken into account regarding overall architecture (ie. whether you're using Storyboards/Inteface Builder or not, whether you use MVVC, MVVM, etc.).

Similarly, there are no requirements as to what architecture you should choose, but we recommend you choose the architecture you're most comfortable with. 

### Third-party Libraries
Use of third-party libraries (e.g. Carthage/Cocoapods/SwiftPM) should be kept to a minimum, to make it easy for us to build and run your project – but if you include any, provide a readme with instructions to how to build and run it.

### Delivery
Once finished, deliver the result of the assignment either as project available on an open-source hosting provider such as GitHub or Bitbucket or as a zip file of the entire project.

## Continuation (Follow-up Interview)
During the interview, we'll ask you to make some changes to your application. To save time, we recommend that you prepare for this.

### If the Interview is Remote
If the interview is through Google Hangouts/Meet, we recommend that you have Chrome and your IDE of choice installed. Make also sure that your project runs. 

### If the Interview is On-site
If the interview is at our offices in Stockholm, you can either bring your own computer or we can provide one for the interview.


## Weather API
To access the weather, you can use the following API:

```http
https://api.darksky.net/forecast/2bb07c3bece89caf533ac9a5d23d8417/latitude,longitude
````

Example to retrieve the weather for Klarna's HQ:

```http
https://api.darksky.net/forecast/2bb07c3bece89caf533ac9a5d23d8417/59.337239,18.062381
````
Which will return with the following JSON:
````json
{
    "latitude": 59.3310373,
    "longitude": 18.0706638,
    "timezone": "Europe/Stockholm",
    "currently": {
        "time": 1537882620,
        "summary": "Clear",
        "icon": "clear-day",
        "precipIntensity": 0,
        "precipProbability": 0,
        "temperature": 40.46,
        "apparentTemperature": 33.75,
        "dewPoint": 29.59,
        "humidity": 0.65,
        "pressure": 1025.41,
        "windSpeed": 11.15,
        "windGust": 21.55,
        "windBearing": 295,
        "cloudCover": 0.03,
        "uvIndex": 0,
        "visibility": 8.32,
        "ozone": 321.6
    }
}
````

*Note*: Some fields in the JSON might not exist, you might want to perform checks to avoid potential crashes.