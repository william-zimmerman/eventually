module Unit.Domain.JobSpec(jobTests) where

import Test.Tasty (TestTree, testGroup)
import Test.Tasty.HUnit (testCase, assertEqual)
import Domain.Job ( Status(..), parseStatus )

jobTests :: TestTree
jobTests = testGroup "parseStatus tests" [
    testCase "parseStatus can parse pending status" $ assertEqual "" (parseStatus "pending") (Just Pending)
  ]
