# Database Design

For **MySpc**, a relational database is used. The database management system (DBMS) is **PostgreSQL**.

The database is designed to separate concerns such as authentication, user profiles, conversations, friendships, and messages. This modular design makes the application easier to maintain and extend in the future.

---

# Users Table

The **Users** table is responsible for authentication. Every registered user has exactly one record in this table.

## Purpose

- Store the user's email address.
- Store the unique identifier used throughout the application.
- Track whether the email has been verified.
- Record when the account was created.

## Columns

| Column | Type | Description |
|---------|------|-------------|
| id | UUID (Primary Key) | Unique identifier for the user. |
| email | VARCHAR UNIQUE | User's email address used for login. |
| is_verified | BOOLEAN | Indicates whether the email has been verified through OTP. |
| created_at | TIMESTAMP | Timestamp when the account was created. |

---

# Profile Table

The **Profile** table stores publicly visible information about a user. Authentication details are intentionally kept separate in the Users table.

## Purpose

- Store display information.
- Store username.
- Store avatar.
- Store profile bio.

## Columns

| Column | Type | Description |
|---------|------|-------------|
| id | UUID (Primary Key) | Unique identifier of the profile. |
| user_id | UUID (Foreign Key → Users.id) | Links the profile to its authentication record. |
| username | VARCHAR UNIQUE | Public unique username. |
| display_name | VARCHAR | User's display name. |
| avatar_url | TEXT | URL of the user's profile picture. |
| bio | TEXT | Short user biography. |
| created_at | TIMESTAMP | Profile creation time. |
| updated_at | TIMESTAMP | Last profile update time. |

---

# Space Table

A **Space** represents a conversation.

A space can either be:

- Direct Message (DM)
- Group Chat

Every conversation inside MySpc is represented by a Space.

## Purpose

- Represent conversations.
- Store conversation metadata.
- Track the latest activity.

## Columns

| Column | Type | Description |
|---------|------|-------------|
| id | UUID (Primary Key) | Unique identifier of the conversation. |
| name | VARCHAR | Name of the group (NULL for DMs). |
| type | ENUM('dm', 'group') | Type of conversation. |
| created_by | UUID (Foreign Key → Profile.id) | User who created the space. |
| created_at | TIMESTAMP | Time when the conversation was created. |
| last_message_at | TIMESTAMP | Timestamp of the latest message. |

---

# Space Members Table

A **Space** can contain multiple members.

The Space Members table creates a many-to-many relationship between Profiles and Spaces.

## Purpose

- Store members of every conversation.
- Store member roles.
- Track when a user joined a conversation.

## Composite Primary Key

```
(space_id, profile_id)
```

This prevents duplicate memberships.

## Columns

| Column | Type | Description |
|---------|------|-------------|
| space_id | UUID (Foreign Key → Space.id) | Conversation identifier. |
| profile_id | UUID (Foreign Key → Profile.id) | Member of the conversation. |
| joined_at | TIMESTAMP | Time the member joined. |
| role | ENUM('member', 'admin') | Permission level inside the space. |

---

# Messages Table

The **Messages** table stores every message sent inside a Space.

Instead of storing a receiver, each message belongs to a Space.

This allows the same schema to support both private chats and group chats.

## Purpose

- Store chat messages.
- Store sender information.
- Support editing and soft deletion.

## Columns

| Column | Type | Description |
|---------|------|-------------|
| id | UUID (Primary Key) | Unique message identifier. |
| space_id | UUID (Foreign Key → Space.id) | Conversation the message belongs to. |
| sender_id | UUID (Foreign Key → Profile.id) | User who sent the message. |
| message | TEXT | Message content. |
| created_at | TIMESTAMP | Time the message was sent. |
| edited_at | TIMESTAMP NULL | Time the message was edited. |
| deleted_at | TIMESTAMP NULL | Time the message was deleted (soft delete). |

---

# Friends Table

The **Friends** table manages friend relationships between users.

A friendship must be accepted before users are considered friends.

## Purpose

- Store friend requests.
- Track friendship status.
- Support blocking users.

## Columns

| Column | Type | Description |
|---------|------|-------------|
| user1_id | UUID (Foreign Key → Profile.id) | First user in the friendship. |
| user2_id | UUID (Foreign Key → Profile.id) | Second user in the friendship. |
| status | ENUM('pending', 'accepted', 'blocked') | Current friendship status. |
| created_at | TIMESTAMP | Time the relationship was created. |

---

# Database Relationships

```
Users
   │
   │ 1 : 1
   ▼
Profile
   │
   ├──────────────┐
   │              │
   │              │
   ▼              ▼
Friends      Space Members
                  │
                  │
                  ▼
               Space
                  │
                  ▼
              Messages
```

---

# Design Principles

- Authentication and profile information are separated.
- Every conversation is represented by a Space.
- Direct Messages and Group Chats share the same database structure.
- Many-to-many relationships are handled using the Space Members table.
- Messages belong to Spaces instead of individual users.
- Friendships are managed independently from conversations, allowing future features such as messaging non-friends or public communities.