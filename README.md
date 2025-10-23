````markdown
# 📸 Pix2Life

Pix2Life is a cross-platform application built with **Flutter** and **Node.js**, designed to help users revisit cherished memories of places or interests. It allows users to store photos as collections and retrieve them by searching with images — making memory recall intuitive and visual.

---

## 🧩 Project Structure

- `client/` – Flutter mobile application
- `server/` – Node.js backend API

---

## 🚀 Features

- Store personal photo collections
- Search and retrieve collections using image-based queries
- Seamless integration between mobile frontend and backend services
- Ngrok proxy support for development tunneling

---

## 🛠️ Getting Started

### 🔧 Server Setup (Node.js)

1. Navigate to the `server/` directory.
2. Install dependencies:

   ```bash
   npm install
   ```
````

3. Add your credentials to the `.env` file. Use the provided `.env.example` as a template:

   ```bash
   cp .env.example .env
   ```

4. Run the server in development mode:

   ```bash
   npm run dev
   ```

5. Initialize Ngrok proxy:

   ```bash
   npm run proxy
   ```

---

### 📱 Client Setup (Flutter)

1. Navigate to the `client/` directory.
2. Get dependencies:

   ```bash
   flutter pub get
   ```

3. Update the `baseUrl` in the `app/secrets` folder to match your backend endpoint.
4. Run the app:

   ```bash
   flutter run
   ```

---

## 📂 Environment Variables

Ensure the following variables are set in your `.env` (app_secrets)file:

```env
# Example
API_KEY=your_api_key
DATABASE_URL=your_database_url
NGROK_AUTH_TOKEN=your_ngrok_token
```

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you’d like to change.

---

## 📄 License

This project is licensed under the MIT License.

---

## 💡 Inspiration

Pix2Life was born from the idea of making memory recall more immersive and intuitive by using visual search. Whether it's a favorite vacation spot or a meaningful moment, Pix2Life helps bring those memories back to life.
