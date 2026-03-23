# Ekklesia Backend — Service Documentation

Comprehensive documentation for all 24 services across the Ekklesia backend monorepo.

---

## Table of Contents

### Shared Packages
- [LoggerService](#loggerservice)
- [JwtService](#jwtservice)

### Mobile API (`apps/mobile-api`)
- [AuthService](#authservice)
- [ProfileService](#profileservice)
- [PreferencesService](#preferencesservice)
- [ChurchesService](#churchesservice)
- [PrayersService](#prayersservice)
- [RemindersService](#remindersservice)
- [BibleService](#bibleservice)
- [BookmarksService](#bookmarksservice)
- [ReadingPlansService](#readingplansservice)
- [GroupsService](#groupsservice)
- [EventsService](#eventsservice)
- [BroadcastsService](#broadcastsservice)
- [MediaService](#mediaservice)
- [VerificationsService](#verificationsservice)

### Admin API (`apps/admin-api`)
- [DashboardService](#dashboardservice)

### Chat Service (`apps/chat-service`)
- [ChatService](#chatservice)

### Donation Service (`apps/donation-service`)
- [DonationsService](#donationsservice)

### Notification Service (`apps/notification-service`)
- [DeviceTokensService](#devicetokensservice)
- [NotificationsService](#notificationsservice)
- [DeliveryService](#deliveryservice)

### Worker Service (`apps/worker-service`)
- [ReminderWorkerService](#reminderworkerservice)
- [SearchWorkerService](#searchworkerservice)

---

## Shared Packages

### LoggerService

**Package:** `@ekklesia/logging`
**File:** `packages/logging/src/logger.service.ts`

Structured JSON logger wrapping [pino](https://getpino.io/). Injected across all apps for consistent, structured logging.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `info` | `message: string`, `data?: Record<string, unknown>` | `void` | Log at INFO level |
| `warn` | `message: string`, `data?: Record<string, unknown>` | `void` | Log at WARN level |
| `error` | `message: string`, `data?: Record<string, unknown>` | `void` | Log at ERROR level |
| `debug` | `message: string`, `data?: Record<string, unknown>` | `void` | Log at DEBUG level |
| `child` | `bindings: Record<string, unknown>` | `LoggerService` | Create child logger with additional context |

#### Usage

```typescript
constructor(private readonly logger: LoggerService) {}

this.logger.info('User signed up', { userId: account.id });
this.logger.child({ requestId }).warn('Slow query detected');
```

---

### JwtService

**Package:** `@ekklesia/auth`
**File:** `packages/auth/src/jwt.service.ts`

JWT token management. Signs access and refresh tokens using configured secrets and expiration times.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `signAccessToken` | `payload: { sub, email, roles }` | `string` | Sign a short-lived access token |
| `signRefreshToken` | `payload: { sub }` | `string` | Sign a long-lived refresh token |
| `verifyToken` | `token: string` | `JwtPayload` | Verify and decode a token |

#### Configuration

| Field | Type | Description |
|-------|------|-------------|
| `JWT_SECRET` | `string` | Secret for signing access tokens |
| `JWT_REFRESH_SECRET` | `string` | Secret for signing refresh tokens |
| `JWT_EXPIRES_IN` | `string` | Access token TTL (e.g. `"15m"`) |
| `JWT_REFRESH_EXPIRES_IN` | `string` | Refresh token TTL (e.g. `"7d"`) |

---

## Mobile API

### AuthService

**File:** `apps/mobile-api/src/auth/auth.service.ts`

User authentication — signup, login, token refresh, and logout. Passwords hashed with bcrypt. Refresh tokens stored in the database.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `signup` | `dto: SignupDto` | `Promise<{ accessToken, refreshToken, user }>` | Register new account with profile |
| `login` | `dto: LoginDto` | `Promise<{ accessToken, refreshToken }>` | Authenticate with email/password |
| `refresh` | `dto: RefreshDto` | `Promise<{ accessToken, refreshToken }>` | Rotate token pair using refresh token |
| `getMe` | `userId: string` | `Promise<{ id, email, roles, profile }>` | Get current user details |
| `logout` | `dto: LogoutDto` | `Promise<{ message }>` | Revoke refresh token |

#### SignupDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `email` | `string` | Yes | Valid email, unique |
| `password` | `string` | Yes | Min 8 characters |
| `displayName` | `string` | Yes | Min 2, max 50 characters |

#### LoginDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `email` | `string` | Yes | Valid email |
| `password` | `string` | Yes | Non-empty |

---

### ProfileService

**File:** `apps/mobile-api/src/profile/profile.service.ts`

User profile management. Each account has one profile created at signup.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `getProfile` | `accountId: string` | `Promise<{ displayName, language, timezone, country, avatarUrl }>` | Get user's profile |
| `updateProfile` | `accountId: string`, `dto: UpdateProfileDto` | `Promise<{ displayName, language, timezone, country, avatarUrl }>` | Partial update profile fields |

#### UpdateProfileDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `displayName` | `string` | No | Min 2, max 50 |
| `language` | `string` | No | ISO 639-1 code |
| `timezone` | `string` | No | IANA timezone |
| `country` | `string` | No | ISO 3166-1 alpha-2 |
| `avatarUrl` | `string` | No | Valid URL |

---

### PreferencesService

**File:** `apps/mobile-api/src/preferences/preferences.service.ts`

User notification and email preferences. Settings stored as JSON.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `getPreferences` | `accountId: string` | `Promise<{ notificationEnabled, emailEnabled, settings }>` | Get current preferences |
| `updatePreferences` | `accountId: string`, `dto: UpdatePreferencesDto` | `Promise<{ notificationEnabled, emailEnabled, settings }>` | Update preferences |

#### UpdatePreferencesDto

| Field | Type | Required |
|-------|------|----------|
| `notificationEnabled` | `boolean` | No |
| `emailEnabled` | `boolean` | No |
| `settings` | `Record<string, unknown>` | No |

---

### ChurchesService

**File:** `apps/mobile-api/src/churches/churches.service.ts`

Church CRUD, membership management, and join request workflows. Publishes domain events for church lifecycle operations.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `create` | `dto: CreateChurchDto`, `userId: string` | `Promise<Church>` | Create a church (creator becomes admin) |
| `findAll` | `query: ListChurchesDto` | `Promise<PaginatedResult>` | List churches with pagination and filters |
| `findById` | `churchId: string` | `Promise<Church>` | Get full church detail with profile |
| `getPublicProfile` | `churchId: string` | `Promise<Church>` | Get public-facing church info |
| `update` | `churchId: string`, `dto: UpdateChurchDto`, `userId: string` | `Promise<Church>` | Update church details (admin/pastor only) |
| `createJoinRequest` | `churchId: string`, `userId: string` | `Promise<JoinRequest>` | Submit a join request |
| `listJoinRequests` | `churchId: string`, `userId: string` | `Promise<JoinRequest[]>` | List pending join requests (admin/pastor) |
| `approveJoinRequest` | `joinRequestId: string`, `userId: string` | `Promise<JoinRequest>` | Approve a join request |
| `rejectJoinRequest` | `joinRequestId: string`, `userId: string` | `Promise<JoinRequest>` | Reject a join request |
| `listMembers` | `churchId: string`, `userId: string`, `query: ListMembersDto` | `Promise<PaginatedResult>` | List church members with pagination |
| `updateMemberRole` | `churchId: string`, `memberId: string`, `dto: UpdateMemberRoleDto`, `userId: string` | `Promise<Membership>` | Change a member's role |

#### CreateChurchDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `name` | `string` | Yes | Min 2, max 100 |
| `slug` | `string` | Yes | Lowercase, URL-safe |
| `country` | `string` | Yes | ISO 3166-1 alpha-2 |
| `city` | `string` | Yes | Non-empty |
| `denomination` | `Denomination` | Yes | Enum value |
| `website` | `string` | No | Valid URL |
| `primaryLanguage` | `string` | Yes | ISO 639-1 |

#### UpdateChurchDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `name` | `string` | No | Min 2, max 100 |
| `description` | `string` | No | Max 2000 |
| `website` | `string` | No | Valid URL |
| `city` | `string` | No | Non-empty |
| `serviceTimes` | `ServiceTime[]` | No | Day + time objects |
| `supportedLanguages` | `string[]` | No | ISO 639-1 codes |

#### Domain Events Published

- `church.created` — when a new church is registered
- `church.updated` — when church details change
- `church.join_request.approved` — when a join request is approved

---

### PrayersService

**File:** `apps/mobile-api/src/prayers/prayers.service.ts`

Personal prayer journal. Users create, track, and manage prayers with status tracking.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `create` | `accountId: string`, `dto: CreatePrayerDto` | `Promise<Prayer>` | Create a new prayer |
| `findAll` | `accountId: string`, `status?: PrayerStatus` | `Promise<Prayer[]>` | List prayers, optionally filtered |
| `update` | `accountId: string`, `prayerId: string`, `dto: UpdatePrayerDto` | `Promise<Prayer>` | Update prayer text or status |
| `remove` | `accountId: string`, `prayerId: string` | `Promise<void>` | Delete a prayer |

#### CreatePrayerDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `title` | `string` | Yes | Min 1, max 200 |
| `description` | `string` | No | Max 2000 |
| `category` | `PrayerCategory` | No | Enum: `personal`, `family`, `church`, `world` |

#### PrayerStatus Enum

`active` | `answered` | `archived`

---

### RemindersService

**File:** `apps/mobile-api/src/reminders/reminders.service.ts`

Scheduled reminders with timezone awareness and recurrence. Triggered by the worker service.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `create` | `accountId: string`, `dto: CreateReminderDto` | `Promise<Reminder>` | Create a reminder |
| `findAll` | `accountId: string` | `Promise<Reminder[]>` | List all reminders |
| `update` | `accountId: string`, `reminderId: string`, `dto: UpdateReminderDto` | `Promise<Reminder>` | Update reminder settings |
| `remove` | `accountId: string`, `reminderId: string` | `Promise<void>` | Delete a reminder |

#### CreateReminderDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `type` | `ReminderType` | Yes | Enum: `prayer`, `bible_reading`, `custom` |
| `time` | `string` | Yes | HH:mm format |
| `timezone` | `string` | Yes | IANA timezone |
| `recurrence` | `Recurrence` | No | `none`, `daily`, `weekly` (default: `none`) |

---

### BibleService

**File:** `apps/mobile-api/src/bible/bible.service.ts`

Bible content access — translations, chapters, and verse search. Public (no auth required).

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `listTranslations` | — | `Promise<Translation[]>` | List available translations |
| `readChapter` | `translationCode: string`, `bookName: string`, `chapterNumber: number` | `Promise<{ translation, book, chapter, verses }>` | Read a full chapter |
| `searchVerses` | `query: string`, `translationCode?: string` | `Promise<Verse[]>` | Full-text search across verses |

#### Response: Chapter

```json
{
  "translation": { "id": "...", "code": "KJV", "name": "King James Version" },
  "book": "John",
  "chapter": 3,
  "verses": [
    { "id": "...", "number": 16, "text": "For God so loved the world..." }
  ]
}
```

---

### BookmarksService

**File:** `apps/mobile-api/src/bookmarks/bookmarks.service.ts`

Bible verse bookmarks with optional notes. Returns bookmarks with full verse context.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `create` | `accountId: string`, `verseId: string`, `note?: string` | `Promise<Bookmark>` | Bookmark a verse |
| `findAll` | `accountId: string` | `Promise<Bookmark[]>` | List all bookmarks with verse details |
| `remove` | `accountId: string`, `bookmarkId: string` | `Promise<void>` | Remove a bookmark |

#### CreateBookmarkDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `verseId` | `string` | Yes | Valid UUID |
| `note` | `string` | No | Max 500 |

---

### ReadingPlansService

**File:** `apps/mobile-api/src/reading-plans/reading-plans.service.ts`

Bible reading plan enrollment and progress tracking. Publishes events on enrollment and day completion.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `findAll` | — | `Promise<ReadingPlan[]>` | List all available plans |
| `startPlan` | `accountId: string`, `planId: string` | `Promise<Enrollment>` | Enroll in a reading plan |
| `completeDay` | `accountId: string`, `dayId: string` | `Promise<DayCompletion>` | Mark a day as complete |
| `getProgress` | `accountId: string` | `Promise<Progress[]>` | Get progress for all enrolled plans |

#### Response: Progress

```json
{
  "planId": "uuid",
  "planName": "30 Days with Psalms",
  "totalDays": 30,
  "completedDays": 12,
  "progressPercentage": 40
}
```

#### Domain Events Published

- `reading_plan.enrolled` — user starts a plan
- `reading_plan.day_completed` — user completes a day

---

### GroupsService

**File:** `apps/mobile-api/src/groups/groups.service.ts`

Church small groups — creation, approval, membership, and visibility management.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `createGroup` | `churchId: string`, `dto: CreateGroupDto`, `userId: string` | `Promise<Group>` | Create a group within a church |
| `approveGroup` | `groupId: string`, `userId: string` | `Promise<Group>` | Approve a pending group |
| `listGroups` | `userId?: string` | `Promise<Group[]>` | List visible groups |
| `getGroupDetail` | `groupId: string`, `userId?: string` | `Promise<Group>` | Get group detail with member count |
| `joinGroup` | `groupId: string`, `userId: string` | `Promise<Membership>` | Join a group |
| `listMembers` | `groupId: string`, `userId?: string` | `Promise<Member[]>` | List group members |

#### CreateGroupDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `name` | `string` | Yes | Min 2, max 100 |
| `description` | `string` | No | Max 500 |
| `visibility` | `GroupVisibility` | No | `public`, `private` (default: `public`) |

#### Domain Events Published

- `group.created` — new group created
- `group.approved` — group approved by admin
- `group.member_joined` — member joins a group

---

### EventsService

**File:** `apps/mobile-api/src/events/events.service.ts`

Church events — creation, updates, listing, and RSVP tracking with visibility controls.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `createEvent` | `churchId: string`, `dto: CreateEventDto`, `userId: string` | `Promise<Event>` | Create a church event |
| `updateEvent` | `eventId: string`, `dto: UpdateEventDto`, `userId: string` | `Promise<Event>` | Update event details |
| `listEvents` | `userId?: string` | `Promise<Event[]>` | List visible events |
| `getEventDetail` | `eventId: string`, `userId?: string` | `Promise<Event>` | Get full event detail |
| `rsvpToEvent` | `eventId: string`, `dto: RsvpEventDto`, `userId: string` | `Promise<Rsvp>` | RSVP to an event |

#### CreateEventDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `title` | `string` | Yes | Min 2, max 200 |
| `description` | `string` | No | Max 2000 |
| `location` | `string` | No | Max 200 |
| `startsAt` | `string` | Yes | ISO 8601 datetime |
| `endsAt` | `string` | No | ISO 8601 datetime |
| `visibility` | `EventVisibility` | No | `public`, `church`, `group` |

#### RsvpEventDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `status` | `RsvpStatus` | Yes | `going`, `interested`, `not_going` |

#### Domain Events Published

- `event.created` — new event created
- `event.updated` — event details changed

---

### BroadcastsService

**File:** `apps/mobile-api/src/broadcasts/broadcasts.service.ts`

Church announcements and broadcasts. Draft-then-publish workflow for church admins and pastors.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `createBroadcast` | `churchId: string`, `dto: CreateBroadcastDto`, `userId: string` | `Promise<Broadcast>` | Create a draft broadcast |
| `listBroadcasts` | `churchId: string` | `Promise<Broadcast[]>` | List church broadcasts |
| `publishBroadcast` | `broadcastId: string`, `userId: string` | `Promise<Broadcast>` | Publish a draft broadcast |
| `getBroadcastDetail` | `broadcastId: string` | `Promise<Broadcast>` | Get broadcast details |

#### CreateBroadcastDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `title` | `string` | Yes | Min 2, max 200 |
| `body` | `string` | Yes | Min 1, max 5000 |
| `audience` | `BroadcastAudience` | No | `all_members`, `leaders` (default: `all_members`) |

#### Broadcast Status Flow

`draft` → `published`

---

### MediaService

**File:** `apps/mobile-api/src/media/media.service.ts`

Presigned URL media upload system. Two-step flow: get upload URL, then register the asset.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `getUploadUrl` | `dto: GetUploadUrlDto`, `userId: string` | `Promise<{ uploadUrl, key, maxSize, contentType, context, expiresIn }>` | Get a presigned upload URL |
| `registerAsset` | `dto: RegisterAssetDto`, `userId: string` | `Promise<Asset>` | Register an uploaded file as an asset |
| `getAsset` | `assetId: string` | `Promise<Asset>` | Retrieve asset metadata with CDN URL |

#### GetUploadUrlDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `contentType` | `string` | Yes | MIME type (e.g. `image/jpeg`) |
| `context` | `MediaContext` | Yes | `avatar`, `church_logo`, `verification_doc`, `broadcast_image` |

#### RegisterAssetDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `key` | `string` | Yes | The key returned from `getUploadUrl` |
| `contentType` | `string` | Yes | Must match the upload URL request |
| `size` | `number` | Yes | File size in bytes |
| `context` | `MediaContext` | Yes | Must match the upload URL request |

#### Upload Flow

1. `POST /media/upload-url` → Get presigned URL + key
2. Upload file directly to cloud storage using the URL
3. `POST /media/assets` → Register the asset with the key

---

### VerificationsService

**File:** `apps/mobile-api/src/verifications/verifications.service.ts`

Pastor and church verification workflows. Submit → attach docs → admin review → approve/reject.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `submitPastorVerification` | `dto: SubmitPastorVerificationDto`, `userId: string` | `Promise<VerificationRequest>` | Submit pastor verification request |
| `submitChurchVerification` | `dto: SubmitChurchVerificationDto`, `userId: string` | `Promise<VerificationRequest>` | Submit church verification request |
| `attachDocuments` | `verificationId: string`, `dto: AttachDocumentsDto`, `userId: string` | `Promise<{ verificationRequestId, documents }>` | Attach supporting documents |
| `getVerificationStatus` | `verificationId: string`, `userId: string` | `Promise<VerificationRequest>` | Check verification status |
| `approveVerification` | `verificationId: string`, `adminId: string` | `Promise<VerificationRequest>` | Approve request (admin only) |
| `rejectVerification` | `verificationId: string`, `adminId: string`, `dto: RejectVerificationDto` | `Promise<VerificationRequest>` | Reject request with reason (admin only) |

#### SubmitPastorVerificationDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `churchId` | `string` | Yes | Valid UUID |
| `ordinationDate` | `string` | Yes | ISO date |
| `denomination` | `Denomination` | Yes | Enum value |
| `notes` | `string` | No | Max 1000 |

#### SubmitChurchVerificationDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `churchId` | `string` | Yes | Valid UUID |
| `registrationNumber` | `string` | Yes | Non-empty |
| `registrationCountry` | `string` | Yes | ISO 3166-1 alpha-2 |
| `notes` | `string` | No | Max 1000 |

#### Verification Status Flow

`pending` → `approved` | `rejected`

#### Domain Events Published

- `verification.submitted` — new verification request
- `verification.approved` — request approved
- `verification.rejected` — request rejected

---

## Admin API

### DashboardService

**File:** `apps/admin-api/src/dashboard/dashboard.service.ts`

Admin dashboard data. Provides aggregate views for platform administration.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `listChurches` | — | `Promise<Church[]>` | List all churches with basic info |
| `listPendingVerifications` | — | `Promise<VerificationRequest[]>` | List pending verification requests |
| `listJoinRequests` | — | `Promise<JoinRequest[]>` | List all join requests |
| `listUsers` | `search?: string` | `Promise<User[]>` | List users with optional search filter |

#### Access Control

All endpoints require `PLATFORM_ADMIN` role via `@Roles(GlobalRole.PLATFORM_ADMIN)`.

---

## Chat Service

### ChatService

**File:** `apps/chat-service/src/chat/chat.service.ts`

Real-time group chat messaging. Validates room membership before allowing operations.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `validateRoomMembership` | `roomId: string`, `accountId: string` | `Promise<void>` | Verify user belongs to chat room |
| `sendMessage` | `roomId: string`, `senderId: string`, `content: string`, `type?: ChatMessageType` | `Promise<Message>` | Send a message to a room |
| `getMessageHistory` | `roomId: string`, `accountId: string`, `cursor?: string`, `limit?: number` | `Promise<{ messages, nextCursor }>` | Get messages with cursor pagination |

#### ChatMessageType Enum

`text` | `image` | `system`

#### Response: Message

```json
{
  "id": "uuid",
  "roomId": "uuid",
  "senderId": "uuid",
  "senderDisplayName": "John Doe",
  "content": "Hello everyone!",
  "type": "text",
  "createdAt": "2026-03-17T10:00:00Z"
}
```

---

## Donation Service

### DonationsService

**File:** `apps/donation-service/src/donations/donations.service.ts`

Payment processing with provider integration. Creates donation intents, processes webhooks, and provides summaries.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `createIntent` | `dto: CreateDonationIntentDto`, `userId: string` | `Promise<DonationIntent>` | Create a payment intent |
| `processWebhook` | `provider: string`, `payload: unknown`, `signature: string` | `Promise<{ id, status, message }>` | Process payment provider webhook |
| `getUserDonations` | `userId: string` | `Promise<Donation[]>` | List user's donation history |
| `getChurchDonationSummary` | `churchId: string`, `userId: string` | `Promise<Summary>` | Get church donation summary (admin) |

#### CreateDonationIntentDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `churchId` | `string` | Yes | Valid UUID |
| `amount` | `number` | Yes | Positive integer (cents) |
| `currency` | `string` | Yes | ISO 4217 code (e.g. `USD`) |
| `type` | `DonationType` | Yes | `tithe`, `offering`, `special` |

#### Donation Status Flow

`pending` → `completed` | `failed`

#### Domain Events Published

- `donation.completed` — payment successfully processed

---

## Notification Service

### DeviceTokensService

**File:** `apps/notification-service/src/device-tokens/device-tokens.service.ts`

Push notification device token registration. Stores tokens per user per platform.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `registerToken` | `accountId: string`, `dto: RegisterDeviceTokenDto` | `Promise<DeviceToken>` | Register or update device token |

#### RegisterDeviceTokenDto

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `token` | `string` | Yes | Non-empty |
| `platform` | `Platform` | Yes | `ios`, `android` |

---

### NotificationsService

**File:** `apps/notification-service/src/notifications/notifications.service.ts`

User-facing notification listing and preference management.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `listNotifications` | `accountId: string`, `dto: ListNotificationsDto` | `Promise<PaginatedResult>` | List notifications with pagination |
| `updatePreferences` | `accountId: string`, `dto: UpdateNotificationPreferencesDto` | `Promise<Preferences>` | Update notification preferences |

---

### DeliveryService

**File:** `apps/notification-service/src/delivery/delivery.service.ts`

Push notification delivery engine. Listens to domain events, creates notifications, and delivers with retry.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `handleEvent` | `event: DomainEvent` | `Promise<void>` | Process a domain event into a notification |
| `attemptDelivery` | `deliveryId: string` | `Promise<void>` | Attempt to deliver a notification |
| `retryFailedDeliveries` | — | `Promise<number>` | Retry all failed deliveries |

#### Retry Strategy

- Max 3 attempts
- Exponential backoff between attempts
- Tracks delivery status: `pending` → `delivered` | `failed`

#### Events Handled

| Event | Notification Created |
|-------|---------------------|
| `church.join_request.approved` | "Your join request was approved" |
| `reminder.triggered` | Reminder notification |
| `group.member_joined` | "New member joined your group" |
| `donation.completed` | "Donation received" |

---

## Worker Service

### ReminderWorkerService

**File:** `apps/worker-service/src/reminders/reminder-worker.service.ts`

Background cron worker that checks for due reminders every minute. Uses Redis distributed locking.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `checkDueReminders` | — | `Promise<void>` | Cron job (every minute) — check and trigger due reminders |
| `processDueReminders` | — | `Promise<number>` | Process all currently due reminders |
| `findDueReminders` | `now: Date` | `Promise<Reminder[]>` | Find reminders due at the given time |
| `isDue` | `reminder: Reminder`, `now: Date` | `boolean` | Check if a specific reminder is due |

#### Recurrence Logic

| Recurrence | Behavior |
|-----------|----------|
| `none` | Fires once at the scheduled time |
| `daily` | Fires every day at the scheduled time |
| `weekly` | Fires on the same day of the week |

#### Distributed Locking

Uses Redis `SET NX EX` for distributed locking. Only one worker instance processes reminders at a time across the cluster.

#### Domain Events Published

- `reminder.triggered` — when a reminder fires

---

### SearchWorkerService

**File:** `apps/worker-service/src/search/search-worker.service.ts`

Search index worker. Listens to domain events and indexes entities for full-text search.

#### Methods

| Method | Parameters | Returns | Description |
|--------|-----------|---------|-------------|
| `handleWithRetry` | `type: 'church' \| 'group' \| 'event'`, `event: DomainEvent`, `attempt?: number` | `Promise<void>` | Index with retry logic |
| `handleEvent` | `type: 'church' \| 'group' \| 'event'`, `event: DomainEvent` | `Promise<void>` | Process a single indexing event |
| `buildDocument` | `type: 'church' \| 'group' \| 'event'`, `entityId: string` | `Promise<SearchDocument \| null>` | Build a search document from entity |

#### Events Handled

| Event | Index Action |
|-------|-------------|
| `church.created` / `church.updated` | Index/update church document |
| `group.created` / `group.approved` | Index/update group document |
| `event.created` / `event.updated` | Index/update event document |

#### Retry Strategy

- Max 3 retries
- Exponential backoff: 1s, 2s, 4s
- Logs failures after max retries exhausted

---

## Architecture Notes

### Event-Driven Communication

Services communicate asynchronously through domain events via `@ekklesia/events`:

```
Mobile API  →  Event Bus  →  Worker Service (indexing)
                           →  Notification Service (delivery)
                           →  Donation Service (webhook processing)
```

### Repository Pattern

All services use TypeORM repositories injected via `@InjectRepository()`. Database entities live in `@ekklesia/db`.

### Service Count by App

| App | Services |
|-----|----------|
| mobile-api | 14 |
| notification-service | 3 |
| worker-service | 2 |
| admin-api | 1 |
| chat-service | 1 |
| donation-service | 1 |
| packages (shared) | 2 |
| **Total** | **24** |
