# Collide App - Complete Project Overview

## 🎯 **App Concept**
**Collide** is a dating/social app for college students (similar to Tinder/Bumble). The tagline is "This app is basically Jim looking at Pam" - a reference to finding connections like in The Office.

---

## 📱 **Basic Workflow**

### **1. App Launch Flow**
```
App Start (collideApp.swift)
    ↓
Check onboardingComplete flag
    ↓
┌─────────────────┬─────────────────┐
│   FALSE         │      TRUE        │
│   ↓             │      ↓           │
│ OnboardingView  │   NavBar         │
│ (Auth Flow)     │   (Main App)     │
└─────────────────┴─────────────────┘
```

### **2. Onboarding Flow** (Multi-step registration)
```
OnboardingView (Welcome Screen)
    ↓
LoginView (Choose auth method)
    ↓
┌──────────────┬──────────────┬──────────────┐
│ Phone Auth   │ Email Auth   │ Social Auth  │
│ ↓            │ ↓            │ (Google/Apple)│
│ PhoneInput   │ EmailLogin   │ ↓            │
│ ↓            │ ↓            │ nextView     │
│ OTPInput     │ PersonalDetails│            │
└──────────────┴──────────────┴──────────────┘
    ↓
PersonalDetailsView (Name, DOB, Gender, Pronouns)
    ↓
PreferencesView (Looking for, Interested in)
    ↓
CollegeView (College name, student email, location)
    ↓
PhotosView (Upload up to 6 photos)
    ↓
BioInterestsView (Bio + Select at least 5 interests)
    ↓
FunQuestionsView (Answer fun questions)
    ↓
FinalScreenView (Profile preview + "Let's Collide" button)
    ↓
Set onboardingComplete = true → Navigate to NavBar
```

### **3. Main App Flow** (After Onboarding)
```
NavBar (TabView with 5 tabs)
    ├── Messages (Tab 0) - 💬 Chat screen (placeholder)
    ├── Events (Tab 1) - 🎉 Events screen (placeholder)
    ├── Home (Tab 2) - 🏠 Main swiping interface (ACTIVE)
    ├── Details (Tab 3) - ❤️ User detail view (mock data)
    └── Profile (Tab 4) - 👤 User's own profile (mock data)
```

### **4. Home Screen (Swipe Interface)**
```
Home View
    ↓
Fetch users from Supabase
    ↓
Display UserCard stack (up to 5 cards)
    ↓
User swipes left/right
    ↓
Card removed from stack
    ↓
Tap card → Navigate to UserCardDetail
```

---

## 📁 **File Structure & Purpose**

### **Root Files**
- **`collideApp.swift`** - Main app entry point
  - Creates `AuthViewModel` instance
  - Routes to `OnboardingView` or `NavBar` based on `onboardingComplete` flag

### **Data Layer**
- **`data/UserDataModel.swift`** - Core data models
  - `UserModel`: Main user structure (id, name, avatar, age, gender, bio, college, verified, etc.)
  - `Photo`: User photos (id, userId, photoUrl)
  - `Interest`: User interests (id, name)
  - `Swipe`: Swipe history (id, swiperId, swipeeId, direction, timestamp)
  - `Match`: Matched users (id, user1Id, user2Id, matchedOn, user1, user2)
  - `Review`: User reviews (id, reviewerId, reviewedId, reviewText, rating, createdAt)

### **Networking Layer**
- **`Networking/SupabaseManager.swift`** - Singleton Supabase client manager
  - Initializes Supabase client with URL and API key
  - URL: `https://elxkzdrcyloubqhwiuuu.supabase.co`
  
- **`Networking/SupabaseService.swift`** - API service layer
  - `fetchAllUsers()`: Fetches all users with photos from `users` table
  - `fetchMatches(for userId:)`: Fetches matches for a user from `matches` table
  
