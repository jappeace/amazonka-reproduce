module Template
  ( main
  )
where

import Control.Concurrent
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
import GHC.Debug.Stub

-- for euwest, we need to fix the endpoint otherwise it can't find it.
setEndpoint :: Service -> Service
setEndpoint y = let z = y{
  endpointPrefix = "query-cell1.timestream",
  endpoint = Core.defaultEndpoint z
  }
  in z

envMod :: Env -> Env
envMod x = x{overrides = setEndpoint}

main :: IO ()
main = withGhcDebug $ do
  env <- newEnv discover
  forever $ do
    currentTime <- getCurrentTime
    putStrLn ("loop " <> show currentTime)
    void $ runResourceT $
      send (envMod env) (newQuery "SELECT 1")
    threadDelay 5000000
