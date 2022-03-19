// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.IMFriendPhotoCell

package im
{
    import flash.display.Sprite;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;
    import flash.display.Bitmap;
    import flash.display.Shape;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.system.LoaderContext;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PathManager;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.DesktopManager;
    import flash.external.ExternalInterface;
    import flash.net.navigateToURL;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.manager.LanguageMgr;
    import ddt.data.analyze.LoadPlayerWebsiteInfoAnalyze;

    public class IMFriendPhotoCell extends Sprite 
    {

        private var _load:Loader;
        private var _url:URLRequest;
        private var _websiteInfo:Dictionary;
        private var _photoFrame:Bitmap;
        private var _mask:Shape;
        private var _name:FilterFrameText;
        private var _loaderContext:LoaderContext;

        public function IMFriendPhotoCell()
        {
            buttonMode = false;
            this._load = new Loader();
            this._load.contentLoaderInfo.addEventListener(Event.COMPLETE, this.__loadCompleteHandler);
            this._load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.__loadIoErrorHandler);
            this._loaderContext = new LoaderContext(true);
            this._photoFrame = ComponentFactory.Instance.creatBitmap("asset.playerTip.PhotoFrame");
            this._name = ComponentFactory.Instance.creatComponentByStylename("playerTip.PhotoNameTxt");
            addChild(this._name);
            this._mask = new Shape();
            this._mask.graphics.beginFill(0, 0);
            this._mask.graphics.drawRect(0, 0, 54, 55);
            this._mask.graphics.endFill();
            if (((PathManager.CommnuntyMicroBlog()) && (PathManager.CommnuntySinaSecondMicroBlog())))
            {
                buttonMode = true;
                this.addEvents();
            };
        }

        private function addEvents():void
        {
            addEventListener(MouseEvent.CLICK, this.__photoClick);
        }

        private function __photoClick(_arg_1:MouseEvent):void
        {
            var _local_2:String;
            if (this._websiteInfo["personWeb"] != null)
            {
                SoundManager.instance.play("008");
                if (((ExternalInterface.available) && (!(DesktopManager.Instance.isDesktop))))
                {
                    _local_2 = (('function redict () {window.open("' + this._websiteInfo["personWeb"]) + '", "_blank")}');
                    ExternalInterface.call(_local_2);
                }
                else
                {
                    navigateToURL(new URLRequest(encodeURI(this._websiteInfo["personWeb"])), "_blank");
                };
            };
        }

        public function set userID(_arg_1:String):void
        {
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveWebPlayerInfoPath(_arg_1), BaseLoader.REQUEST_LOADER);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBuddyListFailure");
            _local_2.analyzer = new LoadPlayerWebsiteInfoAnalyze(this.__returnWebSiteInfoHandler);
            LoadResourceManager.instance.startLoad(_local_2);
            if (this._name)
            {
                this._name.text = "";
            };
        }

        private function __returnWebSiteInfoHandler(_arg_1:LoadPlayerWebsiteInfoAnalyze):void
        {
            this._websiteInfo = _arg_1.info;
            if (((!(this._websiteInfo["tinyHeadUrl"] == null)) && (!(this._websiteInfo["tinyHeadUrl"] == ""))))
            {
                this.loadImage(this._websiteInfo["tinyHeadUrl"]);
            };
            if (((!(this._websiteInfo["userName"] == null)) && (this._websiteInfo["userName"])))
            {
                if (this._name)
                {
                    this._name.text = this._websiteInfo["userName"];
                };
            };
        }

        private function loadImage(_arg_1:String):void
        {
            this._url = new URLRequest(_arg_1);
            this._load.load(this._url, this._loaderContext);
        }

        private function __loadCompleteHandler(_arg_1:Event):void
        {
            addChild(this._load.content);
            this._load.content.x = 4;
            this._load.content.y = 5;
            this._load.content.mask = this._mask;
            addChild(this._photoFrame);
            addChild(this._mask);
        }

        public function clearSprite():void
        {
            while (this.numChildren)
            {
                this.removeChildAt(0);
            };
            this.graphics.clear();
        }

        private function __loadIoErrorHandler(_arg_1:IOErrorEvent):void
        {
        }

        public function dispose():void
        {
            removeEventListener(MouseEvent.CLICK, this.__photoClick);
            if (((this._load) && (this._load.contentLoaderInfo)))
            {
                this._load.contentLoaderInfo.addEventListener(Event.COMPLETE, this.__loadCompleteHandler);
                this._load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.__loadIoErrorHandler);
            };
            if (((this._mask) && (this._mask.parent)))
            {
                this._mask.graphics.clear();
                this._mask.parent.removeChild(this._mask);
            };
            this._mask = null;
            this.clearSprite();
            if (this._name)
            {
                this._name.dispose();
                this._name = null;
            };
            if (((this._photoFrame) && (this._photoFrame.parent)))
            {
                this._photoFrame.parent.removeChild(this._photoFrame);
            };
            this._photoFrame = null;
            this._url = null;
            this._load = null;
            this._loaderContext = null;
            this._websiteInfo = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package im

