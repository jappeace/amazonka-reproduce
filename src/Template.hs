module Template
  ( main
  )
where

import Control.Monad.Trans.Resource(runResourceT) --
import Amazonka.Send(paginate, send)
import Data.Conduit(runConduit, (.|))
import Conduit(headC)
import Amazonka.TimeStreamQuery
import Control.Monad(void, forever)
import Amazonka.Env(newEnv)
import Amazonka.Auth(discover)
import Data.Time
import Amazonka.Env(Env'(..), Env)
import Amazonka(Service(..))
import qualified Amazonka.Core as Core
import Amazonka.S3.ListBuckets

main :: IO ()
main = do
  env <- newEnv discover
  forever $ do
    currentTime <- getCurrentTime
    putStrLn ("loop " <> show currentTime)
    void $ runResourceT $
      send env newListBuckets
