// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//vip.view.SpreeItem

package vip.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.view.tips.OneLineTip;
    import ddt.data.VipConfigInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.VipPrivilegeConfigManager;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class SpreeItem extends Sprite implements Disposeable 
    {

        private var _itemBg:Bitmap;
        private var _SpreeBg:Bitmap;
        private var _itemTxt:FilterFrameText;
        private var _itemTip:OneLineTip;
        private var _vipInfo:VipConfigInfo;

        public function SpreeItem()
        {
            this.init();
        }

        private function init():void
        {
            this._itemBg = ComponentFactory.Instance.creatBitmap("asset.ddtvip.CellBg");
            this._itemTxt = ComponentFactory.Instance.creatComponentByStylename("ddtvip.itemTxt");
            this._itemTip = new OneLineTip();
            addChild(this._itemBg);
            addChild(this._itemTxt);
            addChild(this._itemTip);
            this._itemTip.visible = false;
        }

        public function setItem(_arg_1:int):void
        {
            this._vipInfo = VipPrivilegeConfigManager.Instance.getById((_arg_1 + 1));
            this._SpreeBg = ComponentFactory.Instance.creatBitmap(("asset.ddtVip.spcee" + (_arg_1 + 1).toString()));
            this._SpreeBg.width = 40;
            this._SpreeBg.height = 40;
            this._SpreeBg.x = 6;
            this._SpreeBg.y = 6;
            this._SpreeBg.smoothing = true;
            addChild(this._SpreeBg);
            this._itemTxt.text = LanguageMgr.GetTranslation(("ddtvip.itemText" + (_arg_1 + 1).toString()));
            this._itemTip.tipData = LanguageMgr.GetTranslation(("ddtvip.itemText.tips" + (_arg_1 + 1).toString()));
            addEventListener(MouseEvent.MOUSE_OVER, this.__onMouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT, this.__onMouseOutHandler);
        }

        private function __onMouseOverHandler(_arg_1:MouseEvent):void
        {
            var _local_2:Point;
            if (this._itemTip)
            {
                this._itemTip.visible = true;
                LayerManager.Instance.addToLayer(this._itemTip, LayerManager.GAME_TOP_LAYER);
                _local_2 = this._SpreeBg.localToGlobal(new Point(0, 0));
                this._itemTip.x = _local_2.x;
                this._itemTip.y = (_local_2.y + this._SpreeBg.height);
            };
        }

        private function __onMouseOutHandler(_arg_1:MouseEvent):void
        {
            if (this._itemTip)
            {
                this._itemTip.visible = false;
            };
        }

        private function removeEvent():void
        {
            removeEventListener(MouseEvent.MOUSE_OVER, this.__onMouseOverHandler);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__onMouseOutHandler);
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._itemBg);
            this._itemBg = null;
            ObjectUtils.disposeObject(this._SpreeBg);
            this._SpreeBg = null;
            ObjectUtils.disposeObject(this._itemTxt);
            this._itemTxt = null;
            ObjectUtils.disposeObject(this._itemTip);
            this._itemTip = null;
        }


    }
}//package vip.view

