// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.weddingRoomList.WeddingRoomListItemView

package church.view.weddingRoomList
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.data.ChurchRoomInfo;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;

    public class WeddingRoomListItemView extends Sprite implements Disposeable 
    {

        private var _selected:Boolean;
        private var _churchRoomInfo:ChurchRoomInfo;
        private var _weddingRoomListItemAsset:ScaleLeftRightImage;
        private var _weddingRoomListItemNumber:FilterFrameText;
        private var _roomListItemLockAsset:Bitmap;
        private var _weddingRoomListItemName:FilterFrameText;
        private var _weddingRoomListItemCount:FilterFrameText;

        public function WeddingRoomListItemView()
        {
            this.initialize();
            this.initEvent();
        }

        protected function initialize():void
        {
            mouseChildren = false;
            this.selected = false;
            buttonMode = true;
            this._weddingRoomListItemAsset = ComponentFactory.Instance.creatComponentByStylename("church.main.WeddingRoomListItem.light");
            addChild(this._weddingRoomListItemAsset);
            this._weddingRoomListItemAsset.visible = false;
            this._weddingRoomListItemNumber = ComponentFactory.Instance.creat("asset.church.main.weddingRoomListItemNumberAsset");
            addChild(this._weddingRoomListItemNumber);
            this._roomListItemLockAsset = ComponentFactory.Instance.creatBitmap("asset.church.roomListItemLockAsset");
            this._roomListItemLockAsset.visible = false;
            addChild(this._roomListItemLockAsset);
            this._weddingRoomListItemName = ComponentFactory.Instance.creat("asset.church.main.weddingRoomListItemNameAsset");
            addChild(this._weddingRoomListItemName);
            this._weddingRoomListItemCount = ComponentFactory.Instance.creat("asset.church.main.weddingRoomListItemCountAsset");
            addChild(this._weddingRoomListItemCount);
        }

        private function update():void
        {
            if (this._churchRoomInfo)
            {
                this._weddingRoomListItemNumber.text = this._churchRoomInfo.id.toString();
                this._weddingRoomListItemNumber.width = 70;
                this._roomListItemLockAsset.visible = this._churchRoomInfo.isLocked;
                this._weddingRoomListItemName.text = this._churchRoomInfo.roomName;
                if (this._weddingRoomListItemName.text.length > 18)
                {
                    this._weddingRoomListItemName.text = (this._weddingRoomListItemName.text.substr(0, 16) + "..");
                };
                this._weddingRoomListItemName.width = ((this._churchRoomInfo.isLocked) ? 186 : 212);
                if (((this._churchRoomInfo.status == ChurchRoomInfo.WEDDING_ING) && (this._churchRoomInfo.currentNum < 2)))
                {
                    this._weddingRoomListItemCount.text = "2/100";
                }
                else
                {
                    this._weddingRoomListItemCount.text = (String(this._churchRoomInfo.currentNum) + "/100");
                };
                if (((this._churchRoomInfo.currentNum >= 100) || (this._churchRoomInfo.status == ChurchRoomInfo.WEDDING_ING)))
                {
                    this.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                }
                else
                {
                    this.filters = ComponentFactory.Instance.creatFilters("lightFilter");
                };
            };
        }

        private function initEvent():void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandler);
        }

        private function removeEvent():void
        {
            removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandler);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandler);
        }

        private function __mouseOverHandler(_arg_1:MouseEvent):void
        {
            this._weddingRoomListItemAsset.visible = true;
            this._weddingRoomListItemNumber.setFrame(2);
            this._weddingRoomListItemName.setFrame(2);
            this._weddingRoomListItemCount.setFrame(2);
        }

        private function __mouseOutHandler(_arg_1:MouseEvent):void
        {
            this._weddingRoomListItemAsset.visible = false;
            this._weddingRoomListItemNumber.setFrame(1);
            this._weddingRoomListItemName.setFrame(1);
            this._weddingRoomListItemCount.setFrame(1);
        }

        public function get selected():Boolean
        {
            return (this._selected);
        }

        public function set selected(_arg_1:Boolean):void
        {
            if (this._weddingRoomListItemAsset)
            {
                this._weddingRoomListItemAsset.visible = _arg_1;
            };
            if (this._selected == _arg_1)
            {
                return;
            };
            this._selected = _arg_1;
            this.update();
        }

        public function get churchRoomInfo():ChurchRoomInfo
        {
            return (this._churchRoomInfo);
        }

        public function set churchRoomInfo(_arg_1:ChurchRoomInfo):void
        {
            this._churchRoomInfo = _arg_1;
            this.update();
        }

        public function dispose():void
        {
            this.removeEvent();
            this._churchRoomInfo = null;
            if (this._weddingRoomListItemAsset)
            {
                if (this._weddingRoomListItemAsset.parent)
                {
                    this._weddingRoomListItemAsset.parent.removeChild(this._weddingRoomListItemAsset);
                };
                this._weddingRoomListItemAsset.dispose();
            };
            this._weddingRoomListItemAsset = null;
            if (this._weddingRoomListItemNumber)
            {
                if (this._weddingRoomListItemNumber.parent)
                {
                    this._weddingRoomListItemNumber.parent.removeChild(this._weddingRoomListItemNumber);
                };
                this._weddingRoomListItemNumber.dispose();
            };
            this._weddingRoomListItemNumber = null;
            if (this._weddingRoomListItemName)
            {
                if (this._weddingRoomListItemName.parent)
                {
                    this._weddingRoomListItemName.parent.removeChild(this._weddingRoomListItemName);
                };
                this._weddingRoomListItemName.dispose();
            };
            this._weddingRoomListItemName = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package church.view.weddingRoomList

