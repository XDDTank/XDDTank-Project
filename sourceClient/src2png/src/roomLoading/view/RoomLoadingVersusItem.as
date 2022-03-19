// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomLoading.view.RoomLoadingVersusItem

package roomLoading.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.filters.GlowFilter;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.greensock.TweenMax;
    import flash.events.Event;
    import com.greensock.easing.Sine;
    import com.pickgliss.utils.ObjectUtils;

    public class RoomLoadingVersusItem extends Sprite implements Disposeable 
    {

        private var _gameType:Bitmap;
        private var _gameTypeBg:Bitmap;
        private var _versusMc:DisplayObject;
        private var _gameMode:int;
        private var _glowFilter:GlowFilter;

        public function RoomLoadingVersusItem(_arg_1:int)
        {
            this._gameMode = _arg_1;
            this.init();
        }

        private function init():void
        {
            this._glowFilter = new GlowFilter();
            this._versusMc = ComponentFactory.Instance.creat("asset.roomloading.versus");
            this._gameTypeBg = ComponentFactory.Instance.creatBitmap("asset.roomloading.gameTypeBg");
            PositionUtils.setPos(this._versusMc, "asset.roomLoading.VersusAnimationPos");
            PositionUtils.setPos(this._gameTypeBg, "asset.roomLoading.GameTypeBgPos");
            this._versusMc.addEventListener("moveTimeTxt", this.__onMoveTimeTxt);
            addChild(this._versusMc);
            this.createGameModeTxt();
            TweenMax.from(this._gameType, 1, {
                "alpha":0,
                "delay":1
            });
            TweenMax.from(this._gameTypeBg, 1, {
                "alpha":0,
                "delay":1
            });
        }

        private function __onMoveTimeTxt(_arg_1:Event):void
        {
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function addEffect():void
        {
            TweenMax.to(this._glowFilter, 0.45, {
                "startAt":{
                    "blurX":0,
                    "blurY":0,
                    "color":0xFFCC00,
                    "strength":0
                },
                "blurX":5,
                "blurY":5,
                "color":0xFF6600,
                "strength":0.6,
                "yoyo":true,
                "repeat":-1,
                "ease":Sine.easeOut,
                "onUpdate":this.updateFilter
            });
        }

        private function updateFilter():void
        {
            this._gameType.filters = [this._glowFilter];
        }

        private function createGameModeTxt():void
        {
            switch (this._gameMode)
            {
                case 0:
                case 4:
                case 9:
                case 11:
                    this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_0");
                    break;
                case 1:
                    this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_1");
                    break;
                case 2:
                    this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_2");
                    break;
                case 7:
                case 10:
                case 18:
                    this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_7");
                    break;
                case 8:
                    this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_8");
                    break;
                case 12:
                case 13:
                    this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_12");
                    break;
                case 15:
                case 16:
                    this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_14");
                    break;
                case 17:
                    this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_17");
                    break;
                default:
                    this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_0");
            };
            if (this._gameType)
            {
            };
        }

        public function get displayMc():DisplayObject
        {
            return (this._versusMc);
        }

        public function dispose():void
        {
            if (this._gameType)
            {
                TweenMax.killTweensOf(this._gameType);
            };
            if (this._glowFilter)
            {
                TweenMax.killTweensOf(this._glowFilter);
            };
            if (this._gameType)
            {
                this._gameType.filters = null;
            };
            ObjectUtils.disposeAllChildren(this);
            this._versusMc.removeEventListener("moveTimeTxt", this.__onMoveTimeTxt);
            this._gameType = null;
            this._gameTypeBg = null;
            this._glowFilter = null;
            this._versusMc = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package roomLoading.view

