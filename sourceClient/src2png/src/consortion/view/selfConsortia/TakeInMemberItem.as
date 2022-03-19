// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.TakeInMemberItem

package consortion.view.selfConsortia
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import consortion.data.ConsortiaApplyInfo;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;
    import ddt.view.common.LevelIcon;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import vip.VipController;
    import ddt.data.player.BasePlayer;
    import ddt.utils.PositionUtils;
    import ddt.manager.SoundManager;
    import bagAndInfo.info.PlayerInfoViewControl;
    import ddt.manager.PlayerManager;
    import ddt.manager.SocketManager;

    public class TakeInMemberItem extends Sprite implements Disposeable 
    {

        private var _backGroud:ScaleFrameImage;
        public var FightPower:int;
        public var Level:int;
        private var _selected:Boolean;
        private var _info:ConsortiaApplyInfo;
        private var _nameSelect:SelectedCheckButton;
        private var _name:FilterFrameText;
        private var _nameForVip:GradientText;
        private var _level:LevelIcon;
        private var _power:FilterFrameText;
        private var _check:TextButton;
        private var _agree:TextButton;
        private var _refuse:TextButton;

        public function TakeInMemberItem()
        {
            this.initView();
            this.initEvent();
        }

        override public function get height():Number
        {
            return (30);
        }

        private function initView():void
        {
            this._selected = false;
            this._backGroud = ComponentFactory.Instance.creatComponentByStylename("applyItem.BG");
            this._nameSelect = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.select");
            this._name = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.name");
            this._level = ComponentFactory.Instance.creatCustomObject("consortion.takeIn.levelIcon");
            this._power = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.power");
            this._check = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.check");
            this._check.text = LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.view");
            this._agree = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.agree");
            this._agree.text = LanguageMgr.GetTranslation("tank.gametrainer.view.agree");
            this._refuse = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.refuse");
            this._refuse.text = LanguageMgr.GetTranslation("tank.view.common.NPCPairingDialog.refuse");
            addChild(this._backGroud);
            addChild(this._level);
            addChild(this._power);
            this._level.setSize(LevelIcon.SIZE_SMALL);
        }

        private function initEvent():void
        {
            this._nameSelect.addEventListener(MouseEvent.CLICK, this.__selectHandler);
            this._check.addEventListener(MouseEvent.CLICK, this.__checkHandler);
            this._agree.addEventListener(MouseEvent.CLICK, this.__agreeHandler);
            this._refuse.addEventListener(MouseEvent.CLICK, this.__refuseHandler);
        }

        private function removeEvent():void
        {
            this._nameSelect.removeEventListener(MouseEvent.CLICK, this.__selectHandler);
            this._check.removeEventListener(MouseEvent.CLICK, this.__checkHandler);
            this._agree.removeEventListener(MouseEvent.CLICK, this.__agreeHandler);
            this._refuse.removeEventListener(MouseEvent.CLICK, this.__refuseHandler);
        }

        public function updateBaceGroud(_arg_1:int):void
        {
            if ((_arg_1 % 2) != 0)
            {
                this._backGroud.setFrame(2);
            }
            else
            {
                this._backGroud.setFrame(1);
            };
        }

        public function set selected(_arg_1:Boolean):void
        {
            this._selected = _arg_1;
            this._nameSelect.selected = _arg_1;
        }

        public function get selected():Boolean
        {
            return (this._nameSelect.selected);
        }

        public function set info(_arg_1:ConsortiaApplyInfo):void
        {
            this._info = _arg_1;
            addChild(this._nameSelect);
            addChild(this._check);
            addChild(this._agree);
            addChild(this._refuse);
            if (this._info.IsVIP)
            {
                ObjectUtils.disposeObject(this._nameForVip);
                this._nameForVip = VipController.instance.getVipNameTxt(113, 1);
                this._nameForVip.textSize = 16;
                this._nameForVip.x = this._name.x;
                this._nameForVip.y = this._name.y;
                this._nameForVip.text = this._info.UserName;
                this._nameSelect.addChild(this._nameForVip);
            };
            this._name.text = this._info.UserName;
            if (this._name.text.length > 12)
            {
                this._name.text = (this._name.text.substr(0, 12) + ".");
            };
            this._nameSelect.addChild(this._name);
            var _local_2:BasePlayer = new BasePlayer();
            _local_2.isOld = this._info.IsOld;
            _local_2.IsVIP = this._info.IsVIP;
            PositionUtils.adaptNameStyle(_local_2, this._name, this._nameForVip);
            this._level.setInfo(this._info.UserLevel, this._info.Repute, this._info.Win, this._info.Total, this._info.FightPower, this._info.Offer);
            this.Level = this._info.UserLevel;
            this._power.text = String(this._info.FightPower);
            this.FightPower = this._info.FightPower;
        }

        public function get info():ConsortiaApplyInfo
        {
            return (this._info);
        }

        private function __selectHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.selected = ((this._selected == true) ? false : true);
        }

        private function __checkHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            PlayerInfoViewControl.viewByID(this._info.UserID, PlayerManager.Instance.Self.ZoneID);
        }

        private function __agreeHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendConsortiaTryinPass(this._info.ID);
        }

        private function __refuseHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendConsortiaTryinDelete(this._info.ID);
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            this._backGroud = null;
            this._nameSelect = null;
            this._nameForVip = null;
            this._level = null;
            this._name = null;
            this._power = null;
            this._check = null;
            this._agree = null;
            this._refuse = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

