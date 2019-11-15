# iOS1

GuidR Proposal

- What problem does your app solve? 
Professional guides can struggle to keep track of the specifics of trips they've guided and their experience. 


- Be as specific as possible; how does your app solve the problem?  

Guidr helps back country guides of all types log their private/professional trips.  Guides will be able to use Guidr to build their Outdoor Resume. Users can login, create read and update their trips with a trip type, location, duration and whether it's private or professional.	

- What is the mission statement? 

Let guides share their experience with the world.


Features

- What features are required for your minimum viable product? 

1. User can sign up as a "Guide" by providing a unique username and a password that will serve as their login/authentication credentials. (mobile, web)
2. User can successfully login as a "Guide" with their login credentials from account creation. (mobile, web)
3. Authenticated "Guide" can access a minimum of two main views:

	- (mobile, web): A "Trips" page where they can:

		1. View a list of previous trips they have created. This should provide an overview of each trip. 
		2. Select a trip from the list and be presented with a detailed view that displays all of the trip's properties.
		3. Create a trip. A "trip" must have at a minimum, the following properties:
			* `title` - String
			* `description` - String
			* `isPrivate` - Boolean
			* `isProfessional` - Boolean
			* an `images` property, type determined by your implementation.
			* `duration` - double
			* `distance` - double
			* `date` - timestamp
			* `tripType` - String or Enum
		4. Update a trip, or any property of a trip.
		5. Delete a trip.

	- (mobile, web): A "Profile" page where they can:
		1. Assign values to profile properties via text fields. At a minimum, a "Profile" must have the following: title, tagline (short description), type of guide specialty), age and years experience.
			* `title` - String
			* `tagline` - String
			* `guideSpecialty` - String
			* `age` - Integer
			* `yearsExperience` - Integer
	
- What features may you wish to put in a future release?

1. Implement remote storage for `images` with an API of your choice - i.e. Cloudinary, CloudKit, etc. (web, mobile)

2. Based on the "duration" of each trip, in hours, aggregate the trip durations and have a widget that displays how many private and professional hours a "Guide" has across their various categories.

3. Implement a feature that allows a "Guide" to send/print their outdoor resume in PDF format to give to potential employers, guide licensing organizations, etc.
	
- What do the top 3 similar apps do for their users?
	

	

Frameworks - Libraries

- What 3rd party frameworks/libraries are you considering using?
	UIKit, CoreData, 
- Do APIs require you to contact its maintainer to gain access?
	No
- Are you required to pay to use the API? No.
	
- Have you considered using Apple Frameworks? (MapKit, Healthkit, ARKit?)


Target Audience

- Who is your target audience? Be specific.

- What feedback have you gotten from potential users? N/A

- Have you validated the problem and your solution with your target audience? How? Nope.

Research

- Research thoroughly before writing a single line of code. Solidify the features of
your app conceptually before implementation. Spend the weekend researching so 
you can hit the ground running on Monday.
Prototype Key Feature(s)

- This is the “bread and butter” of the app, this is what makes your app yours. Calculate how long it takes to implement these features and triple the time estimated. That way you’ll have plenty of time to finish. It is preferred to drop features and spend more time working on your MVP features if needed. 
