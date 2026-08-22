
# SwiftUI Chat Assignment

A reusable SwiftUI chat feature delivered as a Swift Package and integrated with a host iOS application.

## Features

- SwiftUI chat interface
- Swift Package integration
- MVVM architecture
- Async/await with `AsyncStream` for simulated streaming responses
- Persistent conversation history
- Stable conversation IDs using user UUIDs
- Conversation preview and last-opened timestamp
- Streaming cancellation and error handling
- Unit and UI testing

## How It Works

```text
Chat List
   ↓
Conversation
   ↓
ChatView
   ↓
ChatViewModel
   ↓
ChatSessionStore / Streaming Service
   ↓
Persistent Messages + Streaming Response
