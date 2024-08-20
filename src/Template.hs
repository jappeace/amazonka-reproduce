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
main = withGhcDebug program

-- putting these in top level functions will generate cost centeres for them.
--  which supposedly allows me to find their respective heap addresses
--  albeit I can't

program :: IO ()
program = do
  env <- newEnv discover
  forever $ innerLoop env

innerLoop :: Env -> IO ()
innerLoop env = do
    currentTime <- getCurrentTime
    putStrLn ("loop " <> show currentTime)
    callTimeStream env
    threadDelay 5000000

callTimeStream :: Env -> IO ()
callTimeStream env = do
    void $ runResourceT $
      send (envMod env) (newQuery "SELECT 1")
