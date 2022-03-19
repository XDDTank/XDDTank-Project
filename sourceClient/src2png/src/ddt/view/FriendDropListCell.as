// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.FriendDropListCell

package ddt.view
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.controls.cell.IDropListCell;
    import ddt.view.common.SexIcon;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;

    public class FriendDropListCell extends Component implements IDropListCell 
    {

        private var _sex_icon:SexIcon;
        private var _data:String;
        private var _textField:FilterFrameText;
        private var _selected:Boolean;
        private var _bg:Bitmap;


        override protected function init():void
        {
            super.init();
            this._bg = ComponentFactory.Instance.creat("asset.core.comboxItembg3");
            this._bg.width = 220;
            this._textField = ComponentFactory.Instance.creatComponentByStylename("droplist.CellText");
            this._sex_icon = new SexIcon();
            PositionUtils.setPos(this._sex_icon, "IM.IMLookup.SexPos");
            this._bg.alpha = 0;
            width = this._bg.width;
            height = this._bg.height;
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._bg)
            {
                addChild(this._bg);
            };
            if (this._textField)
            {
                addChild(this._textField);
            };
            if (this._sex_icon)
            {
                addChild(this._sex_icon);
            };
        }

        public function get selected():Boolean
        {
            return (this._selected);
        }

        public function set selected(_arg_1:Boolean):void
        {
            this._selected = _arg_1;
            if (this._selected)
            {
                this._bg.alpha = 1;
            }
            else
            {
                this._bg.alpha = 0;
            };
        }

        public function getCellValue():*
        {
            if (this._data)
            {
                return ((this._data as PlayerInfo).NickName);
            };
            return ("");
        }

        public function setCellValue(_arg_1:*):void
        {
            this._data = _arg_1;
            if (_arg_1)
            {
                this._textField.text = _arg_1.NickName;
                this._sex_icon.visible = true;
                this._sex_icon.setSex(_arg_1.Sex);
            }
            else
            {
                this._textField.text = LanguageMgr.GetTranslation("ddt.FriendDropListCell.noFriend");
                this._sex_icon.visible = false;
            };
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._sex_icon)
            {
                ObjectUtils.disposeObject(this._sex_icon);
            };
            this._sex_icon = null;
            if (this._textField)
            {
                ObjectUtils.disposeObject(this._textField);
            };
            this._textField = null;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package ddt.view

