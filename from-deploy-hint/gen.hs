import System.IO

ghcLibs :: [String]
ghcLibs = [ "array"
          , "base"
          , "binary"
          , "bytestring"
          , "containers"
          , "deepseq"
          , "directory"
          , "filepath"
          , "ghc-prim"
          , "ghc-boot"
          , "ghc-boot-th"
          , "ghc-compact"
          , "ghc-heap"
          , "haskeline"
          , "hpc"
          , "integer-gmp"
          , "libiserv"
          , "mtl"
          , "parsec"
          , "pretty"
          , "process"
          , "stm"
          , "template-haskell"
          , "terminfo"
          , "text"
          , "time"
          , "transformers"
          , "unix"
          , "xhtml"
          ]

libs :: [String]
libs = [ "tidal"
       , "bifunctors"
       , "clock"
       , "colour"
       , "hosc"
       , "network"
       , "primitive"
       , "random"
       , "base-orphans"
       , "comonad"
       , "tagged"
       , "th-abstraction"
       , "distributive"
       , "indexed-traversable"
       , "transformers-compat"
       , "splitmix"
       , "blaze-builder"
       , "data-binary-ieee754"
       ]

mkdir :: String
mkdir = "mkdir -p                                                               tidal-listener/haskell-libs/package.conf.d && \\ \n"

ver :: String
ver = "8.6.5"

genGHC :: String -> [String] -> String
genGHC version [] = ""
genGHC version (x:xs) = "cp -r /opt/ghc/" ++ version ++ "/lib/ghc-" ++ version ++ "/" ++ x ++ "-*                              tidal-listener/haskell-libs/ && \\ \n"  ++ (genGHC version xs)

genGHC_conf :: String -> [String] -> String
genGHC_conf version [] = ""
genGHC_conf version (x:xs) = "cp -r /opt/ghc/" ++ version ++ "/lib/ghc-" ++ version ++ "/package.conf.d/" ++ x ++ "-*.conf   tidal-listener/haskell-libs/package.conf.d/ && \\ \n" ++ (genGHC_conf version xs)

sedGHC_conf :: String -> [String] -> String
sedGHC_conf version [] = ""
sedGHC_conf version (x:xs) = "sed -i 's/\\/opt\\/ghc\\/" ++ version ++ "\\/lib\\/ghc-" ++ version ++ "/\\/root\\/tidal-listener\\/haskell-libs/g'  tidal-listener/haskell-libs/package.conf.d/" ++ x ++ "-*.conf && \\ \n" ++ (sedGHC_conf version xs)

gen :: String -> [String] -> String
gen version [] = ""
gen version (x:xs) = "cp -r .cabal-sandbox/lib/x86_64-linux-ghc-" ++ version ++ "/" ++ x ++ "-*                              tidal-listener/haskell-libs/ && \\ \n"  ++ (gen version xs)

gen_conf :: String -> [String] -> String
gen_conf version [] = ""
gen_conf version (x:xs) = "cp -r .cabal-sandbox/*-packages.conf.d/" ++ x ++ "-*.conf   tidal-listener/haskell-libs/package.conf.d && \\ \n" ++ (gen_conf version xs)

sed_conf :: String -> [String] -> String
sed_conf version [] = ""
sed_conf version (x:xs) = "sed -i 's/\\/root\\/.cabal-sandbox\\/lib\\/x86_64-linux-ghc-" ++ version ++ "/\\/root\\/tidal-listener\\/haskell-libs/g'  tidal-listener/haskell-libs/package.conf.d/" ++ x ++ "-*.conf && \\ \n" ++ (sed_conf version xs)

main :: IO ()
main = do
    let s1 = genGHC ver ghcLibs
    let s1' = gen ver libs
    let s2 = genGHC_conf ver ghcLibs
    let s2' = gen_conf ver libs
    let s3 = sedGHC_conf ver ghcLibs
    let s3' = sed_conf ver libs
    writeFile "deps.txt" (s1 ++ "\n \n" ++ s1' ++ "\n" ++ mkdir ++ "\n" ++ s2 ++ "\n \n" ++ s2' ++ "\n \n" ++ s3 ++ "\n \n" ++ s3')
