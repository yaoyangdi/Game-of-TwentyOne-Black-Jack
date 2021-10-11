{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_twentyone (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\dingy\\OneDrive\\Desktop\\333333333\\Game-of-TwentyOne\\.stack-work\\install\\48b0106b\\bin"
libdir     = "C:\\Users\\dingy\\OneDrive\\Desktop\\333333333\\Game-of-TwentyOne\\.stack-work\\install\\48b0106b\\lib\\x86_64-windows-ghc-8.10.3\\twentyone-0.1.0.0-AFHQ6TVmhKk3RU0HPDbGkE-staticgame"
dynlibdir  = "C:\\Users\\dingy\\OneDrive\\Desktop\\333333333\\Game-of-TwentyOne\\.stack-work\\install\\48b0106b\\lib\\x86_64-windows-ghc-8.10.3"
datadir    = "C:\\Users\\dingy\\OneDrive\\Desktop\\333333333\\Game-of-TwentyOne\\.stack-work\\install\\48b0106b\\share\\x86_64-windows-ghc-8.10.3\\twentyone-0.1.0.0"
libexecdir = "C:\\Users\\dingy\\OneDrive\\Desktop\\333333333\\Game-of-TwentyOne\\.stack-work\\install\\48b0106b\\libexec\\x86_64-windows-ghc-8.10.3\\twentyone-0.1.0.0"
sysconfdir = "C:\\Users\\dingy\\OneDrive\\Desktop\\333333333\\Game-of-TwentyOne\\.stack-work\\install\\48b0106b\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "twentyone_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "twentyone_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "twentyone_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "twentyone_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "twentyone_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "twentyone_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
