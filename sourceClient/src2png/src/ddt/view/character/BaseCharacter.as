// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.BaseCharacter

package ddt.view.character
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.data.player.PlayerInfo;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.PixelSnapping;
    import ddt.events.PlayerPropertyEvent;
    import flash.events.Event;
    import game.GameManager;
    import game.view.experience.ExpView;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import com.pickgliss.utils.ObjectUtils;
    import flash.display.DisplayObject;

    public class BaseCharacter extends Sprite implements ICharacter, Disposeable 
    {

        public static const BASE_WIDTH:int = 120;
        public static const BASE_HEIGHT:int = 165;

        protected var _info:PlayerInfo;
        protected var _frames:Array;
        protected var _loader:ICharacterLoader;
        protected var _characterWidth:Number;
        protected var _characterHeight:Number;
        protected var _factory:ICharacterLoaderFactory;
        protected var _dir:int;
        protected var _container:Sprite;
        protected var _body:Bitmap;
        protected var _currentframe:int;
        protected var _loadCompleted:Boolean;
        protected var _picLines:int;
        protected var _picsPerLine:int;
        private var _autoClearLoader:Boolean;
        protected var _characterBitmapdata:BitmapData;
        protected var _bitmapChanged:Boolean;
        private var _lifeUpdate:Boolean;
        private var _disposed:Boolean;
        protected var _lightVible:Boolean = true;

        public function BaseCharacter(_arg_1:PlayerInfo, _arg_2:Boolean)
        {
            this._info = _arg_1;
            this._lifeUpdate = _arg_2;
            super();
            this.init();
            this.initEvent();
        }

        public function get characterWidth():Number
        {
            return (this._characterWidth);
        }

        public function get characterHeight():Number
        {
            return (this._characterHeight);
        }

        public function set LightVible(_arg_1:Boolean):void
        {
            this._lightVible = _arg_1;
        }

        public function get LightVible():Boolean
        {
            return (this._lightVible);
        }

        protected function init():void
        {
            this._currentframe = -1;
            this.initSizeAndPics();
            this.createFrames();
            this._container = new Sprite();
            addChild(this._container);
            this._body = new Bitmap(new BitmapData((this._characterWidth + 1), this._characterHeight, true, 0), PixelSnapping.NEVER, true);
            this._container.addChild(this._body);
            mouseChildren = (mouseEnabled = false);
            this._loadCompleted = false;
        }

        protected function initSizeAndPics():void
        {
            this.setCharacterSize(BASE_WIDTH, BASE_HEIGHT);
            this.setPicNum(1, 3);
        }

        protected function initEvent():void
        {
            this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__propertyChange);
            addEventListener(Event.ADDED_TO_STAGE, this.__addToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, this.__removeFromStage);
        }

        private function __addToStage(_arg_1:Event):void
        {
            if (this._lifeUpdate)
            {
                addEventListener(Event.ENTER_FRAME, this.__enterFrame);
            };
        }

        private function __removeFromStage(_arg_1:Event):void
        {
            removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
        }

        private function __enterFrame(_arg_1:Event):void
        {
            this.update();
        }

        public function update():void
        {
        }

        private function __propertyChange(_arg_1:PlayerPropertyEvent):void
        {
            if (((((_arg_1.changedProperties[PlayerInfo.STYLE]) || (_arg_1.changedProperties[PlayerInfo.COLORS])) || (_arg_1.changedProperties[PlayerInfo.NIMBUS])) || (GameManager.Instance.MissionOverType == ExpView.GAME_OVER_TYPE_2)))
            {
                if (GameManager.Instance.MissionOverType == ExpView.GAME_OVER_TYPE_4)
                {
                    if (this._loader)
                    {
                        this._loader.update();
                        return;
                    };
                };
                if (this._loader == null)
                {
                    this.initLoader();
                    if (this._loader == null)
                    {
                        return;
                    };
                    if (GameManager.Instance.MissionOverType == ExpView.GAME_OVER_TYPE_4)
                    {
                        GameManager.Instance.MissionOverType = ExpView.GAME_OVER_TYPE_0;
                    };
                    this._loader.load(this.__loadComplete);
                }
                else
                {
                    this._loader.update();
                };
            };
        }

        protected function setCharacterSize(_arg_1:Number, _arg_2:Number):void
        {
            this._characterWidth = _arg_1;
            this._characterHeight = _arg_2;
        }

        protected function setPicNum(_arg_1:int, _arg_2:int):void
        {
            this._picLines = _arg_1;
            this._picsPerLine = _arg_2;
        }

        public function setColor(_arg_1:*):Boolean
        {
            return (false);
        }

        public function get info():PlayerInfo
        {
            return (this._info);
        }

        public function get currentFrame():int
        {
            return (this._currentframe);
        }

        public function set characterBitmapdata(_arg_1:BitmapData):void
        {
            if (_arg_1 == this._characterBitmapdata)
            {
                return;
            };
            this._characterBitmapdata = _arg_1;
            this._bitmapChanged = true;
        }

        public function get characterBitmapdata():BitmapData
        {
            return (this._characterBitmapdata);
        }

        public function get completed():Boolean
        {
            return (this._loadCompleted);
        }

        public function getCharacterLoadLog():String
        {
            if ((this._loader is ShowCharacterLoader))
            {
                return ((this._loader as ShowCharacterLoader).getUnCompleteLog());
            };
            return ("not ShowCharacterLoader");
        }

        public function doAction(_arg_1:*):void
        {
        }

        public function setDefaultAction(_arg_1:*):void
        {
        }

        public function show(_arg_1:Boolean=true, _arg_2:int=1, _arg_3:Boolean=true):void
        {
            this._dir = ((_arg_2 > 0) ? 1 : -1);
            scaleX = this._dir;
            this._autoClearLoader = _arg_1;
            if ((!(this._loadCompleted)))
            {
                if (this._loader == null)
                {
                    this.initLoader();
                };
                this._loader.load(this.__loadComplete);
            };
        }

        protected function __loadComplete(_arg_1:ICharacterLoader):void
        {
            this._loadCompleted = true;
            this.setContent();
            if (((this._autoClearLoader) && (!(this._loader == null))))
            {
                this._loader.dispose();
                this._loader = null;
            };
            dispatchEvent(new Event(Event.COMPLETE));
        }

        protected function setContent():void
        {
            if (this._loader != null)
            {
                if (((this._characterBitmapdata) && (!(this._characterBitmapdata == this._loader.getContent()[0]))))
                {
                    this._characterBitmapdata.dispose();
                };
                this.characterBitmapdata = this._loader.getContent()[0];
            };
            this.drawFrame(this._currentframe);
        }

        public function setFactory(_arg_1:ICharacterLoaderFactory):void
        {
            this._factory = _arg_1;
        }

        protected function initLoader():void
        {
            if (this._info == null)
            {
                return;
            };
            this._loader = this._factory.createLoader(this._info, CharacterLoaderFactory.SHOW);
        }

        public function drawFrame(_arg_1:int, _arg_2:int=0, _arg_3:Boolean=true):void
        {
            if (this._characterBitmapdata != null)
            {
                if (((_arg_1 < 0) || (_arg_1 >= this._frames.length)))
                {
                    _arg_1 = 0;
                };
                if (((!(_arg_1 == this._currentframe)) || (this._bitmapChanged)))
                {
                    this._bitmapChanged = false;
                    this._currentframe = _arg_1;
                    this._body.bitmapData.copyPixels(this._characterBitmapdata, this._frames[this._currentframe], new Point(0, 0));
                };
            };
        }

        protected function createFrames():void
        {
            var _local_2:int;
            var _local_3:Rectangle;
            this._frames = [];
            var _local_1:int;
            while (_local_1 < this._picLines)
            {
                _local_2 = 0;
                while (_local_2 < this._picsPerLine)
                {
                    _local_3 = new Rectangle((_local_2 * this._characterWidth), (_local_1 * this._characterHeight), this._characterWidth, this._characterHeight);
                    this._frames.push(_local_3);
                    _local_2++;
                };
                _local_1++;
            };
        }

        public function set smoothing(_arg_1:Boolean):void
        {
            this._body.smoothing = _arg_1;
        }

        public function set showGun(_arg_1:Boolean):void
        {
        }

        public function setShowLight(_arg_1:Boolean, _arg_2:Point=null):void
        {
        }

        public function get currentAction():*
        {
            return ("");
        }

        public function actionPlaying():Boolean
        {
            return (false);
        }

        public function dispose():void
        {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__propertyChange);
            this._disposed = true;
            this._info = null;
            removeEventListener(Event.ADDED_TO_STAGE, this.__addToStage);
            removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
            removeEventListener(Event.REMOVED_FROM_STAGE, this.__removeFromStage);
            if (this._loader)
            {
                this._loader.dispose();
                this._loader = null;
            };
            this._factory = null;
            if (parent)
            {
                parent.removeChild(this);
            };
            ObjectUtils.disposeObject(this._body);
            this._body = null;
            if (this._characterBitmapdata)
            {
                this._characterBitmapdata.dispose();
            };
            this._characterBitmapdata = null;
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }


    }
}//package ddt.view.character

