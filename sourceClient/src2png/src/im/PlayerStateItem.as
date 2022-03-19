// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.PlayerStateItem

package im
{
    import flash.display.Sprite;
    import com.pickgliss.ui.controls.cell.IDropListCell;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.data.player.PlayerState;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    public class PlayerStateItem extends Sprite implements IDropListCell, Disposeable 
    {

        private var _date:PlayerState;
        private var _stateID:int;
        private var _icon:Bitmap;
        private var _overBg:ScaleLeftRightImage;
        private var _stateName:FilterFrameText;
        private var _selected:Boolean;

        public function PlayerStateItem()
        {
            buttonMode = true;
            this.initView();
        }

        private function initView():void
        {
            graphics.beginFill(0xFFFFFF, 0);
            graphics.drawRect(0, 0, 80, 22);
            graphics.endFill();
            this._overBg = ComponentFactory.Instance.creatComponentByStylename("sset.IM.stateItemOverBgAsset");
            addChild(this._overBg);
            this._overBg.visible = false;
            this._stateName = ComponentFactory.Instance.creatComponentByStylename("IM.stateItem.stateName");
            addChild(this._stateName);
            addEventListener(MouseEvent.MOUSE_OVER, this.__over);
            addEventListener(MouseEvent.MOUSE_OUT, this.__out);
        }

        public function getCellValue():*
        {
            return (this._date);
        }

        public function setCellValue(_arg_1:*):void
        {
            this._date = _arg_1;
            this.update();
        }

        private function update():void
        {
            if (this._icon == null)
            {
                this._icon = this.creatIcon();
                addChild(this._icon);
                this._icon.x = 0;
                this._icon.y = 1;
            };
            this._stateName.text = this._date.convertToString();
        }

        private function __out(_arg_1:MouseEvent):void
        {
            this._overBg.visible = false;
        }

        private function __over(_arg_1:MouseEvent):void
        {
            this._overBg.visible = true;
        }

        public function get selected():Boolean
        {
            return (this._selected);
        }

        public function set selected(_arg_1:Boolean):void
        {
            this._selected = _arg_1;
        }

        private function creatIcon():Bitmap
        {
            switch (this._date.StateID)
            {
                case PlayerState.ONLINE:
                    return (ComponentFactory.Instance.creatBitmap("asset.IM.onlineIconAsset"));
                case PlayerState.AWAY:
                    return (ComponentFactory.Instance.creatBitmap("asset.IM.awayIconAsset"));
                case PlayerState.BUSY:
                    return (ComponentFactory.Instance.creatBitmap("asset.IM.busyIconAsset"));
                case PlayerState.NO_DISTRUB:
                    return (ComponentFactory.Instance.creatBitmap("asset.IM.noDistrubIconAsset"));
                case PlayerState.SHOPPING:
                    return (ComponentFactory.Instance.creatBitmap("asset.IM.shoppingIconAsset"));
            };
            return (null);
        }

        override public function get height():Number
        {
            return (22);
        }

        override public function get width():Number
        {
            return (80);
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
            removeEventListener(MouseEvent.MOUSE_OVER, this.__over);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__out);
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
            ObjectUtils.disposeObject(this._overBg);
            this._overBg = null;
            ObjectUtils.disposeObject(this._stateName);
            this._stateName = null;
            this._date = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package im

