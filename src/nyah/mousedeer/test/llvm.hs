import LLVM.Core
import LLVM.ExecutionEngine
import Data.Word
import Data.MemoTrie

-- bldGreet :: CodeGenModule (Function (IO ()))
-- bldGreet = do
--     puts <- newNamedFunction ExternalLinkage "puts" :: TFunction (Ptr Word8 -> IO Word32)
--     greetz <- createStringNul "Hello, World!"
--     func <- createFunction ExternalLinkage $ do
--       tmp <- getElementPtr greetz (0::Word32, (0::Word32, ()))
--       call puts tmp -- Throw away return value.
--       ret ()
--     return func

mFib :: CodeGenModule (Function (Word32 -> IO Word32))
mFib = do
    fib <- newNamedFunction ExternalLinkage "fib"
    defineFunction fib $ \ arg -> do
        -- Create the two basic blocks.
        recurse <- newBasicBlock
        exit <- newBasicBlock

        -- Test if arg > 2
        test <- cmp CmpGT arg (2::Word32)
        condBr test recurse exit

        -- Just return 1 if not > 2
        defineBasicBlock exit
        ret (1::Word32)

        -- Recurse if > 2, using the cumbersome plus to add the results.
        defineBasicBlock recurse
        x1 <- sub arg (1::Word32)
        fibx1 <- call fib x1
        x2 <- sub arg (2::Word32)
        fibx2 <- call fib x2
        r <- add fibx1 fibx2
        ret r
    return fib

main :: IO ()
main = do
   initializeNativeTarget
   mainFun <- simpleFunction mFib
   res <- mainFun 39
   putStrLn("hello " ++ show res)
   return ()
