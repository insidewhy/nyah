module Type ( Type(..) ) where

import Data.Hashable

data Type = Class [Char] | Primitive [Char] Int

instance Show Type where
  show (Class a) = "class " ++ show a
  show (Primitive a b) = "primitive " ++ show a ++ ": " ++ show b

instance Hashable Type where
    hash (Class a) = hash a
    hash (Primitive a b) = hash a

instance Eq Type where
    (Class a) == (Class b) = a == b
    (Primitive a _) == (Primitive b _) = a == b
    _ == _ = False

instance Ord Type where
    (Class a) < (Class b) = a < b
    (Primitive a _) < (Primitive b _) = a < b
    _ < _ = False
