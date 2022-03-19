// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.view.closeFriend.LevelUpAwardFramePlayerItem

package platformapi.tencent.view.closeFriend
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.cell.IListCell;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.player.InvitedFirendListPlayer;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    import com.pickgliss.ui.controls.list.List;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    public class LevelUpAwardFramePlayerItem extends Sprite implements Disposeable, IListCell 
    {

        private var _BG:Bitmap;
        private var _textField:FilterFrameText;
        private var _info:InvitedFirendListPlayer;

        public function LevelUpAwardFramePlayerItem()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            this._BG = ComponentFactory.Instance.creatBitmap("asset.IM.levelUpFrame.playerItemBG");
            this._BG.alpha = 0;
            this._textField = ComponentFactory.Instance.creatComponentByStylename("IMFrame.levelUpAward.playerItem.txt");
            addChild(this._BG);
            addChild(this._textField);
        }

        private function initEvent():void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.__onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.__onMouseOut);
        }

        private function __onMouseOver(_arg_1:MouseEvent):void
        {
            Mouse.cursor = MouseCursor.BUTTON;
        }

        private function __onMouseOut(_arg_1:MouseEvent):void
        {
            Mouse.cursor = MouseCursor.AUTO;
        }

        public function setListCellStatus(_arg_1:List, _arg_2:Boolean, _arg_3:int):void
        {
            if (this._BG)
            {
                this._BG.alpha = ((_arg_2) ? 1 : 0);
            };
        }

        public function getCellValue():*
        {
            return (this._info);
        }

        public function get info():InvitedFirendListPlayer
        {
            return (this._info);
        }

        public function setCellValue(_arg_1:*):void
        {
            this._info = _arg_1;
            this._textField.text = this._info.NickName;
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
            if (this._BG)
            {
                ObjectUtils.disposeObject(this._BG);
            };
            this._BG = null;
            if (this._textField)
            {
                ObjectUtils.disposeObject(this._textField);
            };
            this._textField = null;
            this._info = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package platformapi.tencent.view.closeFriend

