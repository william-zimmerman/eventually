# Haskell DB-Backed Async Job Processing Library Roadmap

A progressive roadmap for building a database-backed async job processing system in Haskell. The goal is to start minimal and evolve toward a production-grade, observable, extensible system.

---

## 🧱 Phase 0 — Core Model

Define the foundational pieces before building.

### Job Representation

* `id :: UUID`
* `payload :: JSON` (or typed later)
* `status :: JobStatus`
* `createdAt :: UTCTime`
* `updatedAt :: UTCTime`

### Job Statuses

* `pending`
* `running`
* `completed`
* `failed`

### Execution Model

* Start with polling workers

### Database

* PostgreSQL recommended (for `SKIP LOCKED` support)

### Libraries to Consider

* `aeson` (JSON handling)
* `uuid` (job IDs)
* `time` (timestamps)

---

## 🚀 Phase 1 — Minimal Worker ("Hello, Job")

**Goal:** Process a single job from the database.

### Features

* Insert job into DB
* Worker loop:

  * Fetch one pending job
  * Mark as running
  * Execute handler
  * Mark as completed

### Notes

* Use a simple loop with `threadDelay`
* Keep everything as simple as possible

### Libraries to Consider

* `postgresql-simple` (great low-level starting point)
* `resource-pool` (optional, for DB connections)
* `text`

---

## 🔒 Phase 2 — Safe Concurrency

**Goal:** Multiple workers without duplicate processing.

### Features

* Atomic job claiming:

  ```sql
  SELECT * FROM jobs
  WHERE status = 'pending'
  FOR UPDATE SKIP LOCKED
  LIMIT 1;
  ```

* Multiple worker threads

### Concepts

* Race conditions
* DB-level locking vs in-memory locking

### Libraries to Consider

* `async` (lightweight concurrency)
* `stm` (optional, if you experiment with coordination)
* `unliftio` (nicer concurrency + exceptions)

---

## 🔁 Phase 3 — Retries & Failure Handling

**Goal:** Resilience to failures.

### Features

* Retry count
* Max retries
* Error message storage
* Retry backoff (e.g. exponential)

### New States

* `retrying`
* `dead`

### Libraries to Consider

* `exceptions` or `safe-exceptions`
* `retry` (for backoff strategies)
* `mtl` or `transformers`

---

## ⏱️ Phase 4 — Scheduling

**Goal:** Support delayed execution.

### Features

* Add `runAt :: UTCTime`
* Only process jobs where `runAt <= now`

### Stretch

* Recurring / cron-style jobs

### Libraries to Consider

* `time`
* `cron` or `cron-schedule` (optional)

---

## 📦 Phase 5 — Typed Jobs

**Goal:** Improve ergonomics and type safety.

### Options

* Typeclass-based handlers:

  ```haskell
  class JobHandler a where
    runJob :: a -> IO ()
  ```

* JSON serialization via `aeson`

### Concepts

* Existential types
* GADTs (optional)

### Libraries to Consider

* `aeson`
* `serialise` (if exploring binary formats)
* `dependent-sum` (advanced, optional)

---

## ⚡ Phase 6 — Performance

**Goal:** Increase throughput.

### Features

* Batch job fetching
* Worker pools
* Configurable concurrency

### Tools

* `async`
* `mapConcurrently`

### Libraries to Consider

* `async`
* `vector` (for batching)
* `containers`

---

## 📊 Phase 7 — Observability

**Goal:** Visibility into system behavior.

### Features

* Structured logging
* Metrics:

  * Jobs processed/sec
  * Failures
  * Queue depth

### Libraries to Consider

* `katip` or `co-log` (logging)
* `ekg` (runtime metrics)
* `prometheus-client` (export metrics)

---

## 🖥️ Phase 8 — Terminal Dashboard

**Goal:** Real-time monitoring UI.

### Features

* Job counts by status
* Active workers
* Recent failures

### Libraries to Consider

* Brick (terminal UI)
* `vty` (underlying terminal library)

---

## 🔌 Phase 9 — Pluggable Backends

**Goal:** Abstract storage layer.

### Typeclass

```haskell
class Monad m => JobStore m where
  fetchJob  :: m (Maybe Job)
  updateJob :: Job -> m ()
```

### Backends

* PostgreSQL (primary)
* SQLite (development)
* In-memory (testing)

### Libraries to Consider

* `persistent` (higher-level DB option)
* `opaleye` (typed SQL)
* `beam` (another typed DB option)

---

## 🧪 Phase 10 — Testing

**Goal:** Confidence and reliability.

### Features

* Property testing
* Integration tests with real DB
* Fault injection (e.g. worker crashes)

### Libraries to Consider

* `QuickCheck`
* `hspec` or `tasty`
* `tmp-postgres` (ephemeral DB for tests)

---

## 🧠 Phase 11 — Advanced Features

Optional enhancements depending on interest.

### Ideas

* Distributed workers across nodes
* Leader election
* Job priorities
* Rate limiting per job type
* Idempotency guarantees

### Libraries to Consider

* `distributed-process` (if exploring distributed Haskell)
* `hashable`
* `unordered-containers`

---

## 🧩 Phase 12 — Library Polish

**Goal:** Make it reusable.

### Features

* Clean public API
* Documentation
* Examples
* Versioning

### Libraries / Tools

* `cabal` or `stack`
* `hlint`
* `ormolu` or `fourmolu`

---

## 🧭 Suggested Build Order

1. Single worker + DB table
2. Safe concurrency (`SKIP LOCKED`)
3. Retries
4. Scheduling
5. Worker pool
6. Metrics/logging
7. Dashboard
8. Backend abstraction

---

## 💡 Design Guidelines

* Push concurrency correctness into the database early
* Keep job execution logic as pure as possible
* Avoid premature abstraction
* Measure performance before optimizing

---

## ⚠️ Common Pitfalls

* Long-lived DB transactions
* Not handling worker crashes mid-job
* Overengineering job typing too early
* Lack of observability

---

## 🎯 End Goal

A robust, production-ready job processing library with:

* Strong correctness guarantees
* Good performance characteristics
* Excellent observability
* Developer-friendly API

---

## Orthogonal Stretch Goals

* Running DB migrations programmatically
