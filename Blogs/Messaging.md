# Building MySpc #2 — Designing Real-Time Messaging

Every communication platform lives or dies by how it handles messages.

After authentication, the next foundational piece of MySpc is getting messages from one user to another in real time.

This article explains the messaging architecture I chose and why.

---

# The Core Problem

When user A sends a message to user B (and C, D…), three things must happen:

- Every other member of the Space must receive the message instantly.
- The message must be persisted in the database.
- The sender does not need to receive their own message back.

---

# Why WebSockets?

HTTP is a request-response protocol.

For messaging, the server needs to push data to clients without them asking.

WebSockets hold an open, bidirectional connection between client and server — perfect for chat.

MySpc uses **Socket.IO** on top of Node.js because it handles reconnection, fallback transports, and rooms out of the box.

---

# The Per-User Room Strategy

When a client connects, the server immediately joins them to a room named after their userId:

```
socket.join(String(userId))
```

This makes fan-out trivial:

```
io.to(String(memberId)).emit("new_message", payload)
```

No matter how many devices a user has connected, the message reaches all of them.

---

# The Send Message Flow

```
Client
  │
  │  emit("send_message", { spaceId, msg, msg_type, time, deviceId })
  ▼
Server
  │
  ├── 1. Validate payload (Zod)
  ├── 2. Guard: sender must be a member of the Space
  ├── 3. Persist message in PostgreSQL (+ bump Space.lastMessageAt)
  └── 4. Fan-out: emit("new_message", ...) to all members except sender
              │
              ├──→ io.to(userId_1).emit(...)
              ├──→ io.to(userId_2).emit(...)
              └──→ io.to(userId_N).emit(...)
```

---

# Payload Design

## Client → Server (`send_message`)

```json
{
  "spaceId":  1,
  "msg":      "Hello!",
  "msg_type": "TEXT",
  "time":     "2026-09-05T09:53:00.000Z",
  "deviceId": "abc-123"
}
```

The client provides its own timestamp (`time`) so messages can be ordered correctly even before the server responds.

`deviceId` allows the sending device to identify and deduplicate its own outbound message if needed.

## Server → Other Members (`new_message`)

```json
{
  "spaceId":   1,
  "msg":       "Hello!",
  "msg_type":  "TEXT",
  "time":      "2026-09-05T09:53:00.000Z",
  "by":        42,
  "id":        8001,
  "deviceId":  "abc-123",
  "createdAt": "2026-09-05T04:23:00.000Z"
}
```

`by` is the sender's profileId so recipients know who sent the message.
`id` is the server-assigned database id.

---

# Security

Several measures protect the messaging system.

- Socket connections are authenticated via the same JWT access token used by REST endpoints.
- The server re-verifies that the sender is actually a member of the target Space before accepting the message.
- Invalid payloads are rejected immediately via Zod schema validation.

Without the membership check, any authenticated user could emit to any spaceId.

---

# Database Responsibilities

## PostgreSQL

Stores permanent data.

- `Message` row per sent message.
- `Space.lastMessageAt` is bumped atomically in the same transaction.

The `(spaceId, createdAt)` composite index makes fetching a conversation's history efficient.

## Redis

Not involved in messaging today.

Future use cases: typing indicators, online presence, unread counts.

---

# Flutter Architecture

The Flutter client follows the same Clean Architecture used for authentication.

```
SocketClient (singleton)
    │
    ▼
MessageRepositoryImpl
    │
    ├── sendMessage()       → SocketClient.emit("send_message", ...)
    └── listenMessages()    → SocketClient.on("new_message") |> filter(spaceId) |> map(entity)
    │
    ▼
Use Cases
    ├── SendMessageUseCase
    └── ListenMessagesUseCase
    │
    ▼
MessagingBloc
    ├── StartListening  → opens stream subscription
    ├── SendMessage     → delegates to SendMessageUseCase
    ├── MessageReceived → appends to state.messages
    └── StopListening   → cancels subscription
```

`MessagingBloc` is a `factory` registration in GetIt — a new instance is created for each Space screen and disposed when the user navigates away, cancelling the stream subscription automatically via `close()`.

---

# Final Architecture

```
User (Flutter)
    │
    │ emit send_message
    ▼
WebSocket Server (Socket.IO)
    │
    ├── Validate payload (Zod)
    ├── Guard membership (Prisma)
    ├── Save to PostgreSQL
    └── Fan-out new_message
          │
          ├──→ User B
          ├──→ User C
          └──→ User D
```

---

# Conclusion

Real-time messaging on MySpc is built on three simple ideas:

- **Per-user rooms** make fan-out trivial and device-agnostic.
- **Membership guard** on every message ensures security without a separate middleware.
- **Atomic DB write** (message + lastMessageAt) keeps the data consistent.

In the next article, I will cover how the conversation history is fetched and paginated when a user opens a Space.
