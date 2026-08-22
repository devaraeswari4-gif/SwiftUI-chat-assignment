# SwiftUI-chat-assignment
SwiftUI Chat Screen – Swift Package Assignment

How it works
The app now treats each chat as a persistent conversation identified by the user’s stable UUID.

Flow:

Chat list user
   → Conversation(participant: user)
   → conversation.id = user.id
   → ChatSessionStore loads/saves messages for that ID
   → reopen same user = load same messages
1. Stable conversation identity
Previously, tapping a user created a new random Conversation ID every time. That meant the store could not find the old messages.

Now, [Conversation.swift](/ChatDemoApp/ChatKit/Sources/ChatKit/Models/Conversation.swift) defaults the conversation ID to participant.id.

The users in [ChatListViewModel.swift](/ChatDemoApp/ChatKit/Sources/ChatKit/ViewModels/ChatListViewModel.swift) also have fixed UUIDs. In a real application these should come from your API/database user IDs.

2. Persistent store
[ChatSessionStore.swift](/ChatDemoApp/ChatKit/Sources/ChatKit/Service/ChatSessionStore.swift) is an actor, meaning its data is protected from concurrent updates.

It stores this for each conversation:

All ChatMessage values
Last-read message ID
Last-opened timestamp
The complete dictionary is JSON-encoded and saved to UserDefaults under ChatKit.conversations. It is loaded again when the app starts, so conversations remain available after closing and reopening the app.

ChatMessage and ChatUser were made Codable so their values can be encoded to JSON.

3. Saving sent messages and responses
In [ChatViewModel.swift](/ChatDemoApp/ChatKit/Sources/ChatKit/ViewModels/ChatViewModel.swift):

The user message is appended.
An empty assistant message is appended as a streaming placeholder.
Both are saved immediately.
Each incoming response chunk updates and saves the assistant message.
If streaming fails, the error message is saved too.
This means even a partial streaming reply is preserved if the user leaves the chat.

4. Loading and tracking when a chat opens
When a chat screen appears, loadConversation():

Loads saved messages for that conversation ID.
Calls markOpened, which saves the current time.
The chat list calls refreshConversationDetails() to rebuild its rows using the saved conversation summary:

The latest saved message becomes the preview.
lastOpenedDate becomes the displayed “Opened …” timestamp.
A chat with an opened timestamp displays no unread badge.
5. Static timestamps
[ChatListSwiftUIView.swift](/ChatDemoApp/ChatKit/Sources/ChatKit/Views/ChatListSwiftUIView.swift) uses:

date.formatted(date: .abbreviated, time: .shortened)
That produces a fixed value such as Aug 22, 8:30 AM. It does not keep changing like SwiftUI’s .relative style (5 seconds ago, 6 seconds ago).

Developer notes
UserDefaults is suitable for this demo or lightweight local-only chat history.
For production, use SwiftData/Core Data/SQLite for larger histories, message search, pagination, attachments, migrations, and per-account isolation.
This app’s unread count is currently demo data. It clears after opening because the conversation has a saved lastOpenedDate. A production unread count should come from server message IDs/read receipts instead.
To clear all saved demo chats during development:
UserDefaults.standard.removeObject(forKey: "ChatKit.conversations")
To support multiple logged-in accounts, namespace the key:
let storageKey = "ChatKit.conversations.\(currentUserID)"
let store = ChatSessionStore(storageKey: storageKey)
