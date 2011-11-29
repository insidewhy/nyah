import Type
import Data.HashMap

main :: IO ()
main = do
    let simpClss = Class "Yah" []
        prim     = Primitive "Int" 4
        clss     = Class "Yah" [Class "Ho" []]
        k = insert clss 3 $ insert prim 5 $ insert simpClss 4 empty
    putStrLn(show simpClss)
    putStrLn(show prim)
    putStrLn(show k)
    return ()