- **`Networking/AppError.swift`** - Error handling enum
  - Custom error types with user-friendly messages and SF Symbols
  - Error types: invalidURL, noData, decodingError, serverError, noInternet, timeout, underlying, custom

### **View Models**
- **`View Models/HomeViewModel.swift`** - Home screen state management
  - `@Published var users: [UserModel]` - List of users to display
  - `@Published var errorMessage: String?` - Error state
  - `@Published var errorIcon: String` - Error icon name
  - `fetchUsers()` - Calls SupabaseService to load users

- **`Views/Onboarding/ViewModels/AuthViewModel.swift`** - Onboarding/auth state management
  - **Auth State:**
    - `currentView: CurrentView` - Current onboarding step
    - `onboardingComplete: Bool` - Persisted in UserDefaults
    - `errorMessage: String?` - Error display
  
  - **User Input Fields:**
    - `phoneNumber: String` - Phone number (10 digits)
    - `otp: String` - OTP code (6 digits)
    - `email: String` - Email address
    - `password: String` - Password
    - `name: String` - Full name
    - `dob: Date` - Date of birth
    - `gender: String` - Selected gender
    - `pronouns: String` - Selected pronouns
    - `interestedIn: String` - Dating preferences
    - `lookingFor: String` - Relationship type
    - `collegeName: String` - College name
    - `studentEmail: String` - Student email address
    - `location: String` - Location
    - `selectedImages: [UIImage?]` - Up to 6 photos
    - `bio: String` - User bio
    - `selectedInterests: Set<String>` - Selected interests
    - `allInterests: [Interest]` - Available interests
    - `funQuestionAnswers: [String: String]` - Fun question responses
  
  - **Methods:**
    - `signInWithEmail()` - Supabase email sign-in
    - `signUpWithEmail()` - Supabase email sign-up
    - `processPhoneKeypad()` - Handle phone input
    - `processOTPKeypad()` - Handle OTP input
    - `toggleInterest()` - Select/deselect interests
    - `isContinueEnabled()` - Validation for continue buttons

### **Views - Main App**
- **`Views/NavBar.swift`** - Main tab navigation
  - TabView with 5 tabs: Messages, Events, Home, Details, Profile
  - Default tab: Home (tag 2)

- **`Views/Home/Home.swift`** - Main swiping interface
  - Fetches users on appear
  - Displays stack of UserCard components
  - Error handling with retry
  - Empty state when no users
  - Navigation to UserCardDetail on tap

- **`Views/Home/UserCard.swift`** - Swipeable user card
  - Drag gesture for left/right swipe
  - Displays user photo, name, age, college, verification badge
  - Removes card when swiped beyond threshold (120 points)
  - Animation and rotation effects

- **`Views/Home/UserCardDetail.swift`** - User detail view
  - Full-screen user profile
  - Photo gallery (currently shows placeholder images)
  - User info: name, age, college, bio, verification status
  - Navigation back button

- **`Views/Home/SizeConstants.swift`** - Size constants (if exists)
- **`Views/Home/SwipeIndicator.swift`** - Swipe UI indicators (if exists)

- **`Views/Matches/Matches.swift`** - Matches screen (PLACEHOLDER)
  - Currently just displays "❤️ Matches Screen"

- **`Views/Messages/Messages.swift`** - Messages screen (PLACEHOLDER)
  - Displays "💬 Messages Screen"
  - Has debug button to reset onboarding

- **`Views/Events/Events.swift`** - Events screen (PLACEHOLDER)
  - Displays "🎉 Events Screen"

- **`Views/Profile/Profile.swift`** - User profile view
  - Displays user avatar, name, age, verification
  - College badge
  - Bio section
  - Photo gallery (horizontal scroll)
  - Currently uses mock data

- **`Views/CachedImageView.swift`** - Image caching utility
  - `CachedAsyncImage` component
  - Uses URLCache for image caching
  - Shows loading state while fetching

### **Views - Onboarding**
- **`Views/Onboarding/OnboardingView.swift`** - Welcome screen
  - Shows app logo/image
  - "Welcome to Collide" message
  - "Get Started" button opens tray

