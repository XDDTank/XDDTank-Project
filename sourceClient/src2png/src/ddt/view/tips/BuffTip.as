// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.BuffTip

package ddt.view.tips
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.LanguageMgr;

    public class BuffTip extends BaseTip 
    {

        protected var _tempData:Object;
        protected var _bg:ScaleBitmapImage;
        protected var lefttime_txt:Bitmap;
        protected var name_txt:FilterFrameText;
        protected var describe_txt:FilterFrameText;
        protected var days_txt:Bitmap;
        protected var day_txt:FilterFrameText;
        protected var hours_txt:Bitmap;
        protected var hour_txt:FilterFrameText;
        protected var mins_txt:Bitmap;
        protected var min_txt:FilterFrameText;
        protected var _activeSp:Sprite;
        protected var _timegap:int;
        protected var _active:Boolean;
        protected var _free:Boolean;


        protected function drawNameField():void
        {
            this.name_txt = ComponentFactory.Instance.creat("core.TNameTxt");
            this._activeSp.addChild(this.name_txt);
        }

        override protected function init():void
        {
            this._activeSp = new Sprite();
            this._bg = ComponentFactory.Instance.creat("asset.core.tip.buffTipBg");
            this.describe_txt = ComponentFactory.Instance.creat("core.DesTxt");
            this.drawNameField();
            this.lefttime_txt = ComponentFactory.Instance.creat("asset.core.bufftip.LTime");
            this.days_txt = ComponentFactory.Instance.creat("asset.core.bufftip.Day");
            this.day_txt = ComponentFactory.Instance.creat("core.CommonTxt");
            this.hours_txt = ComponentFactory.Instance.creat("asset.core.bufftip.Hour");
            this.hour_txt = ComponentFactory.Instance.creat("core.CommonTxt");
            this.mins_txt = ComponentFactory.Instance.creat("asset.core.bufftip.Min");
            this.min_txt = ComponentFactory.Instance.creat("core.CommonTxt");
            this._activeSp.addChild(this.days_txt);
            this._activeSp.addChild(this.day_txt);
            this._activeSp.addChild(this.hours_txt);
            this._activeSp.addChild(this.hour_txt);
            this._activeSp.addChild(this.mins_txt);
            this._activeSp.addChild(this.min_txt);
            this._activeSp.addChild(this.lefttime_txt);
            this._activeSp.mouseEnabled = false;
            this._activeSp.mouseChildren = false;
            this.describe_txt.mouseEnabled = false;
            this.describe_txt.multiline = true;
            this.describe_txt.wordWrap = true;
            this.describe_txt.width = 170;
            this._timegap = 3;
            super.init();
            this.tipbackgound = this._bg;
        }

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this.describe_txt);
            this.describe_txt.mouseEnabled = false;
            addChild(this._activeSp);
            this._activeSp.mouseEnabled = false;
            this._activeSp.mouseChildren = false;
        }

        override public function set tipData(_arg_1:Object):void
        {
            this._tempData = _arg_1;
            if ((_arg_1 is BuffTipInfo))
            {
                this.visible = true;
                this.setShow(_arg_1.isActive, _arg_1.isFree, _arg_1.day, _arg_1.hour, _arg_1.min, _arg_1.describe);
            }
            else
            {
                this.visible = false;
            };
        }

        override public function get tipData():Object
        {
            return (this._tempData);
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this.name_txt);
            this.name_txt = null;
            ObjectUtils.disposeObject(this.days_txt);
            this.days_txt = null;
            ObjectUtils.disposeObject(this.day_txt);
            this.day_txt = null;
            ObjectUtils.disposeObject(this.hours_txt);
            this.hours_txt = null;
            ObjectUtils.disposeObject(this.hour_txt);
            this.hour_txt = null;
            ObjectUtils.disposeObject(this.mins_txt);
            this.mins_txt = null;
            ObjectUtils.disposeObject(this.min_txt);
            this.min_txt = null;
            if (this.lefttime_txt)
            {
                ObjectUtils.disposeObject(this.lefttime_txt);
            };
            this.lefttime_txt = null;
            if (this._activeSp)
            {
                ObjectUtils.disposeObject(this._activeSp);
            };
            this._activeSp = null;
            ObjectUtils.disposeObject(this.describe_txt);
            this.describe_txt = null;
            super.dispose();
        }

        protected function setShow(_arg_1:Boolean, _arg_2:Boolean, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:String):void
        {
            this._active = _arg_1;
            if (_arg_1)
            {
                this._activeSp.visible = true;
                this.describe_txt.visible = false;
                if (_arg_2)
                {
                    this.showFree(true);
                    this.name_txt.text = LanguageMgr.GetTranslation("tank.view.buffControl.buffButton.freeCard");
                    this.day_txt.text = LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.forever");
                    this.day_txt.x = ((this.lefttime_txt.x + this.lefttime_txt.width) + (this._timegap * 2));
                }
                else
                {
                    this.showFree(false);
                    this.name_txt.text = this._tempData.name;
                    this.day_txt.text = String(_arg_3);
                    this.hour_txt.text = String(_arg_4);
                    this.min_txt.text = String(_arg_5);
                    this.day_txt.x = ((this.lefttime_txt.x + this.lefttime_txt.width) + this._timegap);
                    this.days_txt.x = ((this.day_txt.x + this.day_txt.width) + this._timegap);
                    this.hour_txt.x = ((this.days_txt.x + this.days_txt.width) + this._timegap);
                    this.hours_txt.x = ((this.hour_txt.x + this.hour_txt.width) + this._timegap);
                    this.min_txt.x = ((this.hours_txt.x + this.hours_txt.width) + this._timegap);
                    this.mins_txt.x = ((this.min_txt.x + this.min_txt.width) + this._timegap);
                };
            }
            else
            {
                this.describe_txt.text = _arg_6;
                this._activeSp.visible = false;
                this.describe_txt.visible = true;
            };
            this.updateWH();
        }

        protected function updateWH():void
        {
            var _local_1:int;
            var _local_2:int;
            if (this._tempData.isActive)
            {
                if (this._tempData.isFree)
                {
                    _local_1 = int(((Math.abs(this.name_txt.x) * 2) + this.name_txt.width));
                    _local_2 = int(((this.day_txt.x + this.day_txt.width) + this.name_txt.x));
                    this._bg.width = ((_local_1 > _local_2) ? _local_1 : _local_2);
                }
                else
                {
                    this._bg.width = int((((this.min_txt.x + this.min_txt.width) + this.mins_txt.width) + 4));
                };
                this._bg.height = (this._activeSp.height + (Math.abs(this.name_txt.y) * 2));
            }
            else
            {
                this._bg.width = ((Math.abs(this.describe_txt.x) * 2) + this.describe_txt.width);
                this._bg.height = ((Math.abs(this.describe_txt.y) * 2) + this.describe_txt.height);
            };
            _width = this._bg.width;
            _height = this._bg.height;
        }

        private function showFree(_arg_1:Boolean):void
        {
            this.days_txt.visible = (!(_arg_1));
            this.hours_txt.visible = (!(_arg_1));
            this.hour_txt.visible = (!(_arg_1));
            this.mins_txt.visible = (!(_arg_1));
            this.min_txt.visible = (!(_arg_1));
        }


    }
}//package ddt.view.tips

