import Control.Monad
import Control.Monad.Trans.Reader
import Text.Printf
import Language.Haskell.Interpreter
import Language.Haskell.Interpreter.Unsafe
import Sound.Tidal.Pattern
import Sound.Tidal.Show
import System.Environment


interpretDiag :: () -> Interpreter ((),())
interpretDiag u = do
    f <- interpret "\\x -> (x,x)" (as :: () -> ((),()))
    return (f u)

interpretId :: () -> Interpreter ()
interpretId u = do
    setImports ["Prelude", "System.Clock"]
    f <- interpret "id" (as :: () -> ())
    return (f u)

interpretAsk :: () -> Interpreter ()
interpretAsk u = do
    setImports
      [ "Prelude"
      , "Data.Functor.Identity"
      , "Control.Monad.Trans.Reader"
      ]
    body <- interpret "ask" (as :: Reader () ())
    return (runReader body u)

interpretPat :: Interpreter String
interpretPat = do
     setImports ["Prelude", "Sound.Tidal.Pattern"]
     pat <- interpret "pure \"bd \"" (as :: Pattern String)
     return (show pat)

main :: IO ()
main = do
    putStrLn "Enter libdir: \n"
    lib <- readLn

    r <- unsafeRunInterpreterWithArgsLibdir [] lib (interpretDiag ())
    printf "(\\x -> (x,x)) %s is:\n" (show "()")
    print r

    putStrLn "and now, let's try the Prelude..."
    r <- unsafeRunInterpreterWithArgsLibdir [] lib (interpretId ())
    printf "id %s is:\n" (show "()")
    print r

    putStrLn "a library from hackage:"
    r <- unsafeRunInterpreterWithArgsLibdir [] lib (interpretAsk ())
    printf "runReader ask %s is:\n" (show "()")
    case r of
      Left err -> print err
      Right r -> do
        print r

    putStrLn "a tidal pattern:"
    r <- unsafeRunInterpreterWithArgsLibdir [] lib  interpretPat
    case r of
      Left err -> print err
      Right r -> do
        print r
