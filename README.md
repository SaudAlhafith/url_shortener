# URL Shortener Service 🌐

This URL shortener service is a full-stack application created to demonstrate the practical use of a relational database management system (RDBMS) with a Python Flask backend 🐍 and a Flutter frontend 📱. It provides a simple API to shorten URLs, which can be utilized from any Flutter app. The backend is designed to connect to a MySQL database hosted on a Linode server.

## Installation 💻

```
git clone https://github.com/SaudAlhafith/url_shortener.git
cd url-shortener-flutter-api
```

## Configuration 🔧

To configure the application, fill in your MySQL database credentials in the `config.ini` file located in the project's root directory.

```
[DATABASE]
HOST = your_database_host
DATABASE = your_database_name
USER = your_database_user
PASSWORD = your_database_password
```

## Running the Application 🚀
To start the Flask backend:
Simply run main.py:
```
python main.py
```

To run the Flutter frontend:

```
# Navigate to the Flutter application directory
cd path/to/flutter_app

# Run the Flutter app
flutter run
```
🚨 Note: If you're running the Flutter app on an Android emulator, the localhost IP will be different (typically `10.0.2.2` for Android emulators).

## API Endpoints 🌍

- POST `/shorten`: Accepts a URL and an optional alias to provide a shortened URL.
- GET `/<short_id>`: Redirects to the original URL based on the provided short ID.

## Video Demo 🎥
For example:
[Project Video Demo]

## Contributing

If you'd like to contribute to this project, please feel free to fork the repository, make your changes, and submit a pull request.
