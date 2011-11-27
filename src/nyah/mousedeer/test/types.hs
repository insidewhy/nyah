import Type
import Data.HashMap

main :: IO ()
main = do
    let clss = Class "Yah"
        prim = Primitive "Int" 4
        k = insert prim 5 (insert clss 4 empty)
    putStrLn(show clss)
    putStrLn(show prim)
    putStrLn(show k)
    return ()
