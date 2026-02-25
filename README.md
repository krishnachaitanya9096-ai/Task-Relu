**relu_task**

Flutter Music Library Application using BLoC architecture with pagination and search support.

**Architecture Overview**

This project follows a clean layered architecture:

Presentation Layer → UI Screens

Business Logic Layer → BLoC (flutter_bloc)

Data Layer → ApiService (Dio integration)

Model Layer → JSON parsing models

State management is handled using flutter_bloc, ensuring separation of concerns and predictable state updates.

Why This Approach Works
**1️⃣ Lazy List Building**

The app uses:

ListView.builder()

Instead of building all widgets at once.

Why this works:

Only visible items are built in memory

Offscreen widgets are recycled

Prevents memory overflow

Smooth scrolling performance

This ensures scalability for large datasets.

**2️⃣ Paging Strategy (Index + Limit)**

Pagination is handled using:

index → starting position

limit → number of items per request

LoadMoreTracks event on scroll end

Flow:

Initial load → fetch first 50 items

When scroll reaches bottom → trigger LoadMoreTracks

Append new items to existing state list

Stop when API returns empty list

Why this works:

Prevents loading thousands of records at once

Reduces memory usage

Minimizes API load

Improves perceived performance

**3️⃣ Search Strategy**

Search is implemented using:

SearchTracks event

Reset index to 0

Trigger fresh API call

Replace previous state

Why this works:

Keeps search independent from pagination

Prevents mixing old and new results

Clean state reset ensures consistency

Performance Optimization

The application ensures:

Stateless widgets where possible

Controlled state updates via BLoC

No unnecessary rebuilds

Efficient scroll listener

Internet connectivity check before API call

What Would Break at 100k Items?

Even with pagination, scaling to 100,000+ items would introduce challenges:

**1️⃣ Large In-Memory List**

Currently, fetched items are stored in:

List<Data> tracks

If user scrolls deeply, memory usage increases.

Optimization:

Use caching strategy with limited memory window

Implement local database (Hive / Isar / SQLite)

Remove offscreen older pages

Use infinite scroll with cursor-based pagination

**2️⃣ API Performance Bottleneck**

Offset-based pagination (index) becomes slower for very large datasets.

Optimization:

Switch to cursor-based pagination

Use backend proxy for better filtering

Introduce server-side search optimization

**3️⃣ Search Debouncing**

Currently search triggers on submit.

At scale, real-time search would require:

Debounce mechanism (300–500ms)

Cancel previous requests

Request queue management

**4️⃣ Network Failure Handling**

At very large scale:

Retry mechanism

Exponential backoff

Offline caching

Next-Level Improvements

If this were production-ready at 100k+ scale, I would:

Implement repository pattern

Add result caching

Use Equatable optimally to reduce rebuilds

Add skeleton loading placeholders

Introduce unit + bloc tests

Move API calls behind backend proxy

Tech Stack

Flutter

flutter_bloc

Dio

Connectivity_plus

Clean architecture principles

**Conclusion**

This implementation ensures:

Efficient lazy UI rendering

Controlled memory usage

Clean separation of concerns

Scalable pagination design

Maintainable state management

The architecture is optimized for medium-scale datasets and can be extended further for high-scale production systems.