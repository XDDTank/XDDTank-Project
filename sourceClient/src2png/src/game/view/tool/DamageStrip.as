// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.tool.DamageStrip

package game.view.tool
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.MovieClip;
    import flash.display.Bitmap;
    import flash.geom.Point;
    import game.objects.DamageObject;
    import com.pickgliss.ui.UICreatShortcut;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import com.greensock.TweenLite;
    import flash.display.BitmapData;
    import game.GameManager;
    import flash.geom.Rectangle;

    public class DamageStrip extends Sprite implements Disposeable 
    {

        public static const HEIGHT:int = 42;

        private var _damageText:FilterFrameText;
        private var _damageText2:FilterFrameText;
        private var _reduceMC:MovieClip;
        private var _damageBg:MovieClip;
        private var _picBmp:Bitmap;
        private var _picPos:Point;
        private var _width:Number = 0;
        private var _info:DamageObject;

        public function DamageStrip()
        {
            this.init();
        }

        protected function init():void
        {
            this._damageText = UICreatShortcut.creatAndAdd("ddt.multiShoot.damageText", this);
            this._damageText2 = UICreatShortcut.creatAndAdd("ddt.multiShoot.damageText2", this);
            this._damageText2.text = LanguageMgr.GetTranslation("ddt.game.view.damageStasticText3");
            this._reduceMC = UICreatShortcut.creatAndAdd("ddt.game.view.damageStrip.reduceMC", this);
            this._picPos = ComponentFactory.Instance.creat("ddt.game.view.damageStrip.numPos");
        }

        override public function get height():Number
        {
            return (HEIGHT);
        }

        public function get info():DamageObject
        {
            return (this._info);
        }

        public function set info(_arg_1:DamageObject):void
        {
            var _local_2:int;
            this._info = _arg_1;
            if (this._info)
            {
                _local_2 = String(this._info.damage).length;
                if (_local_2 > 5)
                {
                    _local_2 = 5;
                };
                this._damageBg = ComponentFactory.Instance.creat(("asset.game.damageBgAsset" + _local_2));
                addChildAt(this._damageBg, 0);
                this._damageBg.stop();
                this._damageText.htmlText = LanguageMgr.GetTranslation(("ddt.game.view.damageStasticText" + ((this._info.isSelf) ? 1 : 2)), this._info.playerName);
                this._damageText.alpha = 0.2;
                this._damageText.y = 23;
                ObjectUtils.disposeObject(this._picBmp);
                this._picBmp = this.getPercent(this._info.damage);
                this._picBmp.y = (this._picPos.y + 23);
                addChild(this._picBmp);
                this._picBmp.alpha = 0.2;
                if (this._info.reducePercent > 0)
                {
                    this._reduceMC.setPercent(this._info.reducePercent);
                    this._reduceMC.visible = true;
                }
                else
                {
                    this._reduceMC.visible = false;
                };
                this.width = (((this._damageText.width + this._picBmp.width) + this._damageText2.width) + ((this._reduceMC.visible) ? 150 : 0));
            };
        }

        public function show():void
        {
            TweenLite.to(this._damageText, 0.2, {
                "alpha":1,
                "y":0
            });
            TweenLite.to(this._picBmp, 0.2, {
                "alpha":1,
                "y":this._picPos.y
            });
            this._reduceMC.gotoAndPlay(1);
            this._damageBg.gotoAndPlay(1);
        }

        override public function set width(_arg_1:Number):void
        {
            var _local_2:int;
            this._width = _arg_1;
            if (this._reduceMC.visible)
            {
                this._damageText.x = -(_arg_1);
                this._picBmp.x = ((this._damageText.x + this._damageText.width) - 1);
                this._damageText2.x = ((this._damageText.x + this._damageText.width) + this._picBmp.width);
                this._damageBg.x = (this._picBmp.x + (this._picBmp.width / 2));
                this._damageBg.y = ((this._picPos.y + (this._picBmp.height / 2)) - 2);
            }
            else
            {
                _local_2 = 0;
                _local_2 = (this._damageText2.x = (_local_2 - this._damageText2.width));
                _local_2 = (this._picBmp.x = ((_local_2 - this._picBmp.width) - 1));
                this._damageBg.x = (this._picBmp.x + (this._picBmp.width / 2));
                this._damageBg.y = ((this._picPos.y + (this._picBmp.height / 2)) - 2);
                this._damageText.x = (_local_2 - this._damageText.width);
            };
            this._width = _arg_1;
        }

        override public function get width():Number
        {
            return (this._width);
        }

        public function updateUI():void
        {
        }

        public function getTextWidth():Number
        {
            return (this._damageText.textWidth);
        }

        public function getPercent(_arg_1:int):Bitmap
        {
            var _local_8:Bitmap;
            var _local_9:BitmapData;
            if (_arg_1 > 99999999)
            {
                return (null);
            };
            var _local_2:Array = new Array();
            _local_2 = [0, 0, 0, 0];
            var _local_3:Array = new Array();
            var _local_4:String = String(_arg_1);
            var _local_5:int = _local_4.length;
            var _local_6:int;
            while (_local_6 < _local_5)
            {
                _local_9 = GameManager.Instance.numCreater.damageData[int(_local_4.charAt(_local_6))];
                _local_3.push(((_local_6 * _local_9.width) - 1));
                _local_2.push(_local_9);
                _local_6++;
            };
            _local_2 = this.returnNum(_local_2, _local_3);
            var _local_7:BitmapData = new BitmapData(_local_2[2], _local_2[3], true, 0);
            _local_8 = new Bitmap(_local_7, "auto", true);
            _local_6 = 4;
            while (_local_6 < _local_2.length)
            {
                _local_7.copyPixels(_local_2[_local_6], new Rectangle(0, 0, _local_2[_local_6].width, _local_2[_local_6].height), new Point((_local_3[(_local_6 - 4)] - _local_2[0]), (_local_2[_local_6].rect.y - _local_2[1])), null, null, true);
                _local_6++;
            };
            _local_8.x = _local_2[0];
            _local_8.y = _local_2[1];
            _local_2 = null;
            _local_8.smoothing = true;
            return (_local_8);
        }

        private function returnNum(_arg_1:Array, _arg_2:Array):Array
        {
            var _local_3:int = 4;
            while (_local_3 < _arg_1.length)
            {
                _arg_1[0] = ((_arg_1[0] > _arg_2[(_local_3 - 4)]) ? _arg_2[(_local_3 - 4)] : _arg_1[0]);
                _arg_1[1] = ((_arg_1[1] > _arg_1[_local_3].rect.y) ? _arg_1[_local_3].rect.y : _arg_1[1]);
                _arg_1[2] = ((_arg_1[2] > (_arg_1[_local_3].width + _arg_2[(_local_3 - 4)])) ? _arg_1[2] : (_arg_1[_local_3].width + _arg_2[(_local_3 - 4)]));
                _arg_1[3] = ((_arg_1[3] > (_arg_1[_local_3].height + _arg_1[_local_3].rect.y)) ? _arg_1[3] : (_arg_1[_local_3].height + _arg_1[_local_3].rect.y));
                _local_3++;
            };
            _arg_1[2] = (_arg_1[2] - _arg_1[0]);
            _arg_1[3] = (_arg_1[3] - _arg_1[1]);
            return (_arg_1);
        }

        public function dispose():void
        {
            TweenLite.killTweensOf(this._damageText);
            ObjectUtils.disposeObject(this._damageText);
            this._damageText = null;
            ObjectUtils.disposeObject(this._damageText2);
            this._damageText2 = null;
            ObjectUtils.disposeObject(this._reduceMC);
            this._reduceMC = null;
            ObjectUtils.disposeObject(this._picBmp);
            this._picBmp = null;
            ObjectUtils.disposeObject(this._damageBg);
            this._damageBg = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.tool

