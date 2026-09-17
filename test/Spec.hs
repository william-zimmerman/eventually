import Test.Tasty (defaultMain, TestTree, testGroup)
import Test.Tasty.HUnit (testCase, assertEqual)
import Database.PostgreSQL.Simple (connectPostgreSQL)
import Data.ByteString.Char8 (pack)
import Db.Jobs (getAllJobs)
import Unit.Domain.JobSpec (jobTests)

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "Tests" [unitTests, integrationTests]

unitTests :: TestTree
unitTests = testGroup "Unit tests" [jobTests]

integrationTests :: TestTree
integrationTests = testGroup "Integration tests" [
  testCase "DB Integration test" $ do
    connection <- connectPostgreSQL $ pack "host=localhost dbname=postgres port=5433 user=postgres password=postgres"
    actual <- getAllJobs connection
    assertEqual "getAllJobs retrieves all jobs" actual []
  ]