- **`Views/Onboarding/TrayContentView.swift`** - Container for onboarding steps
  - Switches between different views based on `currentView`
  - Views: login, phone, email, otp, personalDetails, genders, preferences, college, photos, BioInterests, funQuestions, finalScreen

- **`Views/Onboarding/LoginView.swift`** - Auth method selection
  - Buttons: Phone, Email, Google, Apple
  - Routes to respective auth flows

- **`Views/Onboarding/PhoneInputView.swift`** - Phone number input
  - Custom keypad interface
  - 10-digit phone number validation

- **`Views/Onboarding/OTPInputView.swift`** - OTP verification
  - 6-digit OTP input
  - Custom keypad

- **`Views/Onboarding/EmailLoginView.swift`** - Email authentication
  - Email text field
  - Password field (shown after email entered)
  - Sign in/Sign up functionality
  - Error display

- **`Views/Onboarding/PersonalDetailsView.swift`** - Personal info collection
  - Name text field
  - Date of birth picker
  - Gender button (opens GenderView)
  - Pronouns picker
  - Continue button (validates name + gender)

- **`Views/Onboarding/GenderView.swift`** - Gender selection
  - Gender options picker

- **`Views/Onboarding/PreferencesView.swift`** - Dating preferences
  - "Looking for" selection
  - "Interested in" selection

- **`Views/Onboarding/CollegeView.swift`** - College information
  - College name
  - Student email
  - Location

- **`Views/Onboarding/PhotosView.swift`** - Photo upload
  - Up to 6 photo slots
  - Image picker integration
  - Add/remove photos

- **`Views/Onboarding/BioInterestsView.swift`** - Bio and interests
  - Bio text field
  - Interest selection (minimum 5 required)
  - Continue validation

- **`Views/Onboarding/FunQuestionsView.swift`** - Fun questions
  - Answer fun/personality questions
  - Stores answers in `funQuestionAnswers` dictionary

- **`Views/Onboarding/FinalScreenView.swift`** - Onboarding completion
  - Profile preview card
  - "Let's Collide 🚀" button
  - Sets `onboardingComplete = true`

- **`Views/Onboarding/Components/HeaderView.swift`** - Reusable header
  - Title and back button

- **`Views/Onboarding/Components/TrayView.swift`** - Tray presentation modifier
  - Custom bottom sheet implementation

- **`Views/Onboarding/Models/Models.swift`** - Onboarding models
  - `CurrentView` enum - All onboarding steps
  - `TrayConfig` - Tray configuration
  - `KeyValue` - Keypad button model
  - `keypadValues` - Keypad layout data

- **`Views/Onboarding/Utilities/ImagePicker.swift`** - Image picker utility
  - UIImagePickerController wrapper

---

## 🔄 **Data Flow**

### **User Authentication Flow**
```
User Input → AuthViewModel → SupabaseManager.client.auth → Supabase API
                                                              ↓
                                                         Response
                                                              ↓
                                                    AuthViewModel updates state
                                                              ↓
                                                    Navigate to next view
```

### **User Data Fetching Flow**
```
Home View appears
    ↓
HomeViewModel.fetchUsers()
    ↓
SupabaseService.fetchAllUsers()
    ↓
SupabaseManager.shared.client.from("users").select()
    ↓
Supabase API returns JSON
    ↓
Decode to [UserModel]
    ↓
Update HomeViewModel.users
    ↓
UI updates with UserCard stack
```

### **State Management**
- **MVVM Pattern**: ViewModels manage state, Views observe via `@ObservedObject` or `@StateObject`
- **Published Properties**: `@Published` properties trigger UI updates
- **UserDefaults**: `onboardingComplete` flag persisted locally

---

## 🗄️ **Database Structure (Supabase)**

Based on the code, the database has these tables:

