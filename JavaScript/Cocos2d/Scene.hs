module JavaScript.Cocos2d.Scene where

import Control.Monad.IO.Class
import GHCJS.Types
import GHCJS.Marshal
import GHCJS.Marshal.Pure
import GHCJS.Foreign.Callback
import JavaScript.Cocos2d.Node
import JavaScript.Cocos2d.Utils

class IsNode a => IsScene a where
    toScene :: a -> Scene

newtype Scene = Scene JSVal
instance IsNode Scene where
    toNode (Scene v) = pFromJSVal v
instance IsScene Scene where
    toScene = id

createScene :: MonadIO m => m Scene
createScene = liftIO cc_createScene

newtype LoaderScene = LoaderScene JSVal
instance IsNode LoaderScene where
    toNode (LoaderScene v) = pFromJSVal v
instance IsScene LoaderScene where
    toScene (LoaderScene v) = Scene v

createLoaderScene :: MonadIO m => m LoaderScene
createLoaderScene = liftIO cc_createLoaderScene

preload :: [String] -> IO () -> IO (LoaderScene, IO ())
preload resources cb = liftIO . flip convCallbackWithReturn cb . cc_preload =<< toJSVal resources

foreign import javascript unsafe "new cc.Scene()" cc_createScene :: IO Scene
foreign import javascript unsafe "new cc.LoaderScene()" cc_createLoaderScene :: IO LoaderScene
foreign import javascript unsafe "cc.LoaderScene.preload($1, $2, cc.game)" cc_preload :: JSVal -> Callback a -> IO LoaderScene
