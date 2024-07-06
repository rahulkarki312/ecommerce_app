# Shoesly App

## Project Overview

Welcome to the Shoesly App repository! This Flutter-based mobile application allows users to browse and shop for shoes, leveraging Firebase for backend services. Below you'll find instructions on setting up the project, assumptions made during development, challenges faced, and additional features included.


## Prerequisites
1. **Flutter SDK**: Make sure you have the Flutter SDK installed on your system. You can download it from the [official Flutter website](https://flutter.dev/docs/get-started/install).
2. **Git**: Ensure you have Git installed. You can download it from the [official Git website](https://git-scm.com/downloads).
3. **Code Editor**: Have a code editor installed, such as Visual Studio Code or Android Studio.

## Project Setup Instructions

1. **Clone the repository**:

   ```bash
   git clone https://github.com/rahulkarki312/ecommerce_app.git
   cd ecommerce_app

2.  **Install Dependencies**:
    ```bash
    flutter pub get
    
3.  **Run The App**
    ```bash
    flutter run

## Challenges Faced and Solutions

1. **Deploying Firebase Cloud Functions**:
   - **Challenge**: Encountered issues with deploying Firebase Cloud Functions due to permission errors and configuration issues.
   - **Solution**: Resolved these by ensuring proper setup of Firebase CLI, adjusting necessary permissions, and carefully following deployment steps as outlined in the Firebase documentation.

2. **UI Constraints**:
   - **Challenge**: Faced difficulties in maintaining a consistent and responsive UI across various screen sizes and orientations.
   - **Solution**: Used Flutter’s layout widgets such as `Flexible`, `Expanded`, and `MediaQuery` to create adaptive layouts. Conducted extensive testing on different devices to ensure a seamless user experience.

3. **Firebase Integration**:
   - **Challenge**: Managing asynchronous operations and real-time updates with Firebase required careful handling of data streams and listeners.
   - **Solution**: Implemented robust state management and used `FutureBuilder` and Provider widgets to handle real-time data updates efficiently.

4. **Error Handling**:
   - **Challenge**: Implementing robust error handling for network requests and Firebase interactions.
   - **Solution**: Added comprehensive error handling and user feedback mechanisms to ensure a smooth user experience even when issues occur.

5. **Performance Optimization**:
   - **Challenge**: Ensuring smooth performance and responsiveness of the app, especially when dealing with a large amount of data.
   - **Solution**: Optimized data fetching and rendering processes, utilized caching where possible, and minimized the use of expensive operations in the UI thread.


## Additional Features and Improvements

1. **User Authentication**:
   - **Feature**: Implemented secure user authentication using Firebase Authentication.
   - **Details**: Allows users to sign up, log in, and manage their accounts securely. Authentication tokens are used to ensure that only authenticated users can get access to the data resource.

2. **Write a Review as the Current User**:
   - **Feature**: Enabled users to write and submit reviews for products.
   - **Details**: Users can submit their reviews and ratings, which are stored in Firebase. The app computes and displays the average rating for each product based on all submitted reviews using Firebase Cloud Functions.

3. **Orders Storage After Checking Out**:
   - **Feature**: Implemented order storage to keep track of user purchases.
   - **Details**: After a user completes the checkout process, their order details are stored in Firebase. This includes the items purchased, quantities, prices, and the total amount. This ensures that order history is maintained for future reference and management.
