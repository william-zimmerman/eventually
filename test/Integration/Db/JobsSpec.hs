module Integration.Db.JobsSpec () where
import Test.Tasty (TestTree, testGroup)
import Test.Tasty.HUnit (testCase)
import Data.UUID.V4 (nextRandom)
import Domain.Job (Job(Job), Status (Pending))
import Database.PostgreSQL.Simple.FromRow (FromRow(fromRow))

allTests :: TestTree
allTests = testGroup "All tests" []

jobTests :: TestTree
jobTests = testGroup "Job tests" []

fromRowTests :: TestTree
fromRowTests = testGroup "fromRow tests" [
    testCase "fromRow constructs job" $ do
      id <-  nextRandom
      let handler = "aHandler"
      let payload = "aPayload"
      let status = Pending
      let expected = Job id handler payload status
      return ()
  ]
