// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.PlayerPortraitView

package ddt.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.view.character.ShowCharacter;
    import flash.display.Bitmap;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import ddt.view.character.CharactoryFactory;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.geom.Point;

    public class PlayerPortraitView extends Sprite implements Disposeable 
    {

        public static const LEFT:String = "left";
        public static const RIGHT:String = "right";

        private var _type:int;
        private var _character:ShowCharacter;
        private var _figure:Bitmap;
        private var _iconBg:Bitmap;
        private var _directrion:String;
        private var _info:PlayerInfo;

        public function PlayerPortraitView(_arg_1:String="left", _arg_2:int=0, _arg_3:Bitmap=null)
        {
            if (_arg_3 == null)
            {
                _arg_3 = ComponentFactory.Instance.creatBitmap("asset.ddtgift.playerIcon");
            };
            this._directrion = _arg_1;
            this._type = _arg_2;
            this._iconBg = _arg_3;
            addChild(this._iconBg);
            mouseChildren = (mouseEnabled = false);
        }

        public function set info(_arg_1:PlayerInfo):void
        {
            this.showFigure(_arg_1);
        }

        public function set isShowFrame(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                addChildAt(this._iconBg, 0);
            }
            else
            {
                if (contains(this._iconBg))
                {
                    removeChild(this._iconBg);
                };
            };
        }

        private function showFigure(_arg_1:PlayerInfo):void
        {
            this._info = _arg_1;
            if (this._character)
            {
                this._character.removeEventListener(Event.COMPLETE, this.__characterComplete);
                this._character.dispose();
                this._character = null;
            };
            if ((((this._figure) && (this._figure.parent)) && (this._figure.bitmapData)))
            {
                this._figure.parent.removeChild(this._figure);
                this._figure.bitmapData.dispose();
                this._figure = null;
            };
            this._character = (CharactoryFactory.createCharacter(_arg_1) as ShowCharacter);
            this._character.addEventListener(Event.COMPLETE, this.__characterComplete);
            this._character.showGun = false;
            this._character.setShowLight(false, null);
            this._character.stopAnimation();
            this._character.show(true, 1);
            this._character.buttonMode = (this._character.mouseEnabled = (this._character.mouseEnabled = false));
        }

        private function __characterComplete(_arg_1:Event):void
        {
            if ((((this._figure) && (this._figure.parent)) && (this._figure.bitmapData)))
            {
                this._figure.parent.removeChild(this._figure);
                this._figure.bitmapData.dispose();
                this._figure = null;
            };
            if (this._type == 1)
            {
                this._figure = new Bitmap(new BitmapData(200, 200));
                this._figure.bitmapData.copyPixels(this._character.characterBitmapdata, new Rectangle(0, 10, 200, 200), new Point(0, 0));
                this._figure.scaleX = (0.35 * ((this._directrion == LEFT) ? 1 : -1));
                this._figure.scaleY = 0.35;
                this._figure.x = ((this._directrion == LEFT) ? 0 : 73);
                this._figure.y = 5;
            }
            else
            {
                if ((!(this._character.info.getShowSuits())))
                {
                    this._figure = new Bitmap(new BitmapData(200, 150));
                    this._figure.bitmapData.copyPixels(this._character.characterBitmapdata, new Rectangle(0, 60, 200, 150), new Point(0, 0));
                    this._figure.scaleX = (0.45 * ((this._directrion == LEFT) ? 1 : -1));
                    this._figure.scaleY = 0.45;
                    this._figure.x = ((this._directrion == LEFT) ? 0 : 85);
                    this._figure.y = 7;
                }
                else
                {
                    this._figure = new Bitmap(new BitmapData(200, 200));
                    this._figure.bitmapData.copyPixels(this._character.characterBitmapdata, new Rectangle(0, 10, 200, 200), new Point(0, 0));
                    this._figure.scaleX = (0.35 * ((this._directrion == LEFT) ? 1 : -1));
                    this._figure.scaleY = 0.35;
                    this._figure.x = ((this._directrion == LEFT) ? 0 : 73);
                    this._figure.y = 5;
                };
            };
            addChild(this._figure);
        }

        public function setFigureSize():void
        {
            this._figure.scaleX = (0.35 * ((this._directrion == LEFT) ? 1 : -1));
            this._figure.scaleY = 0.35;
        }

        public function dispose():void
        {
            this._info = null;
            if (this._character)
            {
                this._character.removeEventListener(Event.COMPLETE, this.__characterComplete);
                this._character.dispose();
                this._character = null;
            };
            if ((((this._figure) && (this._figure.parent)) && (this._figure.bitmapData)))
            {
                this._figure.parent.removeChild(this._figure);
                this._figure.bitmapData.dispose();
                this._figure = null;
            };
            if ((((this._iconBg) && (this._iconBg.parent)) && (this._iconBg.bitmapData)))
            {
                this._iconBg.parent.removeChild(this._iconBg);
                this._iconBg.bitmapData.dispose();
                this._iconBg = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view