### **`users` table**
```sql
- id: Int (Primary Key)
- name: String
- avatar: String? (URL)
- age: Int
- gender: String
- bio: String?
- college: String
- last_active: String? (Timestamp)
- verified: Bool
```

### **`photos` table**
```sql
- id: Int (Primary Key)
- user_id: Int (Foreign Key → users.id)
- photo_url: String
```

### **`interests` table** (implied)
```sql
- id: String (Primary Key)
- name: String
```

### **`swipes` table** (implied)
```sql
- id: String (Primary Key)
- swiper_id: String
- swipee_id: String
- direction: String ("left" or "right")
- timestamp: String
```

### **`matches` table**
```sql
- id: String (Primary Key)
- user1_id: Int (Foreign Key → users.id)
- user2_id: Int (Foreign Key → users.id)
- matched_on: String (Timestamp)
```

### **`reviews` table** (implied)
```sql
- id: String (Primary Key)
- reviewer_id: String
- reviewed_id: String
- review_text: String?
- rating: Int?
- created_at: String
```

**Relationships:**
- `users` → `photos` (one-to-many)
- `users` → `matches` (many-to-many via matches table)
- `matches` has foreign keys to `users` (user1_id, user2_id)

---

## 🔌 **API Integration**

### **Supabase Setup**
- **URL**: `https://elxkzdrcyloubqhwiuuu.supabase.co`
- **API Key**: Stored in `SupabaseManager.swift` (anon key)
- **Client**: Singleton pattern via `SupabaseManager.shared`

### **Current API Calls**
1. **Fetch All Users**
   ```swift
   client.from("users").select("*, photos(*)")
   ```
   - Returns users with nested photos

2. **Fetch Matches**
   ```swift
   client.from("matches")
     .select("*, user1:users!matches_user1_id_fkey(*), user2:users!matches_user2_id_fkey(*)")
     .or("user1_id.eq.\(userId),user2_id.eq.\(userId)")
   ```
   - Returns matches with full user objects

3. **Authentication**
   ```swift
   client.auth.signIn(email:email, password:password)
   client.auth.signUp(email:email, password:password)
   ```

### **Missing API Integrations** (Not yet implemented)
- ❌ Phone authentication
- ❌ OTP verification
- ❌ Google/Apple sign-in
- ❌ User profile creation/update
- ❌ Photo upload
- ❌ Swipe action (left/right)
- ❌ Match creation
- ❌ Messages/conversations
- ❌ Events fetching

---

## 📦 **Dependencies**

### **Swift Package Manager (SPM)**
From `Package.resolved`:

1. **supabase-swift** (v2.28.0)
   - Main Supabase client library
   - Used for database queries and authentication

2. **swift-asn1** (v1.3.2)
   - ASN.1 encoding/decoding (dependency of supabase-swift)

3. **swift-clocks** (v1.0.6)
   - Time utilities (dependency)

4. **swift-concurrency-extras** (v1.3.1)
   - Concurrency utilities (dependency)

5. **swift-crypto** (v3.12.3)
   - Cryptographic functions (dependency)

6. **swift-http-types** (v1.4.0)
   - HTTP type definitions (dependency)

7. **xctest-dynamic-overlay** (v1.5.2)
   - Testing utilities (dependency)

### **Native Frameworks**
- **SwiftUI** - UI framework
- **Foundation** - Core utilities
- **Combine** - Reactive programming (via @Published)

---

## 🔑 **Key Variables & State**

### **AuthViewModel State**
```swift
// Navigation
currentView: CurrentView
onboardingComplete: Bool (persisted)

// Auth
phoneNumber: String
otp: String
email: String
password: String
emailLoginStarted: Bool

// Profile
name: String
dob: Date
gender: String
pronouns: String
interestedIn: String
lookingFor: String
collegeName: String
studentEmail: String
location: String
bio: String

// Media
selectedImages: [UIImage?] (6 slots)
showingImagePicker: Bool
selectedImageIndex: Int?

// Interests
selectedInterests: Set<String>
allInterests: [Interest]

// Fun Questions
funQuestionAnswers: [String: String]

// Error
errorMessage: String?
```

