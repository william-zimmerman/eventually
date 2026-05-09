module Db.Jobs (getAllJobs) where

import Database.PostgreSQL.Simple (Connection)
import Domain.Job (Job)

getAllJobs :: Connection -> IO [Job]
getAllJobs _ =
    return []
