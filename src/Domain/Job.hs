module Domain.Job (Job (..)) where

import Data.UUID

data Job = Job
    { jobId :: UUID
    , handler :: String
    , payload :: String
    , status :: Status
    }

data Status = Pending | Running | Completed | Failed
