module Db.Jobs (getAllJobs) where

import Database.PostgreSQL.Simple (Connection, query_, Query)
import Domain.Job (Job)

allJobsQuery :: Query
allJobsQuery = read "select id, handler, payload, status from jobs"

getAllJobs :: Connection -> IO [Job]
getAllJobs c = query_ c allJobsQuery