### **HomeViewModel State**
```swift
users: [UserModel]
errorMessage: String?
errorIcon: String
```

---

## 🎨 **UI/UX Features**

### **Design Patterns**
- **Gradient Backgrounds**: Used throughout (cyan, green, indigo, blue)
- **Rounded Corners**: Consistent 12-24px radius
- **Bottom Sheet/Tray**: Custom implementation for onboarding
- **Card Stack**: Swipeable cards with drag gestures
- **Navigation Transitions**: Zoom animation for user detail view

### **Color Scheme**
- Supports dark/light mode via `@Environment(\.colorScheme)`
- Primary color: Indigo (tab bar tint)
- Accent colors: Cyan, Green, Blue gradients

### **Assets**
- App icons in `Assets.xcassets/AppIcon.appiconset/`
- Login backgrounds: `loginBackground5.imageset/`
- Gender icons: Male, Female, Non-binary, Other
- Test images: `name10`, `test-image-10`

---

## 🚧 **Where You Left Off**

### **Recent Changes** (from git status)
1. **Updated login background image**
   - Replaced `loginBackground5.JPG` with new PNG file
   - Updated `Contents.json` in `loginBackground5.imageset/`

2. **Package dependencies updated**
   - `Package.resolved` modified (not staged)

### **Current State**
✅ **Completed:**
- Basic app structure
- Onboarding UI flow (all screens)
- Email authentication (sign in/sign up)
- User data models
- Supabase integration setup
- Home screen with user cards
- Swipeable card interface
- User detail view
- Image caching
- Error handling

❌ **Not Implemented:**
- Phone authentication (UI exists, no API)
- OTP verification (UI exists, no API)
- Google/Apple sign-in (UI exists, no API)
- User profile creation (onboarding doesn't save to DB)
- Photo upload to Supabase Storage
- Swipe actions (cards remove but don't save swipe)
- Match creation logic
- Messages functionality
- Events functionality
- Real matches screen
- User profile editing

### **Next Steps to Continue**
1. **Complete Authentication**
   - Implement phone/OTP verification with Supabase
   - Add Google/Apple sign-in

2. **User Profile Creation**
   - Save onboarding data to Supabase `users` table
   - Upload photos to Supabase Storage
   - Save interests, bio, etc.

3. **Swipe Functionality**
   - Save swipe actions to `swipes` table
   - Check for matches (mutual right swipes)
   - Create match records

4. **Matches Screen**
   - Fetch and display real matches
   - Add navigation to chat

5. **Messages**
   - Implement chat functionality
   - Real-time messaging with Supabase Realtime

6. **Events**
   - Design and implement events feature

7. **Profile Management**
   - Edit profile functionality
   - Update photos, bio, interests

---

## 🐛 **Known Issues / TODOs**

1. **Mock Data Usage**: Profile and Details tabs use `UserModel.mock`
2. **No User Context**: App doesn't track current logged-in user
3. **No Swipe Persistence**: Swipes aren't saved to database
4. **No Match Logic**: Matching algorithm not implemented
5. **Placeholder Screens**: Messages, Events, Matches are placeholders
6. **Hardcoded Values**: Some UI elements use hardcoded data
7. **No Image Upload**: Photos selected but not uploaded
8. **No Error Recovery**: Limited error handling in some flows

---

## 📝 **Code Quality Notes**

- **Architecture**: MVVM pattern followed
- **State Management**: SwiftUI + Combine (@Published)
- **Error Handling**: Custom AppError enum with user-friendly messages
- **Image Caching**: Custom URLCache implementation
- **Navigation**: SwiftUI NavigationStack
- **Modularity**: Good separation of concerns (Views, ViewModels, Services, Models)

---

This document provides a complete overview of your Collide app. You can use it as a reference to continue development!

