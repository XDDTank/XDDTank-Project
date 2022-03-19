﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.churchFire.ChurchFireItemView

package church.view.churchFire
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import ddt.data.goods.ShopItemInfo;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.manager.ShopManager;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.MouseEvent;

    public class ChurchFireItemView extends Sprite implements Disposeable 
    {

        private var _fireIcon:Bitmap;
        private var _fireTemplateID:int;
        private var _shopItemInfo:ShopItemInfo;
        private var _fireItemBox:Bitmap;
        private var _fireItemBoxAc:Bitmap;
        private var _fireIconRectangle:Rectangle;
        private var _fireItemGlod:FilterFrameText;

        public function ChurchFireItemView(_arg_1:int, _arg_2:Bitmap)
        {
            this._fireIcon = _arg_2;
            this.fireTemplateID = _arg_1;
            this.initialize();
        }

        public function get fireTemplateID():int
        {
            return (this._fireTemplateID);
        }

        public function set fireTemplateID(_arg_1:int):void
        {
            this._fireTemplateID = _arg_1;
            this._shopItemInfo = ShopManager.Instance.getGoldShopItemByTemplateID(this._fireTemplateID);
        }

        public function get fireIcon():Bitmap
        {
            return (this._fireIcon);
        }

        public function set fireIcon(_arg_1:Bitmap):void
        {
            this._fireIcon = _arg_1;
        }

        private function initialize():void
        {
            this.setView();
            this.setEvent();
        }

        private function setView():void
        {
            this.buttonMode = true;
            this._fireIconRectangle = ComponentFactory.Instance.creatCustomObject("asset.church.room.fireIconRectangle");
            this._fireItemBox = ComponentFactory.Instance.creatBitmap("asset.church.room.fireItemBoxAsset");
            addChild(this._fireItemBox);
            if (this._fireIcon)
            {
                this._fireIcon.smoothing = true;
                this._fireIcon.x = this._fireIconRectangle.x;
                this._fireIcon.y = this._fireIconRectangle.y;
                this._fireIcon.width = this._fireIconRectangle.width;
                this._fireIcon.height = this._fireIconRectangle.height;
                addChild(this._fireIcon);
            };
            this._fireItemGlod = ComponentFactory.Instance.creat("church.room.fireItemGlodAsset");
            this._fireItemGlod.text = (String(this._shopItemInfo.getItemPrice(1).goldValue) + "G");
            addChild(this._fireItemGlod);
            this._fireItemBoxAc = ComponentFactory.Instance.creatBitmap("asset.church.room.fireItemBoxAcAsset");
            this._fireItemBoxAc.visible = false;
            addChild(this._fireItemBoxAc);
        }

        private function removeView():void
        {
            this._shopItemInfo = null;
            this._fireIcon = null;
            ObjectUtils.disposeObject(this._fireItemBox);
            this._fireItemBox = null;
            ObjectUtils.disposeObject(this._fireItemBoxAc);
            this._fireItemBoxAc = null;
            this._fireIconRectangle = null;
            ObjectUtils.disposeObject(this._fireItemGlod);
            this._fireItemGlod = null;
            if (parent)
            {
                this.parent.removeChild(this);
            };
        }

        private function setEvent():void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }

        private function removeEvent():void
        {
            removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }

        private function onMouseOver(_arg_1:MouseEvent):void
        {
            this._fireItemBoxAc.visible = true;
        }

        private function onMouseOut(_arg_1:MouseEvent):void
        {
            this._fireItemBoxAc.visible = false;
        }

        public function dispose():void
        {
            this.removeEvent();
            this.removeView();
        }


    }
}//package church.view.churchFire

