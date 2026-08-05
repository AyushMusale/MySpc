# Friends System

The Friends system is the foundation of private communication in **MySpc**. Unlike traditional messaging platforms that allow anyone with your phone number or contact information to message you, MySpc requires both users to establish a mutual friendship before private messaging is possible.

This approach gives users greater control over who can contact them while eliminating the need to share personal contact information.

---

# Purpose

The Friends system is designed to:

- Prevent unsolicited messages from unknown users.
- Allow users to communicate using only their username.
- Keep personal contact information private.
- Ensure that private conversations only occur between mutually accepted users.

---

# Friend Request Flow

A friendship is established through a simple request-and-accept process.

## Step 1 – Send Friend Request

A user searches for another user by their username and sends a friend request.

The friendship status is initially marked as **Pending**.

---

## Step 2 – Accept or Reject

The recipient can either:

- Accept the request
- Reject the request

If accepted, both users become friends.

---

## Step 3 – Start a Conversation

Being friends does **not** automatically create a chat.

The first time either user clicks **Message**, the backend checks whether a private conversation (Space) already exists.

- If a Space exists, it is opened.
- If no Space exists, a new private Space is created and both users are added as members.

This lazy creation approach prevents unnecessary conversation records for friends who never exchange messages.

---

## Step 4 – Chat Normally

Once the private Space has been created, both users can exchange messages in real time.

Every future conversation between the same two users uses the existing Space.

---

# Conversation Flow

```text
Alice
    │
    ▼
Send Friend Request
    │
    ▼
Bob Accepts
    │
    ▼
Friendship Created
    │
    ▼
Alice clicks "Message"
    │
    ▼
Backend checks for existing Private Space
    │
    ├── Exists → Open Chat
    │
    └── Doesn't Exist
            │
            ▼
      Create Private Space
            │
            ▼
        Start Chatting
```

---

# Why Create the Space Only When Needed?

Instead of creating a conversation immediately after two users become friends, MySpc creates the private Space only when someone starts a conversation.

This has several advantages:

- Avoids creating thousands of unused conversations.
- Keeps the database smaller and cleaner.
- Reduces unnecessary processing.
- Allows friendships to exist independently of conversations.

---

# Advantages

- No phone numbers or email addresses need to be shared.
- Users communicate using unique usernames.
- Only accepted friends can initiate private conversations.
- Reduces spam and unwanted messages.
- Conversations are created only when required.
- Supports future expansion to groups and communities using the same Space architecture.

---

# Future Improvements

The Friends system can be extended with additional features such as:

- Cancel friend request
- Reject friend request
- Block user
- Remove friend
- Mutual friends
- Friend suggestions
- Friend request notifications
- User privacy settings (who can send requests)