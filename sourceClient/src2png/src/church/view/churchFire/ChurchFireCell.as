// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.churchFire.ChurchFireCell

package church.view.churchFire
{
    import bagAndInfo.cell.BaseCell;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import ddt.data.goods.ShopItemInfo;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import ddt.manager.ShopManager;
    import flash.events.MouseEvent;

    public class ChurchFireCell extends BaseCell implements Disposeable 
    {

        public static const CONTENT_SIZE:int = 48;

        private var _fireIcon:Bitmap;
        private var _fireTemplateID:int;
        private var _shopItemInfo:ShopItemInfo;
        private var _fireItemBox:Bitmap;
        private var _fireItemBoxAc:Bitmap;
        private var _fireIconRectangle:Rectangle;
        private var _fireItemGlod:FilterFrameText;

        public function ChurchFireCell(_arg_1:DisplayObject, _arg_2:ShopItemInfo, _arg_3:int)
        {
            super(_arg_1, _arg_2.TemplateInfo, true, true);
            this._shopItemInfo = _arg_2;
            this._fireTemplateID = _arg_3;
            this.initialize();
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
            this._fireItemGlod = ComponentFactory.Instance.creat("church.room.fireItemGlodAsset");
            this._fireItemGlod.text = (String(this._shopItemInfo.getItemPrice(1).goldValue) + "G");
            addChild(this._fireItemGlod);
            this._fireItemBoxAc = ComponentFactory.Instance.creatBitmap("asset.church.room.fireItemBoxAcAsset");
            this._fireItemBoxAc.visible = false;
            addChild(this._fireItemBoxAc);
        }

        override protected function createChildren():void
        {
            var _local_1:Point;
            addChildAt(_bg, 0);
            _local_1 = ComponentFactory.Instance.creatCustomObject("church.ChurchFireCell.bgPos");
            _bg.x = _local_1.x;
            _bg.y = _local_1.y;
            _contentWidth = (_bg.width = CONTENT_SIZE);
            _contentHeight = (_bg.height = CONTENT_SIZE);
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

        private function setEvent():void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }

        override protected function onMouseOver(_arg_1:MouseEvent):void
        {
            super.onMouseOver(_arg_1);
            this._fireItemBoxAc.visible = true;
        }

        override protected function onMouseOut(_arg_1:MouseEvent):void
        {
            super.onMouseOut(_arg_1);
            this._fireItemBoxAc.visible = false;
        }


    }
}//package church.view.churchFire

