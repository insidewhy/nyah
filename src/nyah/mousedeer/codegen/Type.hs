module Type ( Type(..) ) where

import Data.Hashable

data Type = Class [Char] [Type] | Primitive [Char] Int
    deriving (Eq, Ord)

instance Show Type where
  show (Class a b) = "class " ++ show a
  show (Primitive a b) = "primitive " ++ show a ++ ": " ++ show b

instance Hashable Type where
    hash (Class a b) = hash a `combine` hash b
    hash (Primitive a _) = hash a
