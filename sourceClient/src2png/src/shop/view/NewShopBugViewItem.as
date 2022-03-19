// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.view.NewShopBugViewItem

package shop.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.controls.ISelectable;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    public class NewShopBugViewItem extends Sprite implements ISelectable, Disposeable 
    {

        private var _bg:ScaleFrameImage;
        private var _lightEffect:ScaleBitmapImage;
        private var _cell:ShopItemCell;
        private var _count:String;
        private var _money:int;
        private var _countTxt:FilterFrameText;
        private var _countBg:Bitmap;
        private var _moneyTxt:FilterFrameText;
        private var _type:int;

        public function NewShopBugViewItem(_arg_1:int=0, _arg_2:String="", _arg_3:int=0, _arg_4:ShopItemCell=null)
        {
            buttonMode = true;
            this._type = _arg_1;
            this._count = _arg_2;
            this._money = _arg_3;
            this._cell = _arg_4;
            this._cell.width = (this._cell.height = 61);
            PositionUtils.setPos(this._cell, "ddtshop.NewShopBugViewItem.cell.pos");
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.BugleViewBg");
            this._lightEffect = ComponentFactory.Instance.creatComponentByStylename("asset.ddtshop.BugleSelectLight");
            this._lightEffect.visible = false;
            this._lightEffect.x = 14;
            this._lightEffect.y = 10;
            this._countTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.newBugleViewCountText");
            this._countBg = ComponentFactory.Instance.creatBitmap("asset.ddtstore.ShortcutTextBg");
            this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.newBugleViewMoneyText");
            this._countTxt.mouseEnabled = (this._moneyTxt.mouseEnabled = false);
            this._count = this.getSpecifiedString(this._count);
            this._countTxt.text = this._count;
            this._moneyTxt.text = (String(this._money) + LanguageMgr.GetTranslation("ddtMoney"));
            this._bg.setFrame(1);
            addChild(this._bg);
            addChild(this._cell);
            addChild(this._countTxt);
            addChild(this._countBg);
            addChild(this._moneyTxt);
            addChild(this._lightEffect);
        }

        private function getSpecifiedString(_arg_1:String):String
        {
            if ((!(_arg_1)))
            {
                return ("");
            };
            var _local_2:String = "";
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                if (((_arg_1.charCodeAt(_local_3) >= 48) && (_arg_1.charCodeAt(_local_3) <= 57)))
                {
                    _local_2 = (_local_2 + _arg_1.charAt(_local_3));
                };
                _local_3++;
            };
            return ("+" + _local_2);
        }

        public function set autoSelect(_arg_1:Boolean):void
        {
        }

        public function get selected():Boolean
        {
            return (this._lightEffect.visible);
        }

        public function set selected(_arg_1:Boolean):void
        {
            this._lightEffect.visible = _arg_1;
        }

        public function asDisplayObject():DisplayObject
        {
            return (this as DisplayObject);
        }

        public function get type():int
        {
            return (this._type);
        }

        public function get count():String
        {
            return (this._count);
        }

        public function get money():int
        {
            return (this._money);
        }

        public function dispose():void
        {
            this._bg.dispose();
            this._bg = null;
            this._cell.dispose();
            this._cell = null;
            this._countTxt.dispose();
            this._countTxt = null;
            this._moneyTxt.dispose();
            this._moneyTxt = null;
            if (this._lightEffect)
            {
                ObjectUtils.disposeObject(this._lightEffect);
            };
            this._lightEffect = null;
            if (this._countBg)
            {
                ObjectUtils.disposeObject(this._countBg);
            };
            this._countBg = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package shop.view

