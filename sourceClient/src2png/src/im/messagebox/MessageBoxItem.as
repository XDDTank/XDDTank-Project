﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.messagebox.MessageBoxItem

package im.messagebox
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import im.info.PresentRecordInfo;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import flash.display.Bitmap;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import im.IMController;
    import flash.events.Event;
    import ddt.manager.PlayerManager;
    import ddt.manager.SocketManager;
    import ddt.events.PlayerPropertyEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class MessageBoxItem extends Sprite implements Disposeable 
    {

        public static const DELETE:String = "delete";

        private var _recordInfo:PresentRecordInfo;
        private var _hotArea:Sprite;
        private var _stateImg:ScaleFrameImage;
        private var _sex:ScaleFrameImage;
        private var _name:FilterFrameText;
        private var _delete:SimpleBitmapButton;
        private var _newSign:Bitmap;
        private var _PlayerInfo:PlayerInfo;

        public function MessageBoxItem()
        {
            this._stateImg = ComponentFactory.Instance.creatComponentByStylename("messageboxItem.bg");
            this._sex = ComponentFactory.Instance.creatComponentByStylename("core.im.CityIcon");
            this._name = ComponentFactory.Instance.creatComponentByStylename("messageboxItem.name");
            this._newSign = ComponentFactory.Instance.creatBitmap("asset.messagebox.newSign");
            this._delete = ComponentFactory.Instance.creatComponentByStylename("messageboxItem.delete");
            this._hotArea = new Sprite();
            this._hotArea.graphics.beginFill(0, 0);
            this._hotArea.graphics.drawRect(0, 0, this._stateImg.width, this._stateImg.height);
            this._hotArea.graphics.endFill();
            addChild(this._hotArea);
            addChild(this._stateImg);
            addChild(this._sex);
            addChild(this._name);
            addChild(this._newSign);
            addChild(this._delete);
            PositionUtils.setPos(this._sex, "messagebox.sexPos");
            this._delete.visible = false;
            addEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
            addEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
            this._delete.addEventListener(MouseEvent.CLICK, this.__deleteHandler);
        }

        override public function get height():Number
        {
            return (this._stateImg.height);
        }

        protected function __deleteHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
            IMController.Instance.removePrivateMessage(this._recordInfo.id);
            dispatchEvent(new Event(DELETE));
        }

        protected function __outHandler(_arg_1:MouseEvent):void
        {
            if (this._recordInfo.exist == PresentRecordInfo.UNREAD)
            {
                this._stateImg.visible = true;
                this._stateImg.setFrame(2);
            }
            else
            {
                this._stateImg.visible = false;
            };
            this._delete.visible = false;
        }

        protected function __overHandler(_arg_1:MouseEvent):void
        {
            this._delete.visible = true;
            this._stateImg.visible = true;
            this._stateImg.setFrame(1);
        }

        public function set recordInfo(_arg_1:PresentRecordInfo):void
        {
            this._recordInfo = _arg_1;
            if (_arg_1.exist == PresentRecordInfo.UNREAD)
            {
                this._newSign.visible = true;
                this._stateImg.visible = true;
                this._stateImg.setFrame(2);
            }
            else
            {
                this._newSign.visible = false;
                this._stateImg.visible = false;
            };
            this._PlayerInfo = PlayerManager.Instance.findPlayer(_arg_1.id);
            if ((!(this._PlayerInfo.NickName)))
            {
                SocketManager.Instance.out.sendItemEquip(_arg_1.id, false);
                this._PlayerInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__infoHandler);
            }
            else
            {
                this._sex.setFrame(((this._PlayerInfo.Sex) ? 1 : 2));
                this._name.text = this._PlayerInfo.NickName;
            };
        }

        protected function __infoHandler(_arg_1:Event):void
        {
            this._PlayerInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__infoHandler);
            this._sex.setFrame(((this._PlayerInfo.Sex) ? 1 : 2));
            this._name.text = this._PlayerInfo.NickName;
        }

        public function get recordInfo():PresentRecordInfo
        {
            return (this._recordInfo);
        }

        public function dispose():void
        {
            removeEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
            removeEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
            this._delete.removeEventListener(MouseEvent.CLICK, this.__deleteHandler);
            this._recordInfo = null;
            if (this._hotArea)
            {
                ObjectUtils.disposeObject(this._hotArea);
            };
            this._hotArea = null;
            if (this._stateImg)
            {
                ObjectUtils.disposeObject(this._stateImg);
            };
            this._stateImg = null;
            if (this._sex)
            {
                ObjectUtils.disposeObject(this._sex);
            };
            this._sex = null;
            if (this._name)
            {
                ObjectUtils.disposeObject(this._name);
            };
            this._name = null;
            if (this._delete)
            {
                ObjectUtils.disposeObject(this._delete);
            };
            this._delete = null;
            if (this._newSign)
            {
                ObjectUtils.disposeObject(this._newSign);
            };
            this._newSign = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package im.messagebox

