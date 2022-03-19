// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//login.view.RoleItem

package login.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.cell.IListCell;
    import ddt.data.Role;
    import flash.display.Bitmap;
    import ddt.view.common.LevelIcon;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.controls.list.List;
    import flash.display.DisplayObject;

    public class RoleItem extends Sprite implements Disposeable, IListCell 
    {

        private var _roleInfo:Role;
        private var _backImage:Bitmap;
        private var _levelIcon:LevelIcon;
        private var _nicknameField:FilterFrameText;
        private var _data:Object;
        private var _light:ScaleBitmapImage;
        private var _isSelected:Boolean;

        public function RoleItem()
        {
            mouseChildren = false;
            buttonMode = true;
            this.configUi();
            this.initEvent();
        }

        private function configUi():void
        {
            this._backImage = ComponentFactory.Instance.creatBitmap("login.chooserole.cell.bg");
            addChild(this._backImage);
            this._levelIcon = ComponentFactory.Instance.creatCustomObject("login.ChooseRole.cell.LevelIcon");
            this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
            addChild(this._levelIcon);
            this._nicknameField = ComponentFactory.Instance.creatComponentByStylename("login.ChooseRole.Nickname");
            addChild(this._nicknameField);
            this._light = ComponentFactory.Instance.creatComponentByStylename("login.ChooseRoleListItem.light");
            addChild(this._light);
            this._light.visible = false;
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
            this._light.visible = true;
        }

        private function __mouseOutHandler(_arg_1:MouseEvent):void
        {
            this._light.visible = this._isSelected;
        }

        public function get selected():Boolean
        {
            return (this._isSelected);
        }

        public function set selected(_arg_1:Boolean):void
        {
            this._light.visible = (this._isSelected = _arg_1);
        }

        public function get roleInfo():Role
        {
            return (this._roleInfo);
        }

        public function set roleInfo(_arg_1:Role):void
        {
            this._roleInfo = _arg_1;
            this._levelIcon.setInfo(this._roleInfo.Grade, 0, this._roleInfo.WinCount, this._roleInfo.TotalCount, 1, 0);
            this._nicknameField.text = this._roleInfo.NickName;
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._backImage)
            {
                ObjectUtils.disposeObject(this._backImage);
                this._backImage.bitmapData.dispose();
                this._backImage.bitmapData = null;
                this._backImage = null;
            };
            if (this._levelIcon)
            {
                ObjectUtils.disposeObject(this._levelIcon);
                this._levelIcon = null;
            };
            if (this._nicknameField)
            {
                ObjectUtils.disposeObject(this._nicknameField);
                this._nicknameField = null;
            };
            if (this._light)
            {
                ObjectUtils.disposeObject(this._light);
                this._light = null;
            };
        }

        public function setListCellStatus(_arg_1:List, _arg_2:Boolean, _arg_3:int):void
        {
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function getCellValue():*
        {
            return (this._data);
        }

        public function setCellValue(_arg_1:*):void
        {
            this._data = _arg_1;
            this.roleInfo = (this._data as Role);
        }


    }
}//package login.view

