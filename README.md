# Closet Conscious
Closet Conscious is a mobile application designed to reduce fashion waste by encouraging users to make the most of their existing wardrobes. By integrating traditional retail, online shopping, and personal closets into a cohesive experience, Closet Conscious aims to make shopping in your virtual closet as fun and engaging as shopping online and in stores.

# Table of Contents
## [Features](#Features)
## [Usage](#Usage)
## [Architecture](#Architecture)

## #Features
### [Virtual Closet Management:](#Virtual_Closet)
Upload, edit, and archive items such as clothing, accessories, and shoes.
### [Outfit Creation:](#Oufit_Creation) 
Mix and match items to create new outfits and receive feedback on your choices.
### [Sustainability Challenges:](#Sustainability_Challenge) 
Participate in challenges like the 90-day no-buy challenge and earn rewards.
### [Social Features:](#Social_Features) 
Share outfits online and organize clothing swap meetups.
### [Premium Features:](#Architecture) 
AI-based outfit suggestions and a feature to 'lock away' clothes for three months.


### #Virtual_Closet
Upload Items: Add items by taking a photo or selecting from your gallery, and fill in the item details.
Edit Items: Update the details of your items as needed.
Archive Items: Move items to the archive if they are no longer in use.

### #Oufit_Creation
Mix and Match: Create outfits by combining different items from your closet.
Daily Feedback: Provide feedback on your outfits to help the app make better suggestions.

### #Sustainability_Challenge
90-Day No-Buy Challenge: Track your progress and earn rewards for not buying new clothes for 90 days.
Tree Rewards: Earn a tree for every five items you upload daily.

### #Social_Features
Share Outfits: Post your outfits on social media directly from the app.
Organize Swaps: Plan and organize clothing swap events with your friends or community.

Architecture
Closet Conscious is built with the following technologies:

Frontend: Flutter
Backend: Supabase
State Management: BLoC
Programming Paradigms: Clean Architecture, Test-Driven Development (TDD), Domain-Driven Design (DDD)
Folder Structure
lua
Copy code
lib/
|-- data/
|   |-- models/
|   |-- repositories/
|-- domain/
|   |-- usecases/
|   |-- entities/
|-- presentation/
|   |-- blocs/
|   |-- screens/
|   |-- widgets/
|-- supabase_config.dart
Contributing
We welcome contributions from the community! Here’s how you can help:

Fork the repository.
Create a new branch (git checkout -b feature/your-feature-name).
Make your changes.
Commit your changes (git commit -m 'Add some feature').
Push to the branch (git push origin feature/your-feature-name).
Open a pull request.
Please ensure your code adheres to our coding standards and includes tests where applicable.

License
This project is licensed under the MIT License. See the LICENSE file for details.

