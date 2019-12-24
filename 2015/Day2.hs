{-# OPTIONS_GHC -fno-warn-tabs #-}
{-# LANGUAGE TupleSections, OverloadedStrings #-}

module Test where

import Network.HTTP.Simple
import Data.ByteString.Lazy.UTF8 (toString)
import Text.Regex.Posix

ml :: [a] -> [(a, a)]
ml [] = []
ml (h:t) = fmap (h,) t ++ ml t

sides [l, w, h] = [l * w, w * h, h * l]
required sides = sum (fmap (2 *) sides) + foldr1 min sides
get :: IO String
get = fmap toString $ fmap getResponseBody $ (httpLBS . addRequestHeader "Cookie" "session=") =<< parseRequest "GET http://adventofcode.com/2015/day/2/input"
parse :: String -> [[Integer]]
parse v = fmap (fmap read . tail) $ (v =~ ("^([0-9]+)x([0-9]+)x([0-9]+)$" :: String) :: [[String]]) :: [[Integer]]
