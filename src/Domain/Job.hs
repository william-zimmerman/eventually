module Domain.Job (Job (..), Status (..), parseStatus) where

import Data.UUID
import Database.PostgreSQL.Simple.FromRow (FromRow, field, fromRow)
import Database.PostgreSQL.Simple.FromField (FromField, fromField, returnError, ResultError (..))
import Data.ByteString.Char8 (unpack)

data Job = Job
    { id :: UUID
    , handler :: String
    , payload :: String
    , status :: Status
    }
  deriving (Eq, Show)

instance FromRow Job where
  fromRow = Job <$> field <*> field <*> field <*> field

data Status = Pending | Running | Completed | Failed
  deriving (Eq, Show)

parseStatus :: String -> Maybe Status
parseStatus "pending" = Just Pending
parseStatus "running" = Just Running
parseStatus "completed" = Just Completed
parseStatus "failed" = Just Failed
parseStatus _ = Nothing

instance FromField Status where
  fromField field maybeValue =
    case maybeValue of
      Nothing -> returnError UnexpectedNull field "Expected non-null value"
      Just bytestring ->
        case parseStatus $ unpack bytestring of
          Just s -> pure s
          Nothing -> returnError ConversionFailed field "Invalid status"
