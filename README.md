# Flicker-Search-Upload
A Flicker Search app to search photos of a category and upload new pictures from camera roll

The purpose of this SwiftUI project is to give the user the ability to do the following: 

1. Sign in using UserName/Password. OR
2. Sign in using Google Sign in. OR
3. Sign in using Apple Sign in.
4. Sign up for Username/Password style is available. 
5. After signing in, the User gets two tabs to choose from.
6. User can search huge number images from keyword he types in the first tab.
7. User can see the popular keyword searches in the Home page. Clicking on it will automatically search images. 
8. The images scrolling supports lazy loading of images and paging. 
9. If images are not found error message is shown.
10. In the Second tab, the user can upload image from Camera roll.
11. User can select image from Camera roll and upload the same image to his/her Flickr account.
12. After successful upload a success animation is shown.

The architecture followed is MVVM. I have used Firebase Authentication for Sign Up and Sign in functionality. Views are designed by native Swift UI components. Navigation is provided by NavigationStack. Viewmodel has all the business logic for the corresponding views. 



https://github.com/rohitbr/Flicker-Search-Upload/assets/1514130/9ab116bf-5a25-4161-a1b3-c96abe593b46

