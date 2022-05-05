{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad (forM_)
import Data.Bifunctor (bimap)
import Data.Int (Int32)
import Data.Map (Map)
import Data.Maybe (fromJust)
import Text.Printf (printf)

import DBus
import DBus.Client


printDictionary :: Dictionary -> IO ()
printDictionary d =
  let items = unwrap <$> dictionaryItems d :: [(String, Int32)]
  in forM_ items $ uncurry (printf "  %s: %d\n")
 where
  unwrap (k, v) =
    let
      Just key = fromVariant k
      Just val = fromVariant v
    in (key, val)


main :: IO ()
main = do
  -- connect to the bus
  client <- connectSession

  -- send request for "hello" method
  reply  <- call_
    client
    (methodCall "/com/example/SampleMethods" "com.example.SampleMethods" "hello"
      )
      { methodCallDestination = Just "com.example"
      }

  putStrLn "com.example.SampleMethods hello()"
  let Just msg = fromVariant (head $ methodReturnBody reply)
  putStrLn msg

  -- send request for "reverse" method
  reply <- call_
    client
    (methodCall
        "/com/example/SampleMethods"
        "com.example.SampleMethods"
        "reverse"
      )
      { methodCallDestination = Just "com.example"
      , methodCallBody        = [toVariant ("dbus example" :: String)]
      }

  putStrLn "com.example.SampleMethods reverse(\"dbus example\")"
  let Just msg = fromVariant (head $ methodReturnBody reply)
  putStrLn msg

  -- send request for "listDir" method
  reply <- call_
    client
    (methodCall
        "/com/example/SampleMethods"
        "com.example.SampleMethods"
        "listDir"
      )
      { methodCallDestination = Just "com.example"
      , methodCallBody        = [toVariant ("." :: String)]
      }

  putStrLn "com.example.SampleMethods listDir(\".\")"
  let Just d = fromVariant (head $ methodReturnBody reply)
  printDictionary d


