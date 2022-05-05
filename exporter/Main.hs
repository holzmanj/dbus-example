{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Concurrent (threadDelay)
import Control.Monad (forever, when)
import Data.Int (Int32)
import Data.Map (Map)
import qualified Data.Map as M
import System.Directory (getFileSize, listDirectory)
import System.Exit (exitFailure)

import DBus.Client

-- | Always return a hello message
onHello :: IO String
onHello = return "Hello"

-- | Reverse the given string and send it back
onReverse :: String -> IO String
onReverse s = return $ reverse s

-- | Get a list of all of the files at a given path and their sizes in bytes
onListDir :: String -> IO (Map String Int32)
onListDir dir = do
  fnames <- listDirectory dir
  sizes  <- sequence (getFileSize <$> fnames)
  return $ M.fromList (zip fnames (fromIntegral <$> sizes))

main :: IO ()
main = do
  -- connect to the bus
  client    <- connectSession

  -- request unique name on bus
  reqResult <- requestName client "com.example" []
  when (reqResult /= NamePrimaryOwner) $ do
    putStrLn
      "dbus-exporter is already running or someone else owns \"com.example\""
    exitFailure

  -- export an object with three methods
  export
    client
    "/com/example/SampleMethods"
    defaultInterface
      { interfaceName    = "com.example.SampleMethods"
      , interfaceMethods =
        [ autoMethod "hello"   onHello
        , autoMethod "reverse" onReverse
        , autoMethod "listDir" onListDir
        ]
      }

  -- wait for incoming requests
  forever $ threadDelay 100000000



