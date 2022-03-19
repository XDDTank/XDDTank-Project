// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//civil.view.CivilPlayerItemFrame

package civil.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.data.player.CivilPlayerInfo;
    import ddt.view.common.LevelIcon;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import ddt.manager.PlayerManager;
    import ddt.events.PlayerPropertyEvent;
    import ddt.manager.SoundManager;
    import civil.CivilEvent;
    import com.pickgliss.utils.ObjectUtils;
    import vip.VipController;
    import ddt.utils.PositionUtils;

    public class CivilPlayerItemFrame extends Sprite implements Disposeable 
    {

        private var _info:CivilPlayerInfo;
        private var _level:int = 1;
        private var _levelIcon:LevelIcon;
        private var _isSelect:Boolean;
        private var _selectEffect:ScaleLeftRightImage;
        private var _nameTxt:FilterFrameText;
        private var _vipName:GradientText;
        private var _stateIcon:ScaleFrameImage;
        private var _bg:ScaleFrameImage;
        private var _selected:Boolean = false;
        private var _index:int;

        public function CivilPlayerItemFrame(_arg_1:int)
        {
            buttonMode = true;
            this._index = _arg_1;
            super();
            this.init();
        }

        private function init():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.rightview.signalLineBg");
            if (((this._index % 2) == 0))
            {
                this._bg.setFrame(1);
            }
            else
            {
                this._bg.setFrame(2);
            };
            addChild(this._bg);
            this._selectEffect = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.rightview.signalLine.selected");
            addChild(this._selectEffect);
            this._selectEffect.visible = false;
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.SelectBGPlayerName");
            this._levelIcon = ComponentFactory.Instance.creatCustomObject("ddtcivil.levelIcon_list");
            this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
            addChild(this._levelIcon);
            this._stateIcon = ComponentFactory.Instance.creat("ddtcivil.state_icon");
            addChild(this._stateIcon);
        }

        public function set info(_arg_1:CivilPlayerInfo):void
        {
            this._info = _arg_1;
            this.upView();
            this.addEvent();
        }

        public function get info():CivilPlayerInfo
        {
            return (this._info);
        }

        private function addEvent():void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.__overHandle);
            addEventListener(MouseEvent.MOUSE_OUT, this.__outHandle);
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__offerChange);
        }

        private function removeEvent():void
        {
            removeEventListener(MouseEvent.MOUSE_OVER, this.__overHandle);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__outHandle);
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__offerChange);
        }

        private function __offerChange(_arg_1:PlayerPropertyEvent):void
        {
            if (_arg_1.changedProperties["isVip"])
            {
                this.upView();
            };
        }

        private function __clickHandle(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            dispatchEvent(new CivilEvent(CivilEvent.SELECT_CLICK_ITEM, this));
        }

        private function __overHandle(_arg_1:MouseEvent):void
        {
            if ((!(this._selected)))
            {
                this._selectEffect.visible = true;
            };
        }

        private function __outHandle(_arg_1:MouseEvent):void
        {
            if ((!(this._selected)))
            {
                this._selectEffect.visible = false;
            };
        }

        public function get selected():Boolean
        {
            return (this._selected);
        }

        public function set selected(_arg_1:Boolean):void
        {
            if (this._selected != _arg_1)
            {
                this._selected = _arg_1;
                this._selectEffect.visible = this._selected;
            };
        }

        private function upView():void
        {
            this._nameTxt.text = this._info.info.NickName;
            if (this._info.info.IsVIP)
            {
                ObjectUtils.disposeObject(this._vipName);
                this._vipName = VipController.instance.getVipNameTxt(129, this._info.info.VIPtype);
                this._vipName.x = this._nameTxt.x;
                this._vipName.y = this._nameTxt.y;
                this._vipName.text = this._nameTxt.text;
                addChild(this._vipName);
            };
            addChild(this._nameTxt);
            PositionUtils.adaptNameStyle(this._info.info, this._nameTxt, this._vipName);
            this._levelIcon.setInfo(this._info.info.Grade, this._info.info.Repute, this._info.info.WinCount, this._info.info.TotalCount, this._info.info.FightPower, this._info.info.Offer, true, false);
            if (this._info.info.Sex)
            {
                this._stateIcon.setFrame(((this._info.info.playerState.StateID) ? 1 : 3));
            }
            else
            {
                this._stateIcon.setFrame(((this._info.info.playerState.StateID) ? 2 : 3));
            };
        }

        override public function get height():Number
        {
            if (this._bg == null)
            {
                return (0);
            };
            return (this._bg.y + this._bg.height);
        }

        public function dispose():void
        {
            this._info = null;
            if (this._levelIcon)
            {
                this._levelIcon.dispose();
                this._levelIcon = null;
            };
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._selectEffect)
            {
                ObjectUtils.disposeObject(this._selectEffect);
            };
            this._selectEffect = null;
            ObjectUtils.disposeObject(this._stateIcon);
            this._stateIcon = null;
            ObjectUtils.disposeObject(this._nameTxt);
            this._nameTxt = null;
            if (this._vipName)
            {
                ObjectUtils.disposeObject(this._vipName);
            };
            this._vipName = null;
            this.removeEvent();
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package civil.view

