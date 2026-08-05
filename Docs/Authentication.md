# Authentication (MVP)

The application uses **passwordless authentication** with **Email OTP**. No passwords are stored.

---

# Authentication Flow

## Step 1: Enter Email

The user enters their email address.

```text
Input:
- Email
```

When the user clicks **Continue**, the frontend sends:

```http
POST /auth/send-otp
```

```json
{
  "email": "user@example.com"
}
```

---

## Step 2: Generate & Send OTP

The backend performs the following:

- Validates the email.
- Generates a 6-digit OTP.
- Hashes the OTP.
- Stores it in Redis with an expiration time.
- Sends the OTP to the user's email.

### Redis Structure

**Key**

```text
otp:user@example.com
```

**Value**

```json
{
  "otpHash": "<hashed_otp>",
  "attempts": 0
}
```

**TTL**

```text
300 seconds (5 minutes)
```

Redis automatically deletes the OTP after it expires.

---

## Step 3: Verify OTP

Frontend sends:

```http
POST /auth/verify-otp
```

```json
{
  "email": "user@example.com",
  "otp": "123456"
}
```

Backend:

1. Reads the OTP from Redis.
2. Checks whether it exists.
3. Verifies the expiration (handled automatically by Redis TTL).
4. Compares the hashed OTP.
5. Increments the failed attempt count if verification fails.
6. Deletes the Redis key after successful verification.
7. Checks whether the email already exists in the database.

---

# Existing User Flow

If the email already exists:

- Generate Access Token.
- Generate Refresh Token.
- Return both tokens to the client.

Response

```json
{
  "isNewUser": false,
  "accessToken": "...",
  "refreshToken": "..."
}
```

The frontend stores the tokens securely and redirects the user to their Private Space.

---

# New User Flow

If the email does **not** exist:

The backend issues a temporary **Signup Token**.

```json
{
  "isNewUser": true,
  "signupToken": "temporary_jwt"
}
```

The Signup Token proves that the email has already been verified.

It should expire in **5–10 minutes**.

---

## Step 4: Complete Profile

The frontend displays a profile creation screen.

Required fields:

- Real Name
- Username

The verified email is already filled and cannot be modified.

Request:

```http
POST /auth/signup
```

Authorization

```text
Bearer <SignupToken>
```

Body

```json
{
  "name": "John Doe",
  "username": "johndoe"
}
```

Backend:

- Verifies the Signup Token.
- Creates the User.
- Creates the User Profile.
- Generates Access Token.
- Generates Refresh Token.

Response

```json
{
  "accessToken": "...",
  "refreshToken": "..."
}
```

The frontend stores the tokens securely and redirects the user to the Private Space.

---

# JWT Payload

The Access Token should contain only essential information.

```json
{
  "sub": "userId",
  "email": "user@example.com",
  "username": "johndoe",
  "role": "user"
}
```

Avoid storing mutable information such as the user's real name inside the JWT.

---

# Token Strategy

## Access Token

- Lifetime: 15–30 minutes
- Used for API authentication.

## Refresh Token

- Lifetime: 30–90 days
- Stored as a hash in the database.
- Rotated every time a new Access Token is issued.

---

# Redis Responsibilities

Redis is responsible for temporary authentication data.

Stores:

- OTP
- OTP verification attempts
- OTP expiration (TTL)
- Rate limiting data (future)

Example:

```text
Key:
otp:user@example.com

Value:
{
    otpHash,
    attempts
}

TTL:
300 seconds
```

---

# PostgreSQL Responsibilities

Persistent application data.

Tables:

## Users

```text
id
email
username
name
role
createdAt
updatedAt
```

---

## RefreshTokens

```text
id
userId
tokenHash
expiresAt
device
ipAddress
revoked
createdAt
```

---

# Security Measures

- OTP is never stored in plain text.
- OTP expires after 5 minutes.
- OTP is deleted immediately after successful verification.
- Maximum 5 verification attempts.
- Limit OTP requests (e.g., one request every 60 seconds per email/IP).
- Limit total OTP requests per email per hour.
- Refresh Tokens are hashed before storing.
- Signup Tokens are short-lived (5–10 minutes).

---

# Complete Authentication Flow

```text
User Opens App
        │
        ▼
Enter Email
        │
        ▼
POST /auth/send-otp
        │
        ▼
Generate OTP
        │
        ▼
Store Hashed OTP in Redis
        │
        ▼
Send OTP Email
        │
        ▼
User Enters OTP
        │
        ▼
POST /auth/verify-otp
        │
        ▼
Validate OTP from Redis
        │
        ▼
Check if User Exists
        │
        ├──────── Existing User ──────────────┐
        │                                     │
        │                              Generate Access Token
        │                              Generate Refresh Token
        │                                     │
        │                                     ▼
        │                           Redirect to Private Space
        │
        ▼
Issue Signup Token
        │
        ▼
User Enters Name & Username
        │
        ▼
POST /auth/signup
        │
        ▼
Create User
Create Profile
        │
        ▼
Generate Access Token
Generate Refresh Token
        │
        ▼
Redirect to Private Space
```