# Ekklesia API Reference

**Base URL:** `http://localhost:3000`

## Authentication

Most endpoints require a JWT Bearer token in the `Authorization` header:

```
Authorization: Bearer <access_token>
```

Tokens are obtained via the `/auth/signup` or `/auth/login` endpoints.

## Global Validation

All request bodies are validated with:
- **whitelist:** Extra fields are silently stripped
- **forbidNonWhitelisted:** Extra fields return `400 Bad Request`
- **transform:** Query params and path params are auto-cast to their declared types

---

## Table of Contents

- [Health & Config](#health--config)
- [Authentication](#authentication-1)
- [Profile](#profile)
- [Preferences](#preferences)
- [Churches](#churches)
- [Join Requests](#join-requests)
- [Prayers](#prayers)
- [Reminders](#reminders)
- [Bible](#bible)
- [Bookmarks](#bookmarks)
- [Reading Plans](#reading-plans)
- [Reading Progress](#reading-progress)
- [Groups](#groups)
- [Events](#events)
- [Broadcasts](#broadcasts)
- [Media](#media)
- [Verification](#verification)
- [Ops Verification](#ops-verification)
- [Enums Reference](#enums-reference)
- [Error Responses](#error-responses)

---

## Health & Config

### GET /health

Returns application health status.

**Auth:** None

**Response** `200`
```json
{
  "status": "ok",
  "timestamp": "2026-03-16T10:00:00.000Z",
  "version": "1.0.0"
}
```

---

### GET /config/locales

Returns supported locale codes.

**Auth:** None

**Response** `200`
```json
{
  "locales": ["en", "es", "fr", "pt", "ko", "zh", "hi", "ar", "sw", "tl"]
}
```

---

## Authentication

### POST /auth/signup

Create a new account.

**Auth:** None

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `email` | string | Yes | Valid email | Account email |
| `password` | string | Yes | Min 8 chars | Account password |
| `displayName` | string | Yes | Min 2 chars | Display name |

**Response** `201`
```json
{
  "accessToken": "eyJhbG...",
  "refreshToken": "eyJhbG..."
}
```

---

### POST /auth/login

Authenticate and receive tokens.

**Auth:** None

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `email` | string | Yes | Valid email | Account email |
| `password` | string | Yes | Min 8 chars | Account password |

**Response** `200`
```json
{
  "accessToken": "eyJhbG...",
  "refreshToken": "eyJhbG..."
}
```

---

### POST /auth/refresh

Refresh an expired access token.

**Auth:** None

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `refreshToken` | string | Yes | Non-empty | Refresh token from login |

**Response** `200`
```json
{
  "accessToken": "eyJhbG...",
  "refreshToken": "eyJhbG..."
}
```

---

### POST /auth/logout

Revoke the refresh token.

**Auth:** None

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `refreshToken` | string | Yes | Non-empty | Refresh token to revoke |

**Response** `200`
```json
{
  "message": "Logged out"
}
```

---

### GET /auth/me

Get the current authenticated user.

**Auth:** JWT Required

**Response** `200`
```json
{
  "id": "uuid",
  "email": "user@example.com",
  "isActive": true,
  "profile": {
    "displayName": "John Doe",
    "language": "en",
    "timezone": "America/New_York",
    "country": "US",
    "avatarUrl": null
  },
  "roles": ["USER"]
}
```

---

## Profile

### GET /me/profile

Get the authenticated user's profile.

**Auth:** JWT Required

**Response** `200`
```json
{
  "id": "uuid",
  "accountId": "uuid",
  "displayName": "John Doe",
  "language": "en",
  "timezone": "America/New_York",
  "country": "US",
  "avatarUrl": null,
  "createdAt": "2026-03-16T10:00:00.000Z",
  "updatedAt": "2026-03-16T10:00:00.000Z"
}
```

---

### PATCH /me/profile

Update the authenticated user's profile.

**Auth:** JWT Required

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `displayName` | string | No | Min 2, max 100 chars | Display name |
| `language` | string | No | ISO 639-1 (e.g. `en`) | Preferred language |
| `timezone` | string | No | IANA timezone (e.g. `America/New_York`) | Timezone |
| `country` | string | No | ISO 3166-1 alpha-2 (e.g. `US`) | Country code |
| `avatarUrl` | string | No | — | Avatar URL |

**Response** `200` — Updated profile object (same shape as GET).

---

## Preferences

### GET /me/preferences

Get the authenticated user's notification preferences.

**Auth:** JWT Required

**Response** `200`
```json
{
  "id": "uuid",
  "accountId": "uuid",
  "notificationEnabled": true,
  "emailEnabled": true,
  "settings": null,
  "createdAt": "2026-03-16T10:00:00.000Z",
  "updatedAt": "2026-03-16T10:00:00.000Z"
}
```

---

### PATCH /me/preferences

Update notification preferences.

**Auth:** JWT Required

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `notificationEnabled` | boolean | No | — | Enable push notifications |
| `emailEnabled` | boolean | No | — | Enable email notifications |
| `settings` | object | No | — | Additional settings (freeform JSON) |

**Response** `200` — Updated preferences object.

---

## Churches

### POST /churches

Create a new church. The creator becomes the church admin.

**Auth:** JWT Required

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `name` | string | Yes | Min 2 chars | Church name |
| `country` | string | Yes | Non-empty | Country code |
| `city` | string | No | — | City name |
| `denomination` | string | No | — | Denomination |
| `description` | string | No | — | Church description |
| `website` | string | No | — | Website URL |
| `primaryLanguage` | string | No | — | Primary language code |

**Response** `201`
```json
{
  "id": "uuid",
  "name": "Grace Community Church",
  "slug": "grace-community-church",
  "country": "US",
  "city": "New York",
  "denomination": "Baptist",
  "website": null,
  "primaryLanguage": "en",
  "isVerified": false,
  "createdAt": "2026-03-16T10:00:00.000Z",
  "updatedAt": "2026-03-16T10:00:00.000Z"
}
```

---

### GET /churches

List churches with optional filters and pagination.

**Auth:** None

**Query Parameters:**

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `page` | number | No | Min 1, default 1 | Page number |
| `limit` | number | No | Min 1, max 100, default 20 | Items per page |
| `country` | string | No | — | Filter by country |
| `city` | string | No | — | Filter by city |
| `language` | string | No | — | Filter by primary language |
| `denomination` | string | No | — | Filter by denomination |
| `search` | string | No | — | Search by name |

**Response** `200`
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Grace Community Church",
      "slug": "grace-community-church",
      "country": "US",
      "city": "New York",
      "denomination": "Baptist",
      "primaryLanguage": "en",
      "isVerified": false,
      "createdAt": "2026-03-16T10:00:00.000Z"
    }
  ],
  "total": 1,
  "page": 1,
  "limit": 20,
  "totalPages": 1
}
```

---

### GET /churches/:churchId

Get a church by ID.

**Auth:** None

**Path Parameters:** `churchId` — UUID

**Response** `200` — Full church object with profile, service times, and supported languages.
```json
{
  "id": "uuid",
  "name": "Grace Community Church",
  "slug": "grace-community-church",
  "country": "US",
  "city": "New York",
  "denomination": "Baptist",
  "website": "https://example.com",
  "primaryLanguage": "en",
  "isVerified": false,
  "profile": {
    "description": "A welcoming church community."
  },
  "serviceTimes": [
    { "dayOfWeek": "Sunday", "startTime": "09:00", "endTime": "11:00" }
  ],
  "supportedLanguages": ["en", "es"]
}
```

---

### GET /churches/:churchId/public-profile

Get the public profile of a church.

**Auth:** None

**Path Parameters:** `churchId` — UUID

**Response** `200` — Church profile data.

---

### PATCH /churches/:churchId

Update a church (admin/pastor only).

**Auth:** JWT Required

**Path Parameters:** `churchId` — UUID

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `name` | string | No | Min 2 chars | Church name |
| `country` | string | No | — | Country code |
| `city` | string | No | — | City name |
| `denomination` | string | No | — | Denomination |
| `description` | string | No | — | Description |
| `website` | string | No | — | Website URL |
| `primaryLanguage` | string | No | — | Primary language |
| `serviceTimes` | array | No | Nested validation | Array of service times |
| `serviceTimes[].dayOfWeek` | string | Yes | — | Day of week |
| `serviceTimes[].startTime` | string | Yes | — | Start time |
| `serviceTimes[].endTime` | string | Yes | — | End time |
| `supportedLanguages` | string[] | No | — | Supported language codes |

**Response** `200` — Updated church object.

---

### POST /churches/:churchId/join-requests

Send a request to join a church.

**Auth:** JWT Required

**Path Parameters:** `churchId` — UUID

**Response** `201`
```json
{
  "id": "uuid",
  "churchId": "uuid",
  "accountId": "uuid",
  "status": "PENDING",
  "createdAt": "2026-03-16T10:00:00.000Z"
}
```

---

### GET /churches/:churchId/join-requests

List join requests for a church (admin/pastor only).

**Auth:** JWT Required

**Path Parameters:** `churchId` — UUID

**Response** `200` — Array of join request objects.

---

### GET /churches/:churchId/members

List members of a church.

**Auth:** JWT Required

**Path Parameters:** `churchId` — UUID

**Query Parameters:**

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `page` | number | No | Min 1, default 1 | Page number |
| `limit` | number | No | Min 1, max 100, default 20 | Items per page |

**Response** `200` — Paginated list of members with roles.
```json
{
  "data": [
    {
      "id": "uuid",
      "displayName": "John Doe",
      "role": "ADMIN",
      "joinedAt": "2026-03-16T10:00:00.000Z"
    }
  ],
  "total": 1,
  "page": 1,
  "limit": 20,
  "totalPages": 1
}
```

---

### PATCH /churches/:churchId/members/:memberId/role

Update a church member's role (admin only).

**Auth:** JWT Required

**Path Parameters:** `churchId` — UUID, `memberId` — UUID

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `role` | string | Yes | Enum: `MEMBER`, `LEADER`, `PASTOR`, `ADMIN` | New role |

**Response** `200` — Updated membership object.

---

## Join Requests

### POST /join-requests/:id/approve

Approve a pending join request (church admin/pastor).

**Auth:** JWT Required

**Path Parameters:** `id` — UUID of the join request

**Response** `200` — Approved join request object.

---

### POST /join-requests/:id/reject

Reject a pending join request (church admin/pastor).

**Auth:** JWT Required

**Path Parameters:** `id` — UUID of the join request

**Response** `200` — Rejected join request object.

---

## Prayers

### POST /me/prayers

Create a new prayer request.

**Auth:** JWT Required

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `title` | string | Yes | Min 1 char | Prayer title |
| `description` | string | No | — | Prayer details |
| `category` | string | No | — | Category (e.g. healing, guidance) |

**Response** `201`
```json
{
  "id": "uuid",
  "accountId": "uuid",
  "title": "Healing for mom",
  "description": "Praying for her recovery",
  "category": "healing",
  "status": "ACTIVE",
  "answeredAt": null,
  "createdAt": "2026-03-16T10:00:00.000Z",
  "updatedAt": "2026-03-16T10:00:00.000Z"
}
```

---

### GET /me/prayers

List the authenticated user's prayers.

**Auth:** JWT Required

**Query Parameters:**

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `status` | string | No | Enum: `ACTIVE`, `ANSWERED`, `ARCHIVED` | Filter by status |

**Response** `200` — Array of prayer objects.

---

### PATCH /me/prayers/:id

Update a prayer.

**Auth:** JWT Required

**Path Parameters:** `id` — UUID

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `title` | string | No | Min 1 char | Prayer title |
| `description` | string | No | — | Prayer details |
| `status` | string | No | Enum: `ACTIVE`, `ANSWERED`, `ARCHIVED` | Prayer status |

**Response** `200` — Updated prayer object.

---

### DELETE /me/prayers/:id

Delete a prayer (soft delete).

**Auth:** JWT Required

**Path Parameters:** `id` — UUID

**Response** `200`
```json
{ "deleted": true }
```

---

## Reminders

### POST /me/reminders

Create a new reminder.

**Auth:** JWT Required

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `type` | string | Yes | Enum: `PRAYER`, `READING`, `CUSTOM` | Reminder type |
| `time` | string | Yes | Format: `HH:MM` or `HH:MM:SS` | Time of day |
| `timezone` | string | Yes | — | IANA timezone (e.g. `America/New_York`) |
| `recurrence` | string | No | Enum: `DAILY`, `WEEKLY`, `NONE` | Recurrence pattern |
| `enabled` | boolean | No | Default: true | Whether reminder is active |

**Response** `201`
```json
{
  "id": "uuid",
  "accountId": "uuid",
  "type": "PRAYER",
  "time": "09:00",
  "timezone": "America/New_York",
  "recurrence": "DAILY",
  "enabled": true,
  "lastTriggeredAt": null,
  "createdAt": "2026-03-16T10:00:00.000Z",
  "updatedAt": "2026-03-16T10:00:00.000Z"
}
```

---

### GET /me/reminders

List the authenticated user's reminders.

**Auth:** JWT Required

**Response** `200` — Array of reminder objects.

---

### PATCH /me/reminders/:id

Update a reminder.

**Auth:** JWT Required

**Path Parameters:** `id` — UUID

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `type` | string | No | Enum: `PRAYER`, `READING`, `CUSTOM` | Reminder type |
| `time` | string | No | Format: `HH:MM` or `HH:MM:SS` | Time of day |
| `timezone` | string | No | — | IANA timezone |
| `recurrence` | string | No | Enum: `DAILY`, `WEEKLY`, `NONE` | Recurrence pattern |
| `enabled` | boolean | No | — | Whether reminder is active |

**Response** `200` — Updated reminder object.

---

### DELETE /me/reminders/:id

Delete a reminder.

**Auth:** JWT Required

**Path Parameters:** `id` — UUID

**Response** `200`
```json
{ "deleted": true }
```

---

## Bible

### GET /bible/translations

List all available Bible translations.

**Auth:** None

**Response** `200`
```json
[
  {
    "id": "uuid",
    "code": "KJV",
    "name": "King James Version",
    "language": "en"
  }
]
```

---

### GET /bible/search

Search Bible verses by keyword.

**Auth:** None

**Query Parameters:**

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `q` | string | Yes | Min 2 chars | Search query |
| `translation` | string | No | — | Filter by translation code |

**Response** `200`
```json
[
  {
    "id": "uuid",
    "bookName": "John",
    "chapterNumber": 3,
    "verseNumber": 16,
    "text": "For God so loved the world..."
  }
]
```

---

### GET /bible/:translation/:book/:chapter

Read a Bible chapter.

**Auth:** None

**Path Parameters:**
- `translation` — Translation code (e.g. `KJV`)
- `book` — Book name (e.g. `John`)
- `chapter` — Chapter number (integer)

**Response** `200`
```json
{
  "translation": { "code": "KJV", "name": "King James Version" },
  "book": { "name": "John", "abbreviation": "Jhn" },
  "chapter": 3,
  "verses": [
    { "id": "uuid", "verseNumber": 1, "text": "There was a man of the Pharisees..." },
    { "id": "uuid", "verseNumber": 2, "text": "The same came to Jesus by night..." }
  ]
}
```

---

## Bookmarks

### POST /me/bookmarks

Bookmark a Bible verse.

**Auth:** JWT Required

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `verseId` | string | Yes | UUID | ID of the verse to bookmark |
| `note` | string | No | — | Optional note |

**Response** `201`
```json
{
  "id": "uuid",
  "accountId": "uuid",
  "verseId": "uuid",
  "note": "Favorite verse",
  "createdAt": "2026-03-16T10:00:00.000Z"
}
```

---

### GET /me/bookmarks

List the authenticated user's bookmarks.

**Auth:** JWT Required

**Response** `200` — Array of bookmark objects with populated verse data.
```json
[
  {
    "id": "uuid",
    "note": "Favorite verse",
    "verse": {
      "id": "uuid",
      "bookName": "John",
      "chapterNumber": 3,
      "verseNumber": 16,
      "text": "For God so loved the world..."
    },
    "createdAt": "2026-03-16T10:00:00.000Z"
  }
]
```

---

### DELETE /me/bookmarks/:id

Delete a bookmark.

**Auth:** JWT Required

**Path Parameters:** `id` — UUID

**Response** `200`
```json
{ "deleted": true }
```

---

## Reading Plans

### GET /reading-plans

List all available reading plans.

**Auth:** None

**Response** `200`
```json
[
  {
    "id": "uuid",
    "name": "30 Days of Psalms",
    "description": "Read through the book of Psalms in 30 days",
    "totalDays": 30,
    "isActive": true,
    "createdAt": "2026-03-16T10:00:00.000Z"
  }
]
```

---

### POST /reading-plans/:planId/start

Start a reading plan.

**Auth:** JWT Required

**Path Parameters:** `planId` — UUID

**Response** `201` — User reading progress object with plan days.

---

## Reading Progress

### GET /me/reading-progress

Get the authenticated user's reading progress across all started plans.

**Auth:** JWT Required

**Response** `200` — Array of progress objects with plan and day details.
```json
[
  {
    "id": "uuid",
    "planId": "uuid",
    "plan": {
      "name": "30 Days of Psalms",
      "totalDays": 30
    },
    "days": [
      { "id": "uuid", "dayNumber": 1, "title": "Psalm 1-5", "completedAt": "2026-03-16T10:00:00.000Z" },
      { "id": "uuid", "dayNumber": 2, "title": "Psalm 6-10", "completedAt": null }
    ],
    "startedAt": "2026-03-15T10:00:00.000Z"
  }
]
```

---

### POST /me/reading-progress/:dayId/complete

Mark a reading plan day as complete.

**Auth:** JWT Required

**Path Parameters:** `dayId` — UUID of the reading plan day

**Response** `200` — Updated progress object.

---

## Groups

### POST /churches/:churchId/groups

Create a group within a church.

**Auth:** JWT Required

**Path Parameters:** `churchId` — UUID

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `name` | string | Yes | Min 2 chars | Group name |
| `description` | string | No | — | Group description |
| `visibility` | string | No | Enum: `PUBLIC`, `PRIVATE` | Visibility (default: PUBLIC) |

**Response** `201`
```json
{
  "id": "uuid",
  "churchId": "uuid",
  "name": "Youth Bible Study",
  "description": "Weekly study for youth",
  "visibility": "PUBLIC",
  "status": "PENDING",
  "createdBy": "uuid",
  "createdAt": "2026-03-16T10:00:00.000Z",
  "updatedAt": "2026-03-16T10:00:00.000Z"
}
```

---

### GET /groups

List groups. Optionally shows user's membership status if authenticated.

**Auth:** Optional

**Response** `200` — Array of group objects.

---

### GET /groups/:groupId

Get group details.

**Auth:** Optional

**Path Parameters:** `groupId` — UUID

**Response** `200` — Full group object with church info.

---

### POST /groups/:groupId/approve

Approve a pending group (church admin/pastor).

**Auth:** JWT Required

**Path Parameters:** `groupId` — UUID

**Response** `200` — Approved group object with `status: "ACTIVE"`.

---

### POST /groups/:groupId/join

Join a group.

**Auth:** JWT Required

**Path Parameters:** `groupId` — UUID

**Response** `200` — Group membership object.

---

### GET /groups/:groupId/members

List members of a group.

**Auth:** Optional

**Path Parameters:** `groupId` — UUID

**Response** `200` — Array of member objects.
```json
[
  {
    "id": "uuid",
    "displayName": "John Doe",
    "role": "LEADER",
    "joinedAt": "2026-03-16T10:00:00.000Z"
  }
]
```

---

## Events

### POST /churches/:churchId/events

Create an event for a church.

**Auth:** JWT Required

**Path Parameters:** `churchId` — UUID

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `title` | string | Yes | Min 2 chars | Event title |
| `description` | string | No | — | Event description |
| `startTime` | string | Yes | ISO 8601 datetime | Start time |
| `endTime` | string | Yes | ISO 8601 datetime | End time |
| `location` | string | No | — | Event location |
| `visibility` | string | No | Enum: `PUBLIC`, `CHURCH`, `GROUP` | Visibility (default: PUBLIC) |

**Response** `201`
```json
{
  "id": "uuid",
  "churchId": "uuid",
  "title": "Sunday Service",
  "description": "Weekly worship service",
  "startTime": "2026-03-17T09:00:00.000Z",
  "endTime": "2026-03-17T11:00:00.000Z",
  "location": "Main Sanctuary",
  "visibility": "PUBLIC",
  "createdBy": "uuid",
  "createdAt": "2026-03-16T10:00:00.000Z"
}
```

---

### GET /events

List events. Optionally personalized if authenticated.

**Auth:** Optional

**Response** `200` — Array of event objects.

---

### GET /events/:eventId

Get event details.

**Auth:** Optional

**Path Parameters:** `eventId` — UUID

**Response** `200` — Full event object.

---

### PATCH /events/:eventId

Update an event (creator or church admin only).

**Auth:** JWT Required

**Path Parameters:** `eventId` — UUID

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `title` | string | No | Min 2 chars | Event title |
| `description` | string | No | — | Event description |
| `startTime` | string | No | ISO 8601 datetime | Start time |
| `endTime` | string | No | ISO 8601 datetime | End time |
| `location` | string | No | — | Event location |
| `visibility` | string | No | Enum: `PUBLIC`, `CHURCH`, `GROUP` | Visibility |

**Response** `200` — Updated event object.

---

### POST /events/:eventId/rsvp

RSVP to an event.

**Auth:** JWT Required

**Path Parameters:** `eventId` — UUID

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `status` | string | Yes | Enum: `GOING`, `MAYBE`, `NOT_GOING` | RSVP status |

**Response** `200`
```json
{
  "id": "uuid",
  "eventId": "uuid",
  "accountId": "uuid",
  "status": "GOING",
  "createdAt": "2026-03-16T10:00:00.000Z"
}
```

---

## Broadcasts

### POST /churches/:churchId/broadcasts

Create a broadcast for a church.

**Auth:** JWT Required

**Path Parameters:** `churchId` — UUID

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `title` | string | Yes | Min 1 char | Broadcast title |
| `content` | string | Yes | Min 1 char | Broadcast message content |
| `targetAudience` | string | No | — | Target audience (e.g. ALL, MEMBERS) |

**Response** `201`
```json
{
  "id": "uuid",
  "churchId": "uuid",
  "title": "Sunday Service Update",
  "content": "Service moved to 10am this week.",
  "targetAudience": "ALL",
  "status": "DRAFT",
  "publishedAt": null,
  "createdBy": "uuid",
  "createdAt": "2026-03-16T10:00:00.000Z"
}
```

---

### GET /churches/:churchId/broadcasts

List broadcasts for a church.

**Auth:** JWT Required

**Path Parameters:** `churchId` — UUID

**Response** `200` — Array of broadcast objects.

---

### POST /broadcasts/:id/publish

Publish a draft broadcast.

**Auth:** JWT Required

**Path Parameters:** `id` — UUID of the broadcast

**Response** `200` — Updated broadcast with `status: "PUBLISHED"` and `publishedAt` set.

---

### GET /broadcasts/:id

Get a broadcast by ID.

**Auth:** None

**Path Parameters:** `id` — UUID of the broadcast

**Response** `200` — Full broadcast object.

---

## Media

### POST /media/upload-url

Get a presigned upload URL for a file.

**Auth:** JWT Required

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `fileName` | string | Yes | Min 1 char | File name (e.g. `photo.jpg`) |
| `contentType` | string | Yes | Min 1 char | MIME type (e.g. `image/jpeg`) |
| `context` | string | Yes | Enum: `AVATAR`, `EVENT`, `BROADCAST` | Upload context |

**Response** `200`
```json
{
  "url": "https://s3.amazonaws.com/...",
  "key": "uploads/uuid/photo.jpg"
}
```

---

### POST /media/assets

Register an uploaded file as a media asset.

**Auth:** JWT Required

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `key` | string | Yes | Min 1 char | S3 key from upload |
| `contentType` | string | Yes | Min 1 char | MIME type |
| `size` | number | Yes | Min 1 | File size in bytes |
| `context` | string | Yes | Enum: `AVATAR`, `EVENT`, `BROADCAST` | Asset context |

**Response** `201`
```json
{
  "id": "uuid",
  "accountId": "uuid",
  "key": "uploads/uuid/photo.jpg",
  "contentType": "image/jpeg",
  "size": 102400,
  "context": "AVATAR",
  "createdAt": "2026-03-16T10:00:00.000Z"
}
```

---

### GET /media/assets/:id

Get a media asset by ID.

**Auth:** JWT Required

**Path Parameters:** `id` — UUID

**Response** `200` — Media asset object.

---

## Verification

### POST /verification/pastor

Submit a pastor verification request.

**Auth:** JWT Required

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `fullName` | string | Yes | Min 1 char | Pastor's full name |
| `churchAffiliation` | string | Yes | Min 1 char | Church affiliation |
| `notes` | string | No | — | Additional notes |

**Response** `201`
```json
{
  "id": "uuid",
  "accountId": "uuid",
  "type": "PASTOR",
  "status": "SUBMITTED",
  "notes": "Senior pastor since 2015",
  "createdAt": "2026-03-16T10:00:00.000Z"
}
```

---

### POST /verification/church

Submit a church verification request.

**Auth:** JWT Required

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `churchId` | string | Yes | UUID | ID of the church to verify |
| `notes` | string | No | — | Additional notes |

**Response** `201`
```json
{
  "id": "uuid",
  "accountId": "uuid",
  "churchId": "uuid",
  "type": "CHURCH",
  "status": "SUBMITTED",
  "createdAt": "2026-03-16T10:00:00.000Z"
}
```

---

### POST /verification/:id/documents

Attach supporting documents to a verification request.

**Auth:** JWT Required

**Path Parameters:** `id` — UUID of the verification request

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `mediaAssetIds` | string[] | Yes | Array of UUIDs, min 1 | Media asset IDs to attach |

**Response** `200` — Updated verification request.

---

### GET /verification/:id

Get the status of a verification request.

**Auth:** JWT Required

**Path Parameters:** `id` — UUID of the verification request

**Response** `200`
```json
{
  "id": "uuid",
  "accountId": "uuid",
  "type": "PASTOR",
  "status": "SUBMITTED",
  "notes": "Senior pastor since 2015",
  "reviewedBy": null,
  "reviewedAt": null,
  "createdAt": "2026-03-16T10:00:00.000Z",
  "updatedAt": "2026-03-16T10:00:00.000Z"
}
```

---

## Ops Verification

> These endpoints require the `PLATFORM_ADMIN` role.

### POST /ops/verification/:id/approve

Approve a verification request.

**Auth:** JWT Required + `PLATFORM_ADMIN` role

**Path Parameters:** `id` — UUID of the verification request

**Response** `200` — Approved verification with `status: "APPROVED"`.

---

### POST /ops/verification/:id/reject

Reject a verification request.

**Auth:** JWT Required + `PLATFORM_ADMIN` role

**Path Parameters:** `id` — UUID of the verification request

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `reason` | string | No | — | Reason for rejection |

**Response** `200` — Rejected verification with `status: "REJECTED"`.

---

## Enums Reference

### GlobalRole
`USER` | `PASTOR` | `CHURCH_ADMIN` | `CHURCH_MEMBER` | `GROUP_LEADER` | `PLATFORM_ADMIN`

### ChurchMembershipRole
`MEMBER` | `LEADER` | `PASTOR` | `ADMIN`

### GroupMembershipRole
`MEMBER` | `LEADER`

### GroupVisibility
`PUBLIC` | `PRIVATE`

### GroupStatus
`PENDING` | `ACTIVE` | `ARCHIVED`

### JoinRequestStatus
`PENDING` | `APPROVED` | `REJECTED`

### PrayerStatus
`ACTIVE` | `ANSWERED` | `ARCHIVED`

### ReminderType
`PRAYER` | `READING` | `CUSTOM`

### Recurrence
`DAILY` | `WEEKLY` | `NONE`

### EventVisibility
`PUBLIC` | `CHURCH` | `GROUP`

### RsvpStatus
`GOING` | `MAYBE` | `NOT_GOING`

### BroadcastStatus
`DRAFT` | `PUBLISHED`

### MediaContext
`AVATAR` | `EVENT` | `BROADCAST`

### VerificationType
`PASTOR` | `CHURCH`

### VerificationStatus
`SUBMITTED` | `UNDER_REVIEW` | `APPROVED` | `REJECTED`

### DonationType
`TITHE` | `OFFERING` | `DONATION`

### DonationStatus
`PENDING` | `COMPLETED` | `FAILED`

### DevicePlatform
`IOS` | `ANDROID` | `WEB`

### NotificationDeliveryStatus
`PENDING` | `SENT` | `FAILED`

### ChatMessageType
`TEXT`

---

## Error Responses

All errors follow a consistent format with correlation ID tracking:

```json
{
  "statusCode": 400,
  "message": "Validation failed",
  "error": "Bad Request",
  "correlationId": "uuid"
}
```

### Common Status Codes

| Code | Description |
|------|-------------|
| `400` | Validation error — check request body/query params |
| `401` | Unauthorized — missing or invalid JWT token |
| `403` | Forbidden — insufficient role/permissions |
| `404` | Not found — resource does not exist |
| `409` | Conflict — duplicate resource (e.g. email already taken) |
| `500` | Internal server error |

### Validation Errors

When multiple fields fail validation, the `message` field contains an array of error strings:

```json
{
  "statusCode": 400,
  "message": [
    "email must be an email",
    "password must be longer than or equal to 8 characters"
  ],
  "error": "Bad Request"
}
```
