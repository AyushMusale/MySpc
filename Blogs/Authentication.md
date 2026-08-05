# Building MySpc #1 — Designing Passwordless Authentication

Every communication platform starts with authentication.

Before users can join a Space, chat with friends, or make voice calls, they first need an identity.

For MySpc's MVP, I wanted authentication to be:

- Fast
- Secure
- Simple
- Passwordless

This article explains the authentication architecture I chose and why.

---

# Why Passwordless?

Traditional authentication requires users to remember passwords.

That creates several problems:

- Weak passwords
- Password reuse
- Password reset flows
- Credential stuffing attacks

Instead, MySpc authenticates users using a one-time password (OTP) sent to their email.

If users can access their email, they can log in.

No passwords are ever created or stored.

---

# Authentication Flow

The entire login process consists of four steps.

## Step 1 — Enter Email

The user enters their email address.

```
Email
```

The frontend sends:

```
POST /auth/send-otp
```

The backend validates the email, generates an OTP, and emails it to the user.

---

## Step 2 — Store OTP in Redis

OTPs are temporary.

Using PostgreSQL for temporary data would be unnecessary.

Instead, Redis is used because:

- extremely fast
- supports automatic expiration
- ideal for temporary data

Example:

Key

```
otp:user@example.com
```

Value

```json
{
    otpHash,
    attempts
}
```

TTL

```
300 seconds
```

Redis automatically deletes expired OTPs.

No cleanup jobs are required.

---

## Step 3 — Verify OTP

The user enters the received OTP.

The backend:

- fetches OTP from Redis
- verifies it
- checks expiration
- deletes it after successful verification

After verification, the backend checks whether the email already exists.

---

## Existing User

If the email exists:

- Generate Access Token
- Generate Refresh Token
- Redirect to the Private Space

---

## New User

If the email does not exist:

Instead of creating the account immediately, the backend issues a short-lived Signup Token.

The user is then asked to provide:

- Real Name
- Username

Once submitted:

- User is created
- Profile is created
- Tokens are generated

---

# Why Use a Signup Token?

Without it, anyone could directly call the signup endpoint.

The Signup Token guarantees that:

> This email has already been verified.

It is valid for only a few minutes.

---

# Token Strategy

The application uses two JWTs.

## Access Token

Short-lived.

Used for authenticating API requests.

## Refresh Token

Long-lived.

Stored as a hash inside PostgreSQL.

Used to issue new Access Tokens.

---

# Database Responsibilities

## PostgreSQL

Stores permanent data.

- Users
- Profiles
- Refresh Tokens

## Redis

Stores temporary data.

- OTP
- OTP attempts
- Rate limiting
- Future cache

Each database is responsible only for the type of data it handles best.

---

# Security

Several measures protect the authentication system.

- OTPs are hashed before storage.
- OTPs expire after five minutes.
- OTPs are deleted immediately after use.
- Maximum verification attempts are limited.
- OTP requests are rate limited.
- Refresh Tokens are hashed.
- Signup Tokens are short-lived.

---

# Final Architecture

```
User
    │
    ▼
Enter Email
    │
    ▼
Backend
    │
    ├── Generate OTP
    ├── Store in Redis
    └── Send Email
    │
    ▼
Verify OTP
    │
    ▼
Email Exists?
    │
    ├── Yes → Generate Tokens
    │
    └── No
          │
          ▼
     Signup Token
          │
          ▼
Create Profile
          │
          ▼
Generate Tokens
          │
          ▼
Private Space
```

---

# Conclusion

Authentication is usually the first feature users interact with, so it should be both simple and secure.

Using email OTP authentication with Redis for temporary state and PostgreSQL for persistent data keeps the MVP lightweight while leaving room to scale as MySpc grows.

In the next article, I'll cover how Spaces are designed and how users, channels, and permissions are modeled.